package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
	"syscall"

	"charm.land/bubbles/v2/textinput"
	tea "charm.land/bubbletea/v2"
	"charm.land/lipgloss/v2"
)

var logFile *os.File

func init() {
	var err error
	logFile, err = os.OpenFile("/tmp/tmux-tools.log", os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0644)
	if err != nil {
		logFile = nil
	}
}

func trace(format string, args ...any) {
	msg := fmt.Sprintf("[tmux-tools] "+format+"\n", args...)
	fmt.Fprint(os.Stderr, msg)
	if logFile != nil {
		fmt.Fprint(logFile, msg)
	}
}

// --- Model ---

type model struct {
	input    textinput.Model
	sessions []string
	filtered []string
	cursor   int
	chosen   string
	newSess  bool
	escaped  bool
	quitting bool
	width    int
	height   int
}

func initialModel(sessions []string) model {
	ti := textinput.New()
	ti.Placeholder = "search..."
	ti.Prompt = "/ "
	ti.Focus()
	ti.CharLimit = 64
	ti.SetWidth(44) // innerWidth (46) - prompt "/ " (2)

	s := ti.Styles()
	s.Focused.Prompt = lipgloss.NewStyle().Foreground(lipgloss.Color("4")).Bold(true)
	s.Focused.Text = lipgloss.NewStyle().Foreground(lipgloss.Color("15"))
	s.Focused.Placeholder = lipgloss.NewStyle().Foreground(lipgloss.Color("8"))
	ti.SetStyles(s)

	return model{
		input:    ti,
		sessions: sessions,
		filtered: sessions,
	}
}

func (m model) Init() tea.Cmd {
	return textinput.Blink
}

func (m model) filteredSessions() []string {
	query := strings.ToLower(m.input.Value())
	if query == "" {
		return m.sessions
	}
	var results []string
	for _, s := range m.sessions {
		if strings.Contains(strings.ToLower(s), query) {
			results = append(results, s)
		}
	}
	return results
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {
	case tea.WindowSizeMsg:
		m.width = msg.Width
		m.height = msg.Height
		return m, nil

	case tea.KeyMsg:
		switch msg.String() {
		case "ctrl+c":
			m.quitting = true
			return m, tea.Quit
		case "escape":
			m.escaped = true
			m.quitting = true
			return m, tea.Quit
		case "up":
			if m.cursor > 0 {
				m.cursor--
			}
			return m, nil
		case "down":
			max := len(m.filtered) // +1 for "New Session" entry, -1 for 0-index = same
			if m.cursor < max {
				m.cursor++
			}
			return m, nil
		case "enter":
			if m.cursor < len(m.filtered) {
				m.chosen = m.filtered[m.cursor]
			} else {
				// "New Session" entry
				m.newSess = true
				m.chosen = m.input.Value()
			}
			m.quitting = true
			return m, tea.Quit
		}
	}

	var cmd tea.Cmd
	m.input, cmd = m.input.Update(msg)

	// Recompute filtered list on input change
	m.filtered = m.filteredSessions()
	// Clamp cursor
	max := len(m.filtered) // last index = "New Session"
	if m.cursor > max {
		m.cursor = max
	}

	return m, cmd
}

// --- Styles ---

var (
	titleStyle     = lipgloss.NewStyle().Bold(true).Foreground(lipgloss.Color("4"))  // blue
	separatorStyle = lipgloss.NewStyle().Foreground(lipgloss.Color("8"))              // bright black (dark gray)
	normalStyle    = lipgloss.NewStyle().Foreground(lipgloss.Color("7"))              // white (dimmed)
	selectedStyle  = lipgloss.NewStyle().Foreground(lipgloss.Color("15")).Bold(true).Background(lipgloss.Color("8")) // bright white on dark gray
	newSessStyle   = lipgloss.NewStyle().Foreground(lipgloss.Color("6")).Italic(true)  // cyan
	newSelStyle    = lipgloss.NewStyle().Foreground(lipgloss.Color("14")).Bold(true).Italic(true).Background(lipgloss.Color("8")) // bright cyan on dark gray
	boxStyle       = lipgloss.NewStyle().Border(lipgloss.RoundedBorder()).BorderForeground(lipgloss.Color("8")).Width(48)
)

func (m model) View() tea.View {
	if m.quitting {
		return tea.NewView("")
	}

	var b strings.Builder
	innerWidth := 46 // boxStyle width (48) - border (2)

	b.WriteString(titleStyle.Render("Tmux Sessions"))
	b.WriteString("\n")
	b.WriteString(m.input.View())
	b.WriteString("\n")
	b.WriteString(separatorStyle.Render(strings.Repeat("─", innerWidth)))
	b.WriteString("\n")

	// Session list
	for i, s := range m.filtered {
		if i == m.cursor {
			line := "❯ " + s
			padded := line + strings.Repeat(" ", max(innerWidth-lipgloss.Width(line), 0))
			b.WriteString(selectedStyle.Render(padded))
		} else {
			line := "  " + s
			b.WriteString(normalStyle.Render(line))
		}
		b.WriteString("\n")
	}

	// "New Session" entry
	query := m.input.Value()
	newLabel := "+ New Session"
	if query != "" {
		newLabel = "+ New: " + query
	}
	if m.cursor == len(m.filtered) {
		line := "❯ " + newLabel
		padded := line + strings.Repeat(" ", max(innerWidth-lipgloss.Width(line), 0))
		b.WriteString(newSelStyle.Render(padded))
	} else {
		b.WriteString(newSessStyle.Render("  " + newLabel))
	}

	content := boxStyle.Render(b.String())

	// Center horizontally, position ~33% from top
	if m.width > 0 && m.height > 0 {
		contentHeight := strings.Count(content, "\n") + 1
		topPad := max((m.height-contentHeight)/3, 0)
		content = strings.Repeat("\n", topPad) + content
		content = lipgloss.Place(m.width, m.height, lipgloss.Center, lipgloss.Top, content)
	}

	v := tea.NewView(content)
	v.AltScreen = true
	return v
}

// --- Tmux helpers ---

func listTmuxSessions() []string {
	out, err := exec.Command("tmux", "list-sessions", "-F", "#{session_name}").Output()
	if err != nil {
		return nil
	}
	var sessions []string
	for _, l := range strings.Split(strings.TrimSpace(string(out)), "\n") {
		l = strings.TrimSpace(l)
		if l != "" {
			sessions = append(sessions, l)
		}
	}
	return sessions
}

func findNextTempSession(existing []string) string {
	set := make(map[string]bool)
	for _, s := range existing {
		set[s] = true
	}
	for i := range 1000 {
		name := fmt.Sprintf("temp-%03d", i)
		if !set[name] {
			return name
		}
	}
	return "temp-overflow"
}

func attachOrSwitch(session string, isNew bool) {
	inTmux := os.Getenv("TMUX") != ""

	if isNew || !sessionExists(session) {
		trace("creating new session: %s", session)
		cmd := exec.Command("tmux", "new-session", "-d", "-s", session)
		if out, err := cmd.CombinedOutput(); err != nil {
			trace("new-session failed: %v: %s", err, strings.TrimSpace(string(out)))
			return
		}
	}

	if inTmux {
		trace("switching client to: %s", session)
		syscall.Exec(findTmux(), []string{"tmux", "switch-client", "-t", session}, os.Environ())
	} else {
		trace("attaching to: %s", session)
		syscall.Exec(findTmux(), []string{"tmux", "attach-session", "-t", session}, os.Environ())
	}
}

func sessionExists(name string) bool {
	return exec.Command("tmux", "has-session", "-t", name).Run() == nil
}

func findTmux() string {
	path, err := exec.LookPath("tmux")
	if err != nil {
		return "tmux"
	}
	return path
}

// --- Main ---

func main() {
	sessions := listTmuxSessions()
	trace("found %d sessions", len(sessions))

	p := tea.NewProgram(initialModel(sessions))
	result, err := p.Run()
	if err != nil {
		trace("bubbletea error: %v", err)
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}

	m := result.(model)

	if m.escaped {
		name := findNextTempSession(sessions)
		trace("escape pressed, creating temp session: %s", name)
		attachOrSwitch(name, true)
		return
	}

	if m.newSess && m.chosen == "" {
		m.chosen = findNextTempSession(sessions)
		trace("new session with empty name, using temp name: %s", m.chosen)
	}
	if m.chosen != "" {
		attachOrSwitch(m.chosen, m.newSess)
	}
}
