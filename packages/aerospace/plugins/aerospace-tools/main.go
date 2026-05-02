package main

import (
	"os"
	"os/exec"
	"strings"
)

var workspaces = []string{"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}

func main() {
	if len(os.Args) < 2 {
		return
	}

	switch os.Args[1] {
	case "sketchybar-update":
		sketchybarUpdate()
	case "workspace-next":
		workspaceSwitch(1)
	case "workspace-prev":
		workspaceSwitch(-1)
	}
}

func sketchybarUpdate() {
	focused := os.Getenv("FOCUSED_WORKSPACE")
	if focused == "" {
		out, err := exec.Command("aerospace", "list-workspaces", "--focused").Output()
		if err != nil {
			return
		}
		focused = strings.TrimSpace(string(out))
	}

	// Get all windows in one call: "workspace|app-name" per line
	out, err := exec.Command("aerospace", "list-windows", "--all", "--format", "%{workspace}|%{app-name}").Output()
	if err != nil {
		return
	}

	// Build workspace -> []app map
	apps := make(map[string][]string)
	for _, line := range strings.Split(strings.TrimSpace(string(out)), "\n") {
		parts := strings.SplitN(line, "|", 2)
		if len(parts) == 2 {
			ws := strings.TrimSpace(parts[0])
			app := strings.TrimSpace(parts[1])
			apps[ws] = append(apps[ws], app)
		}
	}

	// Build sketchybar args for all workspaces
	var args []string
	for _, sid := range workspaces {
		name := "space." + sid

		label := sid
		if appList, ok := apps[sid]; ok && len(appList) > 0 {
			label = sid + " " + strings.Join(appList, "·")
		}

		drawing := "off"
		if len(apps[sid]) > 0 || sid == focused {
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

	exec.Command("sketchybar", args...).Run()
}

func workspaceSwitch(direction int) {
	// Get non-empty workspaces
	out, err := exec.Command("aerospace", "list-workspaces", "--monitor", "focused", "--empty", "no").Output()
	if err != nil {
		return
	}
	nonEmptySet := make(map[string]bool)
	for _, ws := range strings.Fields(strings.TrimSpace(string(out))) {
		nonEmptySet[ws] = true
	}

	// Get current workspace
	out, err = exec.Command("aerospace", "list-workspaces", "--focused").Output()
	if err != nil {
		return
	}
	current := strings.TrimSpace(string(out))

	// Find current index in workspaces array
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

	// Walk in direction until we hit a non-empty workspace
	n := len(workspaces)
	for step := 1; step < n; step++ {
		candidate := workspaces[(idx+direction*step+n*step)%n]
		if nonEmptySet[candidate] {
			exec.Command("aerospace", "workspace", candidate).Run()
			return
		}
	}
}
