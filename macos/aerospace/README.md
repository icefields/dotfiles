# Personal AeroSpace config — hotkeys

Prefer **`macos/aerospace/aerospace.readme.md`** as the main hotkey reference.

Bindings match **`macos/aerospace/.aerospace.toml`** and the live config **`~/.config/aerospace/aerospace.toml`** (copy the repo file there after you change it).  
Notation: **⌥** Option (Alt), **⌃** Control, **⇧** Shift.

**System remaps (not in TOML):** Fn and Control are swapped; Caps Lock → Escape. Hotkeys assume keys **after** those remaps.

## General settings (non-keys)

| Setting | Value |
|--------|--------|
| Start at login | yes |
| Persistent workspaces | `1`, `2`, `3` |
| Gaps (inner / outer) | 10 px |
| Mouse on monitor focus change | move to monitor center (lazy) |
| Unhide hidden apps when switching workspace | yes |
| Normalization | flatten single-child containers; opposite orientation for nested splits |

---

## `main` mode

### Layout (root container)

| Shortcut | Action |
|----------|--------|
| ⌥ / | Cycle root layout: tiles (horizontal ↔ vertical) |
| ⌥ , | Cycle root layout: accordion (horizontal ↔ vertical) |

### Focus (window / tree)

| Shortcut | Action |
|----------|--------|
| ⌥ H / ← | Focus left |
| ⌥ J / ↓ | Focus down |
| ⌥ K / ↑ | Focus up |
| ⌥ L / → | Focus right |

### Move window in tree

| Shortcut | Action |
|----------|--------|
| ⌥⇧ H / J / K / L | Move focused window left / down / up / right |
| ⌥⇧ ← / ↓ / ↑ / → | Same as above (arrow aliases) |

### Resize, fullscreen & flatten

| Shortcut | Action |
|----------|--------|
| ⌥ - | Smart resize −50 |
| ⌥ = | Smart resize +50 |
| ⌥ [ | Smart resize +50 (along current split axis) |
| ⌥ ] | Smart resize −50 |
| ⌥ F | Fullscreen focused window |
| ⌥ X | Flatten workspace tree |

### macOS window

| Shortcut | Action |
|----------|--------|
| ⌥ M | Native minimize (Dock) |

### Workspaces — switch

| Shortcut | Action |
|----------|--------|
| ⌥ 1–9 | Go to workspace `1`–`9` |
| ⌥ A–Z | Go to workspace with that letter (see exceptions below) |

**Not bound (commented):** **F** (⌥ F = fullscreen), **H–L** (focus), **M** (⌥ M = minimize), **N**, **O** (reserved), **R**, **X** (⌥ X = flatten). Matching **⌥⇧** move-node bindings commented too.

### Workspaces — move focused window

| Shortcut | Action |
|----------|--------|
| ⌥⇧ 1–9 | Move window to workspace `1`–`9` |
| ⌥⇧ A–Z | Move window to workspace with that letter (same exceptions) |

**Not bound:** ⌥⇧ **H–L** (move in tree); ⌥⇧ **F, M, N, O, R, X**.

### Workspace & monitor

| Shortcut | Action |
|----------|--------|
| ⌥ Tab | Previous workspace (back-and-forth) |
| ⌥⇧ Tab | Move current workspace to next monitor (wrap) |

### Modes

| Shortcut | Action |
|----------|--------|
| ⌥ ; | Enter **service** mode |

---

## `service` mode

After **⌥ ;**, these apply until you return to `main` (usually with **Esc**).

**`join-with`:** merges focused window with nearest tiled sibling in that direction ([docs](https://nikitabobko.github.io/AeroSpace/commands#join-with)). In **service**, **⌥ H/J/K/L** = join; in **main**, same chords = focus — different modes, no conflict.

| Shortcut | Action |
|----------|--------|
| Esc | Reload config + return to **main** |
| R | Flatten workspace tree + **main** |
| F | Toggle floating ↔ tiling layout + **main** |
| Backspace | Close all windows except focused + **main** |
| ⌥ H / J / K / L | Join with adjacent container (left / down / up / right) + **main** |

---

## Links

- [AeroSpace guide](https://nikitabobko.github.io/AeroSpace/guide)
- [AeroSpace commands](https://nikitabobko.github.io/AeroSpace/commands)
- Author: [github.com/shahzebqazi](https://github.com/shahzebqazi)
