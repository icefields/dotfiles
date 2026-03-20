# macOS xonsh (based on `linux/.config/xonsh`)

This tree is the **macOS** profile. **`linux/.config/xonsh` is not modified** here.

## What each file is

| File | Role |
|------|------|
| `xonshrc.xsh` | Entrypoint: sources every `rc.d/*.py` in order. Point `DOTFILES` at your clone of this repo (or rely on default `~/my-dot-files`). |
| `rc.d/00_rc.py` | **Bootstrap:** strict `XDG_*`, `BUN_INSTALL`, `BUN_INSTALL_CACHE_DIR`, `LM_STUDIO_HOME`, `LM_STUDIO_MODELS_DIR`, `CURSOR_CONFIG_DIR`, `DOCKER_CONFIG`, PATH prepends, `Paths` for the rest of the stack, **interactive** abbrevs/aliases (git, macOS, zsh-style extras). |
| `rc.d/15_env_vars.py` | Optional `KEY="value"` lines from `$XDG_CONFIG_HOME/xonsh/shell_env`. |
| `rc.d/30_functions.py` | Script-backed aliases **only if** `~/scripts/...` files exist; `getpath` uses **pbcopy** when `fzf` is present. |
| `rc.d/31_awesome_functions.py` | Intentionally empty here (Awesome WM is Linux-only; see Linux tree). |
| `rc.d/50_colours.py` | Random prompt style + `LS_COLORS` from `~/scripts/shell_common/colour_schemes/*` if present. |
| `rc.d/65_prompt.py` | Custom `PROMPT` with git branch. |
| `rc.d/80_greeting.py` | **Interactive only:** optional greeting scripts + env summary line. |
| `shell_env.example` | Copy to `$XDG_CONFIG_HOME/xonsh/shell_env` when you need quoted secrets (see `currency_convert` in `30_functions.py`). |

## Install

1. `brew install xonsh` (and install **carapace** if you want the bridge; otherwise startup prints a skip message).
2. `export DOTFILES=/path/to/my-dot-files` (or use default `~/my-dot-files` in `xonshrc.xsh`).
3. Link rc: `ln -sf "$DOTFILES/macos/xonsh/xonshrc.xsh" ~/.xonshrc`

## XDG layout this config enforces

- **`XDG_CONFIG_HOME`** (default `~/.config`): **`bun/`** (install + `bun/install/cache`), **`lm-studio/`**, `cursor/`, `docker/`, `xonsh/shell_env`.
- **`XDG_DATA_HOME`** (default `~/.local/share`): `xonsh/` (history DB).
- **`XDG_CACHE_HOME`** (default `~/.cache`): optional other tools; Bun cache lives under **`~/.config/bun/install/cache`** to match `../scripts/xdg.swift`.
- **`XDG_STATE_HOME`** (default `~/.local/state`): `xonsh/` (traceback log).

`LM_STUDIO_MODELS_DIR` is set to **`~/Desktop/LMStudio-Models`** (created if missing). In **LM Studio → My models**, point the library at that folder (or another path you prefer).

### Bun

**`BUN_INSTALL=$XDG_CONFIG_HOME/bun`** and **`BUN_INSTALL_CACHE_DIR=$BUN_INSTALL/install/cache`**. To migrate from **`~/.bun`** without symlinks, run **`../scripts/xdg.swift`** (see script header and `xdg-prompts/*.mds`).

### LM Studio

**`LM_STUDIO_HOME=$XDG_CONFIG_HOME/lm-studio`**. Migrate from **`~/.lmstudio`** with the same script. Set **My models** in the app to **`~/Desktop/LMStudio-Models`** (or your preferred path). If the app ignores **`LM_STUDIO_HOME`**, file an issue with LM Studio; this layout assumes the env var is honored when set before launch.

### Cursor

`CURSOR_CONFIG_DIR` is **`$XDG_CONFIG_HOME/cursor`**. Cursor may still use **`~/.cursor`** for some data on macOS; treat this as **best-effort** and verify in Cursor settings/docs for your version.

## Zsh parity notes

- **`activate` (venv)** — not defined here: POSIX `source venv/bin/activate` is bash-oriented; use **`vox`** / xonsh venv workflows or ask before we add a wrapper.
- **`h` → history** — omitted to avoid clashing with xonsh builtins.
- **`agent`** — set only if `agent` is on **`PATH`** (e.g. `~/.local/bin/agent`).
- Linux-only **`jctl`**, Arch/Ubuntu/Fedora blocks, Asahi/tor aliases, and Awesome helpers are **removed or stubbed** compared to the Linux copy.

## Linux reference

Upstream copy and pip/xontrib notes: `README.linux-origin.md` and `../linux/.config/xonsh/`.
