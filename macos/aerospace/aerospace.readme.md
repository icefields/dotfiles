# Personal AeroSpace config — hotkeys

<!--
  AI_AGENT_SYNC_PROMPT (paste or honor when editing AeroSpace config in this repo):

  You MUST keep these artifacts consistent in one change set:
  1) macos/aerospace/.aerospace.toml — source of truth for AeroSpace (keys, modes, scalars).
  2) macos/aerospace/aerospace.readme.md — hotkey tables and “General settings” must match the TOML.
  3) macos/aerospace/README.md — still mirrors this file; update its tables/settings the same way.

  On macOS after changing the repo TOML: copy to the live path and reload, e.g.
    cp macos/aerospace/.aerospace.toml ~/.config/aerospace/aerospace.toml && aerospace reload-config

  Rules: Use ONLY ~/.config/aerospace/aerospace.toml on disk for AeroSpace (filename aerospace.toml).
  Never add ~/.aerospace.toml while the XDG file exists (AeroSpace reports ambiguity).
  If you change a binding or documented setting, update every file above before finishing.
-->

**Docs live in this repo:** `macos/aerospace/aerospace.readme.md`. Canonical TOML: `macos/aerospace/.aerospace.toml`. On macOS, use XDG layout: copy it to **`~/.config/aerospace/aerospace.toml`** (real file, not a symlink) and do **not** keep `~/.aerospace.toml` (AeroSpace errors if both exist).

## For AI agents (keep in sync)

When you edit anything in this AeroSpace setup, treat it as **one bundle**:

| Artifact | Role |
|----------|------|
| `macos/aerospace/.aerospace.toml` | **Source of truth** for all AeroSpace options and bindings. |
| This file (`aerospace.readme.md`) | Human-readable mirror: tables and general settings **must** match the TOML. |
| `macos/aerospace/README.md` | Same content class as this file—**update it in parallel** if it still mirrors these tables. |
| `~/.config/aerospace/aerospace.toml` on Mac | **Live** config (real file). After repo TOML changes, **copy** from the repo file and run **`aerospace reload-config`**. |

**Do not** create or keep `~/.aerospace.toml` alongside `~/.config/aerospace/aerospace.toml`.

Notation: **⌥** Option (Alt), **⌃** Control, **⇧** Shift.

### Keyboard remapping (system — not AeroSpace)

Hotkeys below assume **macOS / Karabiner / firmware** remaps are already applied:

- **Fn** and **Control** are **swapped** (what you press as fn behaves as ⌃ and vice versa — match this to your actual tool’s labels).
- **Caps Lock** is bound to **Escape**.

AeroSpace bindings use **keys as the OS delivers them** after these remaps.

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

**Not bound (commented in config):** **F** (⌥ F = fullscreen), **H–L** (same as **focus**), **M** (⌥ M = minimize), **N**, **O** (reserved, e.g. smart-open), **R**, **X** (⌥ X = flatten). **⌥⇧** + same letters for **move-node-to-workspace** are commented where they would clash.

### Workspaces — move focused window

| Shortcut | Action |
|----------|--------|
| ⌥⇧ 1–9 | Move window to workspace `1`–`9` |
| ⌥⇧ A–Z | Move window to workspace with that letter (same exceptions as switch) |

**Not bound:** ⌥⇧ **H–L** (same as **move in tree**); ⌥⇧ **F, M, N, O, R, X** (commented with switch bindings above).

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

**`join-with`:** merges the **focused** window with the **nearest tiled sibling** in that direction under one parent (see [AeroSpace `join-with`](https://nikitabobko.github.io/AeroSpace/commands#join-with)). No neighbor that way ⇒ **no visible change**. In **service**, **⌥ H/J/K/L** mean **join**; in **main**, the same chords mean **focus** — only one mode is active, so they do not clash.

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
