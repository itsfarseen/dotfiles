# colorscheme-adjuster

A terminal UI for checking the legibility of a ghostty colorscheme using **only
its palette colors**, and tweaking individual colors live.

It renders two fg/bg sample grids on the left:

- **Grid 1** — neutral colors (`background`, `foreground`, palette 0/7/8/15) as
  foreground, against every color as background.
- **Grid 2** — every color as foreground against every color as background.

On the right is an editable list of every color in the file with a live swatch
and hex value.

## Run

```sh
uv run main.py [path-to-colorscheme]
```

Defaults to `../jellybeans-default`. Requires a truecolor terminal (ghostty is).

## Keys

| Key            | Action                                              |
|----------------|-----------------------------------------------------|
| `Tab`          | cycle edit mode: RGB → HSV → HSL (global)            |
| `↑` / `↓`      | select previous / next color                        |
| `←` / `→`      | move between the selected color's 3 components       |
| `]` / `[`      | increment / decrement the component by 1 (clamped)   |
| `}` / `{`      | increment / decrement the component by 5 (clamped)   |
| `Ctrl+S`       | back up the file to `./.backup/<name>.<ts>.bak`, then overwrite it |
| `q` / `Esc`    | quit                                                |

## Notes

- Colors are stored internally as RGB; HSV/HSL are views, so edits round-trip
  through hex and may drift by ±1 over repeated HSV/HSL tweaks.
- On save, only the `#rrggbb` token on each color line is rewritten — all other
  text, spacing and ordering is preserved.
- `Ctrl+S` normally means terminal flow-control (XOFF); the program disables it
  with `stty -ixon` on startup and restores your settings on exit.
- If the full grid is wider than the terminal, extra columns are clipped and the
  footer notes how many are hidden — widen the terminal to see them.
