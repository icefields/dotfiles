# PLAYBOOK — AI agents (`my-dot-files`)

Use this when a **Cursor** (or similar) agent edits, deploys, or documents dotfiles in this repo. It ties together **paths**, **XDG Base Directory** layout, and **macOS-only** tools.

**Related:** workspace preferences may also live in **`~/AGENTS.md`** (outside this repo) — check if the user keeps cross-repo agent notes there.

---

## 1. Repo map (where truth lives)

| Area | Canonical paths in repo | Human / spec doc |
|------|---------------------------|------------------|
| **This playbook** | [`PLAYBOOK.md`](PLAYBOOK.md) | Start here for deploy + XDG |
| **AeroSpace TOML** | [`macos/aerospace/.aerospace.toml`](macos/aerospace/.aerospace.toml) | Source of truth for WM config |
| **AeroSpace hotkeys** | [`macos/aerospace/aerospace.readme.md`](macos/aerospace/aerospace.readme.md) (detailed), [`macos/aerospace/README.md`](macos/aerospace/README.md) (short) | Must match TOML |
| **AeroSpace PRD / backlog** | [`macos/aerospace/PRD-aerospace-extensions.md`](macos/aerospace/PRD-aerospace-extensions.md) | What’s done vs pending |
| **Leader Key JSON** | [`macos/leaderkey/config.json`](macos/leaderkey/config.json) | Action tree |
| **Leader Key docs** | [`macos/leaderkey/leaderkey.README.md`](macos/leaderkey/leaderkey.README.md) | Chords, Accessibility, `defaults` |

**@ mentions in Cursor:** e.g. `@macos/aerospace/.aerospace.toml` + `@macos/aerospace/aerospace.readme.md` so structure and documented chords stay aligned.

---

## 2. XDG Base Directory (macOS & Linux)

**XDG** defines where config, data, cache, and state should go. On most systems:

| Variable | Default if unset | Typical role |
|----------|------------------|--------------|
| **`XDG_CONFIG_HOME`** | `~/.config` | Config files |
| **`XDG_DATA_HOME`** | `~/.local/share` | Data |
| **`XDG_STATE_HOME`** | `~/.local/state` | Logs, history |
| **`XDG_CACHE_HOME`** | `~/.cache` | Cache |

- **macOS:** Many CLI and GUI apps respect `~/.config/...` even though Apple also uses `~/Library/...`. This repo standardizes **AeroSpace** under **`~/.config/aerospace/`** (see below).
- **Linux:** Use the same relative paths under **`$XDG_CONFIG_HOME`** when copying configs from this repo for tools that follow XDG.
- **AeroSpace:** **macOS only** — there is no Linux port. Do **not** assume `aerospace.toml` applies on Linux; use this section for **other** dotfiles in the repo that target `~/.config/...`.

---

## 3. AeroSpace (macOS + XDG)

**Upstream:** [AeroSpace](https://github.com/nikitabobko/AeroSpace) — [Guide](https://nikitabobko.github.io/AeroSpace/guide.html), [Commands](https://nikitabobko.github.io/AeroSpace/commands.html).

| What | Path |
|------|------|
| **Live config (required layout)** | **`~/.config/aerospace/aerospace.toml`** (real file; filename **`aerospace.toml`**) |
| **Repo copy** | `macos/aerospace/.aerospace.toml` |

**XDG compliance rules (critical):**

1. Prefer **only** `~/.config/aerospace/aerospace.toml` for AeroSpace.
2. **Do not** keep **`~/.aerospace.toml`** at the same time as the XDG path — AeroSpace reports **ambiguity** if both exist.

**Deploy repo → Mac (after editing the repo file):**

```bash
mkdir -p ~/.config/aerospace
cp macos/aerospace/.aerospace.toml ~/.config/aerospace/aerospace.toml
aerospace reload-config
```

Run from the **repo root** (or use absolute paths). Adjust if your clone lives elsewhere.

**Agent workflow (same change set):**

1. Read **[`PRD-aerospace-extensions.md`](macos/aerospace/PRD-aerospace-extensions.md)** for backlog vs completed (§9).
2. Read **[`aerospace.readme.md`](macos/aerospace/aerospace.readme.md)** for the hotkey contract.
3. Edit **[`.aerospace.toml`](macos/aerospace/.aerospace.toml)**.
4. Update **`aerospace.readme.md`** and **`README.md`** in **`macos/aerospace/`** so tables match (see TOML header **AI_AGENT_SYNC_PROMPT**).
5. If the user wants it live, **`cp`** + **`aerospace reload-config`** as above.

**Verification:**

- `aerospace reload-config` exits **0**.
- `aerospace config --config-path` (if available on your version) should point at the file you expect.

---

## 4. Leader Key (macOS — not XDG)

Leader Key stores **`config.json`** under **Apple Application Support**, not under **`$XDG_CONFIG_HOME`**.

| What | Canonical path on Mac |
|------|------------------------|
| **Leader Key `config.json` (live)** | `~/Library/Application Support/Leader Key/config.json` |
| **Leader Key preferences (live)** | `~/Library/Preferences/com.brnbw.Leader-Key.plist` |

**Contrast:** AeroSpace uses **`~/.config/aerospace/`**; Leader Key does **not** by default. Do **not** move Leader Key’s JSON into `~/.config` unless the app explicitly supports it.

**“Ready to deploy” from git:** Treat **`macos/leaderkey/config.json`** as the **intended** config to copy **to** Application Support. It is **not** live until copied (or saved from the app).

### Cursor agents — Leader Key steps

1. **Read first:** [`macos/leaderkey/leaderkey.README.md`](macos/leaderkey/leaderkey.README.md).
2. **Edit source of truth:** [`macos/leaderkey/config.json`](macos/leaderkey/config.json).
3. **Keep docs in lockstep:** update `leaderkey.README.md` in the **same** change (see its **AI_AGENT_SYNC_PROMPT**).
4. **Optional plist export:**
   ```bash
   plutil -convert xml1 ~/Library/Preferences/com.brnbw.Leader-Key.plist -o macos/leaderkey/com.brnbw.Leader-Key.plist
   ```
5. **Deploy on Mac:**
   ```bash
   cp macos/leaderkey/config.json ~/Library/Application\ Support/Leader\ Key/config.json
   open 'leaderkey://config-reload'
   ```
6. **@ mentions:** `@macos/leaderkey/config.json` + `@macos/leaderkey/leaderkey.README.md`.

### Avoid bad copies

- **Repo → Mac:** intentional **deploy** (`cp` + `leaderkey://config-reload`).
- **Mac → Repo:** intentional **backup** after UI edits; diff before commit.
- **Do not** assume live file equals repo.

### Stop conditions (Leader Key)

Skip **`cp` to Application Support** when the user only wanted a draft, paths are machine-specific, or the user is **not on macOS**.

### Quick verification (Leader Key)

- `python3 -m json.tool macos/leaderkey/config.json > /dev/null`
- `open 'leaderkey://config-reload'`

**Upstream:** [mikker/LeaderKey](https://github.com/mikker/LeaderKey) (`com.brnbw.Leader-Key`).

---

## 5. Linux workstations

- **AeroSpace:** N/A (macOS only).
- **Other configs** in this repo: copy to **`$XDG_CONFIG_HOME`** (usually `~/.config`) preserving subdirectory names, **if** the target app supports XDG on Linux.
- **Leader Key:** macOS-only; skip deploy steps on Linux.

---

## 6. When to update this playbook

Update **[`PLAYBOOK.md`](PLAYBOOK.md)** when:

- A new **top-level dotfile area** gets a stable repo path and live deploy path.
- **XDG** or **AeroSpace** filename / location rules change upstream.
- Another agent adds a **repeatable workflow** that should stay consistent across sessions.

Also bump **[`PRD-aerospace-extensions.md`](macos/aerospace/PRD-aerospace-extensions.md)** §4 / §9 when AeroSpace backlog or completed work changes materially.
