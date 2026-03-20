# macOS scripts

## `xdg.swift` (Swift — prompts in `xdg-prompts/*.mds`)

Audits **`$HOME`** depth‑1 dot files for **XDG-style layout**, writes a **Markdown report** with a **score**, **agent maintenance** and **strategies** text loaded from **`xdg-prompts/agent-maintenance.mds`** and **`xdg-prompts/strategies.mds`**, and supports **verified migration** (no symlinks).

```bash
chmod +x macos/scripts/xdg.swift   # optional: ./xdg.swift …

cd macos/scripts
swift xdg.swift                    # default: audit
swift xdg.swift audit              # write report (see path printed)
swift xdg.swift audit --stdout     # print Markdown to stdout
swift xdg.swift audit --out ~/Desktop/xdg-report.md

swift xdg.swift check              # bun / lm-studio / cursor pair status
swift xdg.swift migrate            # dry-run
swift xdg.swift migrate --apply --yes
swift xdg.swift migrate --apply --yes --with-npm --with-docker
```

**Default report path:** `$XDG_STATE_HOME/xdg-compliance-report.md` (usually `~/.local/state/xdg-compliance-report.md`). Override with **`XDG_AUDIT_OUT`** or **`--out`**.

**Exceptions** (not counted as violations): **`.ssh`**, **`.cache`**, **`.local`**, **`.config`**, shell init files, common editor/history files, macOS metadata (`.Trash`, `.DS_Store`, …).

After **`migrate --apply`**, source **`~/.config/xdg-env-macos.sh`** from **`~/.zprofile`** (or rely on **`macos/xonsh/rc.d/00_rc.py`**).

**Agents:** edit **`xdg.swift`** (`classify`, scoring, migrate targets) and **`xdg-prompts/*.mds`** when you add a new compliant app or change guidance; re-run **`audit`** to refresh the report.
