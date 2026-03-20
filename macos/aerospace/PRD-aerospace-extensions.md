# PRD: AeroSpace config extensions (interview synthesis)

**Owner:** shahzebqazi  
**Repo:** `my-dot-files` — `macos/aerospace/`  
**Live config (macOS):** `~/.config/aerospace/aerospace.toml` (copy from repo; never duplicate `~/.aerospace.toml`)  
**Agent / human workflow:** see repo root **[`PLAYBOOK.md`](../../PLAYBOOK.md)** (paths, XDG, deploy commands).  
**Status:** **Partially implemented** — hotkeys, service mode, workspace **O** reservation, and docs are **done**; **`[[on-window-detected]]`**, **`exec-on-workspace-change`**, **`after-startup-command`**, monitor-default tuning, and **⌥O smart-open** remain **open** (see §9).  
**AeroSpace:** Behavior is **version-specific**; validate CLI flags and hook env vars against the [guide](https://nikitabobko.github.io/AeroSpace/guide.html) and `aerospace --help` for the installed build.

---

## 9. Completed work (inventory)

The following are **already in** `macos/aerospace/.aerospace.toml` and mirrored in **`aerospace.readme.md`** + **`README.md`**:

| Deliverable | Notes |
|-------------|--------|
| **Workspace O reserved** | `alt-o` / `alt-shift-o` commented; readmes document **⌥ O** / **⌥⇧ O** as not bound for workspace switch/move. |
| **⌥-centric main bindings** | **⌥ F** fullscreen, **⌥ X** flatten, **⌥ M** minimize, **⌥ [ ]** smart resize; **⌥ arrows** alias **⌥ HJKL** for focus and **⌥⇧ arrows** for move. |
| **Workspace letter exceptions** | **F, H–L, M, N, O, R, X** (and matching **⌥⇧** move-node lines) commented where they clash with the above; documented in readmes. |
| **Service mode entry** | **`alt-semicolon`** (**⌥ ;**) → `mode service` (was **⌥⇧ ;** in early PRD). |
| **Service `join-with`** | **⌥ H/J/K/L** → `join-with` + `mode main` (same physical keys as **focus** in **main**; modes are mutually exclusive — no table conflict). |
| **System keyboard note** | Fn ↔ Control swap and Caps Lock → Escape documented under readmes “Keyboard remapping”. |
| **Docs sync** | Hotkey tables match TOML; deploy path repeated in TOML header and **PLAYBOOK.md**. |

**Explicitly not done yet (backlog vs this PRD):** §3.1 `on-window-detected`, §3.4 `exec-on-workspace-change`, §3.6 `after-startup-command`, §3.9 EX-1 **⌥O** `exec-and-forget` implementation, §3.2 MON-2/MON-3 investigation, §3.3 focus-follows-mouse / pointer policy reconciliation.

---

## 1. Purpose

Extend an existing daily-driver AeroSpace setup with:

- **`[[on-window-detected]]`** rules for app/workspace placement and floating behavior.
- **Monitor attach/detach** behavior aligned with “no forced workspace pinning,” **no default second monitor on workspace 10**, and **automatic consolidation** when a display disconnects.
- **Focus / pointer** policy: **focus-follows-mouse**, **no same-screen cursor warp to focused window**, **acceptable cross-monitor pointer move** on workspace switch (prefer instant / unobtrusive).
- **Lightweight persistence:** **`exec-on-workspace-change`** logging under `~/.local/` via **bash**.
- **`after-startup-command`:** focus workspace **`1`** on startup.
- **One `exec-and-forget` binding:** **⌥O** smart open from **clipboard** (workspace **O** switch/move bindings **commented** so **⌥O** does not conflict).
- **Documentation:** system key remaps (fn ↔ control, Caps Lock → Escape) in `aerospace.readme.md` and `README.md`.

Non-goals for this PRD: replacing **leader-key** app launches; **SketchyBar**; **perfect session rewind** from logs; **Ghostty** state machine requiring scripts (v1 stays **simple TOML** only).

---

## 2. Current baseline (repo)

| Item | Current state (`macos/aerospace/.aerospace.toml`) |
|------|---------------------------------------------------|
| `after-startup-command` | `[]` — **empty** (ASU-1 **not** implemented) |
| `on-mode-changed` | `[]` |
| `on-focused-monitor-changed` | `['move-mouse monitor-lazy-center']` |
| `persistent-workspaces` | `["1", "2", "3"]` |
| `[[on-window-detected]]` | **Absent** |
| `[workspace-to-monitor-force-assignment]` | **Absent** (by design — MON-1) |
| `exec-on-workspace-change` | **Absent** |
| Gaps | Global `10` px inner/outer |
| Modes | `main` + `service`; **⌥ ;** → service |
| Service | **⌥ H/J/K/L** → `join-with` + `mode main` |
| Main hotkeys | **⌥** focus/move/arrows; **⌥ F/X/M**, **⌥ [ ]** resize; workspace **O** and other letters as in §9 |
| `alt-o` / `alt-shift-o` | **Commented** (reserve **⌥O** for future smart-open) |

**Alignment check:** Interview asked for **no same-screen cursor jump** when focus changes from keys; **`on-focused-monitor-changed`** still uses **monitor-lazy-center**. Reconcile when tackling §3.3.

---

## 3. Requirements by feature

### 3.1 `[[on-window-detected]]`

| ID | Requirement | Priority |
|----|-------------|----------|
| OW-1 | **Ghostty** → workspace **`1`**, **tiled**. **v1:** simple rules only; **no** script. **Deferred:** “if already on 1 and I’m elsewhere, don’t yank,” etc., unless expressible in TOML for this version. | P0 |
| OW-2 | **Firefox** → workspace **`2`**, **tiled**. | P0 |
| OW-3 | **Cursor** → workspace **`C`**, **tiled**. | P0 |
| OW-4 | **Finder:** user-opened browser windows → **current workspace**, **tiled**. | P0 |
| OW-5 | **Finder / file sheets:** open/save or **file-picker**-style UI opened **from another app** → **floating**, **centered**. (Heuristics: title regex / app-id / window role — **fill after `aerospace list-apps` / observation**.) | P1 |
| OW-6 | **System Settings**, **password prompts**, general **dialogs** → **floating**, **centered**; **ideal:** same screen as **calling** app; **fallback:** **focused monitor** / AeroSpace-supported placement. | P1 |
| OW-7 | **Mitigate clipped/off-screen** Finder, Settings, and prompts (current pain). Success = windows **visible without** manual fullscreen/move. | P1 |
| OW-8 | **`check-further-callbacks`:** set per rule where **stacking** multiple matchers matters; document order. | P2 |

**Acceptance:** Open each app/window class; verify workspace, float/tile, and visibility on **single** and **dual** monitor (when available).

---

### 3.2 Monitors & workspaces (no pinning table)

| ID | Requirement | Priority |
|----|-------------|----------|
| MON-1 | **No** `[workspace-to-monitor-force-assignment]` **pinning** (user explicitly declined). | P0 **Done** (absent from config) |
| MON-2 | **Second monitor attach:** avoid **always** landing on **workspace 10**; prefer **next workspace in declared order** that is **not yet created** / unused per user expectation. **Workspace order** = sequence of workspaces **not commented out** in TOML (letters/numbers as defined). | P0 **Open** |
| MON-3 | **Monitor disconnect:** **automatic** consolidation — windows must not be stranded; user should not hunt for them. (Use AeroSpace defaults + verify; add commands only if gaps found.) | P0 **Verify** |
| MON-4 | **Mirror vs extend:** **No** special AeroSpace mode; same as “normal” AeroSpace. | P0 **Done** (no extra config) |
| MON-5 | **Hardware:** up to **two external** panels + **MacBook**; **per-monitor gaps** **deferred** until measured at each resolution (see §3.6). | P2 |

**Acceptance:** Plug/unplug external display(s); confirm initial workspace choice and **no lost windows**.

---

### 3.3 Focus & pointer (`on-focus-changed` / related)

| ID | Requirement | Priority |
|----|-------------|----------|
| FP-1 | **Focus follows mouse:** hover unfocused window → it gains focus (**same screen** and **cross-monitor**). | P0 **Open** |
| FP-2 | **No** pointer **warp to center** of newly focused window when focus changes **on the same physical screen** (e.g. via keys). | P0 **Open** / reconcile with `on-focused-monitor-changed` |
| FP-3 | **Workspace switch** resulting in focus on **another monitor:** pointer may **move** to that monitor; should feel **instant / unobtrusive** (version-limited; verify). | P1 |
| FP-4 | **Focus stealing:** generally **acceptable**, especially for **same-workspace** floats/popups. | P2 |

**Acceptance:** Exercise focus via **mouse** and **bindings**; confirm FP-1–FP-3 on **one** and **two** displays.

---

### 3.4 `exec-on-workspace-change`

| ID | Requirement | Priority |
|----|-------------|----------|
| EWC-1 | Append **one line per workspace change** to a file under **`~/.local/`** (e.g. `~/.local/state/aerospace/workspace.log` — exact path in implementation). | P0 **Open** |
| EWC-2 | Log fields: **timestamp**, **previous workspace**, **focused workspace**; add **monitor** and **binding mode** if **documented env vars** exist for this hook in this version. | P0 |
| EWC-3 | Shell: **bash** (`/bin/bash -c` or small bash script). **Mac-only**; no multi-shell requirement. | P0 |
| EWC-4 | **Performance:** negligible impact; no network; avoid heavy subprocesses. | P0 |

**Acceptance:** Switch workspaces 10×; file grows monotonically; contents readable; no noticeable lag.

---

### 3.5 `on-mode-changed`

| ID | Requirement | Priority |
|----|-------------|----------|
| OMC-1 | **None** for now (no SketchyBar, no notifications). Leave **`on-mode-changed = []`** or omit additions. | P0 **Done** |

---

### 3.6 `after-startup-command`

| ID | Requirement | Priority |
|----|-------------|----------|
| ASU-1 | On AeroSpace startup, **focus workspace `1`** (idempotent if already focused). Use **documented** CLI / command sequence for installed version. | P0 **Open** |

**Acceptance:** Restart AeroSpace; focused workspace is **`1`**.

---

### 3.7 Per-monitor gaps

| ID | Requirement | Priority |
|----|-------------|----------|
| GAP-1 | **Deferred:** keep **global** gaps until user tunes **per monitor** for **built-in + two external resolutions**. | P2 |

---

### 3.8 Extra binding modes

| ID | Requirement | Priority |
|----|-------------|----------|
| MOD-1 | **None** beyond **`main`** + **`service`**. | P0 **Done** |

---

### 3.9 `exec-and-forget` (AeroSpace only)

| ID | Requirement | Priority |
|----|-------------|----------|
| EX-1 | **⌥O:** read **clipboard** (`pbpaste`); if **`http://` or `https://`** → open in **Firefox**; if path exists and is **directory** → **Finder**; if **file** → **Sublime Text** (`open` / `subl` per machine). | P0 **Open** (key chord free; binding not added) |
| EX-2 | **App launches** (T/B/F/… ) remain in **leader-key** config **outside** AeroSpace. | P0 **Done** (by policy) |

**Resolved:** **`alt-o` / `alt-shift-o`** commented; readmes list workspace **O** keys as not bound. **⌥O** remains available for EX-1.

---

### 3.10 Key mapping (`[key-mapping.key-notation-to-key-code]`)

| ID | Requirement | Priority |
|----|-------------|----------|
| KM-1 | **No** custom TOML key-code table. **System remaps** documented in **`aerospace.readme.md`** / **`README.md`** (fn ↔ control; Caps Lock → Escape). | P0 **Done** |

---

### 3.11 `[exec]` / `[exec.env-vars]`

| ID | Requirement | Priority |
|----|-------------|----------|
| ENV-1 | **Defaults** first; add **`PATH`** or other vars **only** if hooks fail (“command not found”). | P0 |
| ENV-2 | Prefer **absolute paths** to **`aerospace`**, **`bash`**, **`open`** in fragile hooks before expanding env. | P1 |

---

## 4. Implementation order (dependencies)

1. ~~**Resolve `alt-o` conflict**~~ **Done**
2. ~~**Readmes + main/service hotkey pass**~~ **Done** (§9)
3. **`[exec]` / env** — only if needed after testing hooks.
4. **`after-startup-command`** — focus workspace `1`.
5. **`exec-on-workspace-change`** — log script + `~/.local/state/...` + bash.
6. **`[[on-window-detected]]`** — Ghostty, Firefox, Cursor; Finder; dialogs (bundle IDs / regex from `aerospace list-apps` + live testing).
7. **Monitor attach default** — research version-specific knobs for “not always 10”; **no** force-assignment table.
8. **Focus/pointer** — focus-follows-mouse if desired; reconcile **`on-focused-monitor-changed`** with interview rules.
9. **`exec-and-forget` EX-1** — **⌥O** clipboard smart-open.
10. **PLAYBOOK / PRD** — keep **[`PLAYBOOK.md`](../../PLAYBOOK.md)** aligned when deploy paths or sync rules change.

---

## 5. Test plan (post-`reload-config`)

| Step | Action | Expected |
|------|--------|----------|
| T0 | **⌥ ;** then **⌥ H/J/K/L** in service (two tiled neighbors) | `join-with` changes tree; returns to main |
| T1 | Restart AeroSpace | Workspace **`1`** focused — **after ASU-1** |
| T2 | Switch workspaces rapidly | Log file grows — **after EWC-*** |
| T3 | Open Ghostty / Firefox / Cursor | Land on **`1` / `2` / `C`** — **after OW-*** |
| T4 | Open Finder normally | Tiled, **current** workspace — **after OW-4** |
| T5 | Trigger **open file** from Firefox | Sheet **float**, **centered** — **after OW-5** |
| T6 | Copy URL / path / folder → **⌥O** — **after EX-1** | Firefox / Sublime / Finder |
| T7 | **Dual monitor:** attach | Second screen not stuck on unwanted default — **after MON-2** |
| T8 | **Disconnect** external | All windows reachable |
| T9 | Hover to focus | **after FP-1** |
| T10 | Key focus same screen | No unwanted warp — **after FP-2** / policy |

---

## 6. Risks & open questions

| Risk | Mitigation |
|------|------------|
| ~~**⌥O vs `workspace O`**~~ | **Resolved** (commented bindings + docs). |
| **“Next unused workspace” on monitor connect** | Version-specific research. |
| **Ghostty “smart” placement** | v1 simple TOML; script later if needed. |
| **Dialog/sheet detection** | Regex / app-id brittle; iterate with **real** apps. |
| **Parent-screen for dialogs** | OS limits; **center on focused monitor** as fallback. |
| **`on-focused-monitor-changed`** vs **no same-screen jump** | Read docs; test; adjust. |

---

## 7. Documentation & sync

Any binding or documented scalar change must update:

- `macos/aerospace/.aerospace.toml`  
- `macos/aerospace/aerospace.readme.md`  
- `macos/aerospace/README.md`  

Per header contract in the TOML. **Operational steps:** **[`PLAYBOOK.md`](../../PLAYBOOK.md)** § AeroSpace.

---

## 8. Sign-off

| Area | Disposition |
|------|-------------|
| Hotkeys / service / workspace-O / readmes | **Done** (§9) |
| `on-window-detected` | **Pending** |
| Workspace↔monitor pinning | **Rejected** (not used) |
| Second-monitor default workspace | **Pending** (MON-2) |
| Focus / pointer | **Pending** |
| `exec-on-workspace-change` | **Pending** |
| `on-mode-changed` | **Done** (empty) |
| `after-startup-command` | **Pending** |
| Per-monitor gaps | **Deferred** |
| Extra modes | **Rejected** (main + service only) |
| `exec-and-forget` EX-1 | **Pending** (⌥O free) |
| Key-mapping table | **N/A** (readme remaps only) |
| `exec` env | **Defaults** until hooks fail |

**Next step:** Backlog items in §4 steps 3–9 + manual tests from §5 when each lands.
