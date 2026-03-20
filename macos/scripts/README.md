# macOS scripts

**Repo catalog:** brief listings for all OS script trees live in **[`scripts/README.md`](../../scripts/README.md)**.

**AI agents:** when you add or materially change a script in this folder, update **`scripts/README.md`** in the **same change** (see that file’s agent section). Keep this README’s **usage blocks** and **flags** accurate for macOS scripts here.

---

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

## `dock-no-animation.swift` (Swift)

Sets **`com.apple.dock`** **`autohide-time-modifier`** to **`0`** so the Dock’s **show/hide animation** (when **Automatically hide and show the Dock** is on) is effectively instant, then restarts the Dock.

```bash
cd macos/scripts
swift dock-no-animation.swift          # apply + restart Dock
swift dock-no-animation.swift --show   # print current value only
```

Revert to Apple’s default by removing the key, e.g. `defaults delete com.apple.dock autohide-time-modifier && killall Dock`.
