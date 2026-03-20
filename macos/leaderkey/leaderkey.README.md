# Personal Leader Key config — chords and prefs

<!--
  AI_AGENT_SYNC_PROMPT (paste or honor when editing Leader Key in this repo):

  You MUST keep these artifacts consistent in one change set:
  1) macos/leaderkey/config.json — source of truth for actions (keys, types, labels, values).
  2) This file (leaderkey.README.md) — chord tables and notes MUST match config.json.
  3) macos/leaderkey/README.md — short index; update if file list or primary doc path changes.
  4) PLAYBOOK.md (repo root) — update if agent workflow, paths, or deploy rules change materially.

  On macOS after changing the repo JSON:
    cp macos/leaderkey/config.json ~/Library/Application\ Support/Leader\ Key/config.json
    open 'leaderkey://config-reload'

  Optional: export prefs for git with:
    plutil -convert xml1 ~/Library/Preferences/com.brnbw.Leader-Key.plist -o macos/leaderkey/com.brnbw.Leader-Key.plist
-->

**Canonical JSON:** `macos/leaderkey/config.json`. **Human tables:** this file. **Live config path:** `~/Library/Application Support/Leader Key/config.json`.

## Leader shortcut (global)

| Setting | Value (this machine / repo plist) |
|---------|-------------------------------------|
| Open Leader Key | **⌥ .** (Option + period) — stored as `KeyboardShortcuts_navigate` → `{"carbonKeyCode":47,"carbonModifiers":2048}` |
| Theme | **mini** |
| Cheatsheet | **never** (delay **0** ms) |

**Meaning:** press **⌥ .** first; then press the keys below. There is no separate physical “leader” key — it is this global shortcut.

## Root chords (after leader)

| Key | Label | Type | What it does |
|-----|--------|------|----------------|
| **t** | Ghostty (~/my-dot-files) | command | `open -na Ghostty.app --args --working-directory="$HOME/my-dot-files"` |
| **b** | Firefox | application | `/Applications/Firefox.app` |
| **f** | Finder | application | `/System/Library/CoreServices/Finder.app` |
| **c** | Cursor (~/my-dot-files) | command | `/usr/local/bin/cursor -n "$HOME/my-dot-files"` |
| **n** | Ableton Live | application | `/Applications/Ableton Live 12 Suite.app` |
| **w** | Next window (⌘`) | command | AppleScript → **⌘`** on the **frontmost** app |
| **8** | Emoji & symbols (⌃⌘Space) | command | AppleScript → **⌃⌘Space** (Character Viewer) |
| **d** | Downloads | folder | `~/Downloads` in Finder |
| **g** | Dotfiles repo | folder | `~/my-dot-files` in Finder |
| **r** | Reload Leader Key | url | `leaderkey://config-reload` |

## Group **a** — Apps (leader **a**, then)

| Key | Label | Application |
|-----|--------|-------------|
| **s** | Safari | `/System/Applications/Safari.app` |
| **m** | Messages | `/System/Applications/Messages.app` |
| **e** | Mail | `/System/Applications/Mail.app` |

## Notes

### Accessibility (**w**, **8**)

Those actions use **System Events** to synthesize keys. Enable **Leader Key** under **System Settings → Privacy & Security → Accessibility** (and approve Automation if prompted).

### Ghostty cwd (**t**)

Uses Ghostty’s **`working-directory`** via `open --args`. If a Ghostty process is already running, new windows may follow **`window-inherit-working-directory`**; adjust Ghostty config if needed.

### Cursor CLI (**c**)

Leader Key runs commands with your login shell (`SHELL -c`). This config hard-codes **`/usr/local/bin/cursor`**; if `which cursor` differs on another Mac, edit **`config.json`**.

### JSON `type` values

| `type` | `value` |
|--------|---------|
| `application` | Full path to `.app` |
| `url` | URL / URL scheme |
| `command` | Shell one-liner |
| `folder` | Directory (`~` expanded) |
| `group` | Nested `actions` |

### Snappier UI / reproducing prefs via `defaults`

```bash
defaults write com.brnbw.Leader-Key KeyboardShortcuts_navigate -string '{"carbonKeyCode":47,"carbonModifiers":2048}'
defaults write com.brnbw.Leader-Key theme -string mini
defaults write com.brnbw.Leader-Key autoOpenCheatsheet -string never
defaults write com.brnbw.Leader-Key cheatsheetDelayMS -int 0
```

Quit and reopen Leader Key after changing prefs. `carbonKeyCode` **47** is **.** on US QWERTY.

### Repo files

| File | Role |
|------|------|
| `config.json` | Backed-up / editable action tree |
| `com.brnbw.Leader-Key.plist` | XML export of **com.brnbw.Leader-Key** preferences (theme, shortcut, cheatsheet) |
| `leaderkey.README.md` | This reference (keep in sync with `config.json`) |
| `README.md` | Short index into this folder |
| [`PLAYBOOK.md`](../../PLAYBOOK.md) (repo root) | Cursor / AI agent workflow, Mac paths, deploy vs backup |

### Useful URL schemes

- `leaderkey://config-reload` — reload `config.json` from disk  
- `leaderkey://config-reveal` — show config in Finder  
- `leaderkey://settings` — open Settings  

Upstream app: [Leader Key](https://github.com/mikker/LeaderKey) (bundle id **com.brnbw.Leader-Key**).
