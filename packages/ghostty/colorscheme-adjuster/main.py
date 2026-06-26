#!/usr/bin/env python3
"""Colorscheme adjuster TUI.

Reads a ghostty colorscheme file, renders fg/bg legibility grids using only the
palette colors, and lets you interactively tweak individual colors in RGB / HSV
/ HSL, then save back to the file.

Run:  uv run main.py [path-to-colorscheme]   (default: ../jellybeans-default)
"""

from __future__ import annotations

import colorsys
import datetime as _dt
import os
import re
import shutil
import subprocess
import sys
from dataclasses import dataclass

from blessed import Terminal

DEFAULT_FILE = os.path.join(os.path.dirname(__file__), "..", "jellybeans-default")

# Matches the first #rrggbb / #rgb token on a line.
HEX_RE = re.compile(r"#([0-9a-fA-F]{6}|[0-9a-fA-F]{3})")

# Named single-color keys we care about, in display order.
NAMED_KEYS = [
    "background",
    "foreground",
    "selection-background",
    "selection-foreground",
    "cursor-color",
    "cursor-text",
]

# Canonical ANSI names for the 16 palette colors.
PALETTE_NAMES = [
    "black", "red", "green", "yellow", "blue", "magenta", "cyan", "white",
    "br black", "br red", "br green", "br yellow", "br blue", "br magenta",
    "br cyan", "br white",
]

# Fixed neutral set (by entry key) used as the fg rows of grid 1.
NEUTRAL_KEYS = ["background", "foreground", "palette 0", "palette 7", "palette 8", "palette 15"]

MODES = ["RGB", "HSV", "HSL"]

# Per-mode component labels and their max values (min is always 0).
MODE_SPEC = {
    "RGB": [("R", 255), ("G", 255), ("B", 255)],
    "HSV": [("H", 360), ("S", 100), ("V", 100)],
    "HSL": [("H", 360), ("S", 100), ("L", 100)],
}


# --------------------------------------------------------------------------- #
# Color model
# --------------------------------------------------------------------------- #
def hex_to_rgb(s: str) -> tuple[int, int, int]:
    s = s.lstrip("#")
    if len(s) == 3:
        s = "".join(c * 2 for c in s)
    return (int(s[0:2], 16), int(s[2:4], 16), int(s[4:6], 16))


def rgb_to_hex(rgb: tuple[int, int, int]) -> str:
    return "#%02x%02x%02x" % rgb


def clamp(v: float, lo: float, hi: float) -> float:
    return max(lo, min(hi, v))


def rgb_to_components(rgb: tuple[int, int, int], mode: str) -> list[float]:
    r, g, b = (c / 255.0 for c in rgb)
    if mode == "RGB":
        return [float(rgb[0]), float(rgb[1]), float(rgb[2])]
    if mode == "HSV":
        h, s, v = colorsys.rgb_to_hsv(r, g, b)
        return [h * 360, s * 100, v * 100]
    if mode == "HSL":
        h, l, s = colorsys.rgb_to_hls(r, g, b)
        return [h * 360, s * 100, l * 100]
    raise ValueError(mode)


def components_to_rgb(comp: list[float], mode: str) -> tuple[int, int, int]:
    if mode == "RGB":
        return tuple(int(round(clamp(c, 0, 255))) for c in comp)  # type: ignore[return-value]
    if mode == "HSV":
        h, s, v = comp[0] / 360, comp[1] / 100, comp[2] / 100
        r, g, b = colorsys.hsv_to_rgb(h, s, v)
    elif mode == "HSL":
        h, s, l = comp[0] / 360, comp[1] / 100, comp[2] / 100
        r, g, b = colorsys.hls_to_rgb(h, l, s)
    else:
        raise ValueError(mode)
    return (
        int(round(clamp(r * 255, 0, 255))),
        int(round(clamp(g * 255, 0, 255))),
        int(round(clamp(b * 255, 0, 255))),
    )


# --------------------------------------------------------------------------- #
# File parsing
# --------------------------------------------------------------------------- #
@dataclass
class ColorEntry:
    label: str           # display label, e.g. "background" or "palette 0"
    key: str             # same as label (stable id)
    rgb: tuple[int, int, int]
    line_index: int      # index into the raw lines list


def parse_file(path: str) -> tuple[list[str], list[ColorEntry]]:
    with open(path, "r") as f:
        lines = f.read().splitlines(keepends=True)

    entries: list[ColorEntry] = []
    pal: dict[int, ColorEntry] = {}
    named: dict[str, ColorEntry] = {}

    for i, line in enumerate(lines):
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            continue
        m = HEX_RE.search(line)
        if not m:
            continue
        rgb = hex_to_rgb(m.group(0))

        # palette = N=#hex
        pm = re.match(r"\s*palette\s*=\s*(\d+)\s*=", line)
        if pm:
            idx = int(pm.group(1))
            key = f"palette {idx}"
            name = PALETTE_NAMES[idx] if idx < len(PALETTE_NAMES) else key
            label = f"[{idx}] {name}"
            pal[idx] = ColorEntry(label, key, rgb, i)
            continue

        km = re.match(r"\s*([a-z-]+)\s*=", line)
        if km and km.group(1) in NAMED_KEYS:
            key = km.group(1)
            named[key] = ColorEntry(key, key, rgb, i)

    # Ordered: named keys first (in NAMED_KEYS order), then palette 0..15.
    for k in NAMED_KEYS:
        if k in named:
            entries.append(named[k])
    for idx in sorted(pal):
        entries.append(pal[idx])

    return lines, entries


def write_file(path: str, lines: list[str], entries: list[ColorEntry]) -> None:
    out = list(lines)
    for e in entries:
        line = out[e.line_index]
        new_hex = rgb_to_hex(e.rgb)
        out[e.line_index] = HEX_RE.sub(new_hex, line, count=1)
    with open(path, "w") as f:
        f.write("".join(out))


def backup_and_save(path: str, lines: list[str], entries: list[ColorEntry]) -> str:
    backup_dir = os.path.join(os.getcwd(), ".backup")
    os.makedirs(backup_dir, exist_ok=True)
    ts = _dt.datetime.now().strftime("%Y%m%d-%H%M%S")
    base = os.path.basename(path)
    backup_path = os.path.join(backup_dir, f"{base}.{ts}.bak")
    shutil.copy2(path, backup_path)  # copy the pre-edit file
    write_file(path, lines, entries)
    return backup_path


# --------------------------------------------------------------------------- #
# Rendering
# --------------------------------------------------------------------------- #
def luminance(rgb: tuple[int, int, int]) -> float:
    r, g, b = (c / 255.0 for c in rgb)
    return 0.2126 * r + 0.7152 * g + 0.0722 * b


class App:
    CELL = "Ag"          # 2-char sample per cell
    GAP = " "            # space between cells

    def __init__(self, term: Terminal, path: str, lines: list[str], entries: list[ColorEntry]):
        self.term = term
        self.path = path
        self.lines = lines
        self.entries = entries
        self.by_key = {e.key: e for e in entries}

        self.mode = "RGB"
        self.sel = 0          # selected entry index
        self.comp = 0         # selected component 0..2
        self.status = ""

        self.neutrals = [self.by_key[k] for k in NEUTRAL_KEYS if k in self.by_key]

    # -- grid drawing ------------------------------------------------------- #
    def _grid_lines(self, fg_rows: list[ColorEntry], max_cols: int) -> tuple[list[str], int]:
        """Return (rendered_lines, hidden_col_count)."""
        t = self.term
        cols = self.entries
        cell_w = len(self.CELL) + len(self.GAP)
        # reserve a small label column on the left
        label_w = 15
        avail = max_cols - label_w
        visible = max(0, avail // cell_w)
        hidden = max(0, len(cols) - visible)
        shown = cols[:visible] if visible else []

        out: list[str] = []
        for fg in fg_rows:
            label = fg.label[:label_w - 1].ljust(label_w)
            row = label
            for bg in shown:
                cell = t.color_rgb(*fg.rgb) + t.on_color_rgb(*bg.rgb) + self.CELL + t.normal
                row += cell + self.GAP
            out.append(row)
        return out, hidden

    # -- right panel -------------------------------------------------------- #
    def _panel_lines(self, height: int) -> list[str]:
        t = self.term
        out: list[str] = []
        out.append(t.bold("Colors") + f"   mode: {t.reverse(self.mode)}")
        out.append("")

        for i, e in enumerate(self.entries):
            marker = t.bold(">") if i == self.sel else " "
            swatch = t.on_color_rgb(*e.rgb)("    ") + t.normal
            name = e.label.ljust(20)
            hexv = rgb_to_hex(e.rgb)
            line = f"{marker} {name} {swatch} {hexv}"
            if i == self.sel:
                line = t.underline(line)
            out.append(line)

        out.append("")
        out.append(t.bold(f"-- edit ({self.mode}) --"))
        e = self.entries[self.sel]
        comps = rgb_to_components(e.rgb, self.mode)
        spec = MODE_SPEC[self.mode]
        parts = []
        for j, (lab, _mx) in enumerate(spec):
            val = f"{lab}:{int(round(comps[j]))}"
            if j == self.comp:
                val = t.reverse(val)
            parts.append(val)
        out.append("  " + "   ".join(parts))
        out.append(f"  {e.label}  {rgb_to_hex(e.rgb)}")
        return out

    # -- editing ------------------------------------------------------------ #
    def adjust(self, delta: int) -> None:
        e = self.entries[self.sel]
        comps = rgb_to_components(e.rgb, self.mode)
        _lab, mx = MODE_SPEC[self.mode][self.comp]
        comps[self.comp] = clamp(comps[self.comp] + delta, 0, mx)
        e.rgb = components_to_rgb(comps, self.mode)

    # -- full frame --------------------------------------------------------- #
    def render(self) -> None:
        t = self.term
        left_w = max(20, int(t.width * 0.62))
        panel_x = left_w + 2

        buf = [t.home + t.clear]

        y = 0

        def put(x: int, yy: int, s: str) -> None:
            buf.append(t.move_xy(x, yy) + s)

        put(0, y, t.bold("Grid 1: neutral fg x all bg"))
        y += 1
        g1, hidden = self._grid_lines(self.neutrals, left_w)
        for line in g1:
            put(0, y, line)
            y += 1
        y += 1
        put(0, y, t.bold("Grid 2: all fg x all bg"))
        y += 1
        g2, hidden = self._grid_lines(self.entries, left_w)
        for line in g2:
            if y >= t.height - 2:
                break
            put(0, y, line)
            y += 1

        # right panel
        for j, line in enumerate(self._panel_lines(t.height)):
            if j >= t.height - 1:
                break
            put(panel_x, j, line)

        # footer
        hint = ("Tab:mode  Up/Down:color  Left/Right:comp  "
                "[ ]:+-1  { }:+-5  Ctrl+S:save  q:quit")
        if hidden:
            hint = f"({hidden} cols hidden - widen terminal)  " + hint
        if self.status:
            hint = self.status + "   " + hint
        put(0, t.height - 1, t.reverse(hint[: t.width - 1].ljust(t.width - 1)))

        sys.stdout.write("".join(buf))
        sys.stdout.flush()

    # -- main loop ---------------------------------------------------------- #
    def run(self) -> None:
        t = self.term
        with t.fullscreen(), t.cbreak(), t.hidden_cursor():
            while True:
                self.render()
                key = t.inkey()
                self.status = ""
                if key.name == "KEY_TAB" or key == "\t":
                    self.mode = MODES[(MODES.index(self.mode) + 1) % len(MODES)]
                    self.comp = 0
                elif key.name == "KEY_UP":
                    self.sel = (self.sel - 1) % len(self.entries)
                    self.comp = 0
                elif key.name == "KEY_DOWN":
                    self.sel = (self.sel + 1) % len(self.entries)
                    self.comp = 0
                elif key.name == "KEY_LEFT":
                    self.comp = (self.comp - 1) % 3
                elif key.name == "KEY_RIGHT":
                    self.comp = (self.comp + 1) % 3
                elif key == "]":
                    self.adjust(1)
                elif key == "[":
                    self.adjust(-1)
                elif key == "}":
                    self.adjust(5)
                elif key == "{":
                    self.adjust(-5)
                elif key == "\x13":  # Ctrl+S
                    try:
                        bp = backup_and_save(self.path, self.lines, self.entries)
                        self.status = t.bold_green(f"Saved (backup: {os.path.basename(bp)})")
                    except Exception as ex:  # noqa: BLE001
                        self.status = t.bold_red(f"Save failed: {ex}")
                elif key in ("q", "Q") or key.name == "KEY_ESCAPE":
                    break


def main() -> int:
    path = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_FILE
    if not os.path.isfile(path):
        print(f"colorscheme file not found: {path}", file=sys.stderr)
        return 1

    lines, entries = parse_file(path)
    if not entries:
        print(f"no colors parsed from {path}", file=sys.stderr)
        return 1

    term = Terminal()

    # Disable XOFF/XON flow control so Ctrl+S reaches us; restore on exit.
    restore_stty = None
    try:
        saved = subprocess.run(["stty", "-g"], capture_output=True, text=True)
        if saved.returncode == 0:
            restore_stty = saved.stdout.strip()
            subprocess.run(["stty", "-ixon"])
    except Exception:  # noqa: BLE001
        restore_stty = None

    try:
        App(term, path, lines, entries).run()
    finally:
        if restore_stty:
            subprocess.run(["stty", restore_stty])
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
