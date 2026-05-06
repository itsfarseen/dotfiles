package main

import (
	"bufio"
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"strings"
)

var logFile *os.File

func init() {
	var err error
	logFile, err = os.OpenFile("/tmp/aerotools.log", os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0644)
	if err != nil {
		logFile = nil
	}
}

func trace(format string, args ...any) {
	msg := fmt.Sprintf("[aerotools] "+format+"\n", args...)
	fmt.Fprint(os.Stderr, msg)
	if logFile != nil {
		fmt.Fprint(logFile, msg)
	}
}

var workspaces = []string{"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}

func main() {
	if len(os.Args) < 2 {
		return
	}

	switch os.Args[1] {
	case "sketchybar-update":
		cmdSketchybarUpdate()
	case "workspace-next":
		switchWorkspace(1)
	case "workspace-prev":
		switchWorkspace(-1)
	case "on-workspace-change":
		cmdOnWorkspaceChange()
	}
}

// --- Data types ---

type windowInfo struct {
	id, workspace, app, title string
}

type config struct {
	sketchybarUpdate bool
	pinWindows       []string // title regexes
}

// --- Shared helpers ---

func loadConfig() config {
	cfg := config{sketchybarUpdate: true}

	exePath, err := os.Executable()
	if err != nil {
		return cfg
	}
	cfgPath := filepath.Join(filepath.Dir(exePath), "..", "aerotools.cfg")

	f, err := os.Open(cfgPath)
	if err != nil {
		trace("config: failed to open %s: %v", cfgPath, err)
		return cfg
	}
	trace("config: loaded %s", cfgPath)
	defer f.Close()

	scanner := bufio.NewScanner(f)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		key, value, ok := strings.Cut(line, "=")
		if !ok {
			continue
		}
		key = strings.TrimSpace(key)
		value = strings.TrimSpace(value)
		switch key {
		case "sketchybar_update":
			cfg.sketchybarUpdate = value == "true"
		case "pin_window":
			if value != "" {
				cfg.pinWindows = append(cfg.pinWindows, value)
			}
		}
	}
	return cfg
}

func compilePinRegexes(patterns []string) []*regexp.Regexp {
	var regexes []*regexp.Regexp
	for _, pattern := range patterns {
		re, err := regexp.Compile(pattern)
		if err != nil {
			trace("pinned: invalid regex %q: %v", pattern, err)
			continue
		}
		regexes = append(regexes, re)
	}
	return regexes
}

func getFocusedWorkspace() string {
	focused := os.Getenv("FOCUSED_WORKSPACE")
	if focused != "" {
		trace("focused workspace=%s (from FOCUSED_WORKSPACE env)", focused)
		return focused
	}
	out, err := exec.Command("aerospace", "list-workspaces", "--focused").Output()
	if err != nil {
		return ""
	}
	focused = strings.TrimSpace(string(out))
	trace("focused workspace=%s (from aerospace query)", focused)
	return focused
}

func listAllWindows() []windowInfo {
	out, err := exec.Command("aerospace", "list-windows", "--all",
		"--format", "%{window-id}|%{workspace}|%{app-name}|%{window-title}").Output()
	if err != nil {
		trace("list-windows: failed: %v", err)
		return nil
	}

	var windows []windowInfo
	for _, line := range strings.Split(strings.TrimSpace(string(out)), "\n") {
		parts := strings.SplitN(line, "|", 4)
		if len(parts) < 3 {
			continue
		}
		w := windowInfo{
			id:        strings.TrimSpace(parts[0]),
			workspace: strings.TrimSpace(parts[1]),
			app:       strings.TrimSpace(parts[2]),
		}
		if len(parts) == 4 {
			w.title = strings.TrimSpace(parts[3])
		}
		windows = append(windows, w)
	}
	return windows
}

func buildWsApps(windows []windowInfo, pinnedRegexes []*regexp.Regexp) map[string][]string {
	apps := make(map[string][]string)
	for _, w := range windows {
		pinned := false
		for _, re := range pinnedRegexes {
			if re.MatchString(w.title) {
				pinned = true
				break
			}
		}
		if pinned {
			continue
		}
		apps[w.workspace] = append(apps[w.workspace], w.app)
	}
	return apps
}

// --- Action functions ---

func updateSketchybar(focused string, wsApps map[string][]string) {
	var args []string
	for _, sid := range workspaces {
		name := "space." + sid

		label := sid
		if appList, ok := wsApps[sid]; ok && len(appList) > 0 {
			label = sid + " " + strings.Join(appList, "·")
		}

		drawing := "off"
		if len(wsApps[sid]) > 0 || sid == focused {
			drawing = "on"
		}

		bgDrawing := "off"
		if sid == focused {
			bgDrawing = "on"
		}

		args = append(args, "--set", name,
			"drawing="+drawing,
			"background.drawing="+bgDrawing,
			"label="+label,
			"label.color=0xffffffff",
		)
	}

	trace("sketchybar: updating with %d workspace entries", len(workspaces))
	exec.Command("sketchybar", args...).Run()
}

func movePinnedWindows(focused string, windows []windowInfo, regexes []*regexp.Regexp) {
	if len(regexes) == 0 {
		trace("pinned: no pin_window rules defined")
		return
	}
	trace("pinned: %d rule(s) defined", len(regexes))

	matched := 0
	for _, w := range windows {
		for _, re := range regexes {
			if re.MatchString(w.title) {
				trace("pinned: match window %s %q -> moving to workspace %s", w.id, w.title, focused)
				cmd := exec.Command("aerospace", "move-node-to-workspace", "--window-id", w.id, focused)
				if out, err := cmd.CombinedOutput(); err != nil {
					trace("pinned: move failed: %v: %s", err, strings.TrimSpace(string(out)))
				} else {
					trace("pinned: move succeeded for window %s", w.id)
				}
				matched++
				break
			}
		}
	}
	if matched == 0 {
		trace("pinned: no windows matched any rules")
	}
}

func switchWorkspace(direction int) {
	out, err := exec.Command("aerospace", "list-workspaces", "--monitor", "focused", "--empty", "no").Output()
	if err != nil {
		return
	}
	nonEmptySet := make(map[string]bool)
	for _, ws := range strings.Fields(strings.TrimSpace(string(out))) {
		nonEmptySet[ws] = true
	}

	out, err = exec.Command("aerospace", "list-workspaces", "--focused").Output()
	if err != nil {
		return
	}
	current := strings.TrimSpace(string(out))

	idx := -1
	for i, ws := range workspaces {
		if ws == current {
			idx = i
			break
		}
	}
	if idx == -1 {
		return
	}

	n := len(workspaces)
	for step := 1; step < n; step++ {
		candidate := workspaces[(idx+direction*step+n*step)%n]
		if nonEmptySet[candidate] {
			exec.Command("aerospace", "workspace", candidate).Run()
			return
		}
	}
}

// --- Orchestrators ---

func cmdSketchybarUpdate() {
	cfg := loadConfig()
	regexes := compilePinRegexes(cfg.pinWindows)
	focused := getFocusedWorkspace()
	windows := listAllWindows()
	wsApps := buildWsApps(windows, regexes)
	updateSketchybar(focused, wsApps)
}

func cmdOnWorkspaceChange() {
	cfg := loadConfig()
	regexes := compilePinRegexes(cfg.pinWindows)
	focused := getFocusedWorkspace()

	if focused == "" {
		trace("on-workspace-change: no focused workspace, skipping")
		return
	}

	windows := listAllWindows()

	if cfg.sketchybarUpdate {
		wsApps := buildWsApps(windows, regexes)
		updateSketchybar(focused, wsApps)
	} else {
		trace("sketchybar: update skipped (disabled in config)")
	}

	movePinnedWindows(focused, windows, regexes)
}
