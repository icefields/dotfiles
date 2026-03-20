# macOS xonsh — alias & abbrev audit

Source: `rc.d/00_rc.py` (interactive) + `rc.d/30_functions.py` (conditional).

Legend: **Keep** = fine on Mac · **Review** = optional / edge cases · **Delete?** = candidate to remove · **Linux** = not applicable on macOS.

---

## Abbrevs (xonsh expand-on-space)

| Name | Expands to | Mac | Note |
|------|------------|-----|------|
| `ad` | `git add .` | Keep | |
| `pus` / `pum` / `pud` | git push variants | Keep | |
| `com` | `git commit -m ` | Keep | trailing space intentional |
| `chb` / `che` / `pul` | git checkout / pull | Keep | |
| `dad` … `dpus` | gitdots | Review | Needs `~/.git-dotfiles` bare repo |
| `cpup` / `cp` | `rsync …` | Keep | Needs `brew install rsync` (macOS rsync is older but works) |
| `l` | eza/exa long `ls` | Review | Only if `eza` or `exa` installed (`brew install eza`) |
| `ca` | `bat --color=always` | Review | Only if `bat` installed (`brew install bat`) |
| `brewup` | `brew update && brew upgrade && brew cleanup` | Keep | Only if `brew` on PATH |

**Suggested changes (ask before editing):** none required; if you never use **gitdots** abbrevs, we could drop them.

---

## Aliases (`00_rc.py`)

| Name | Command / meaning | Mac | Note |
|------|-------------------|-----|------|
| `grep` / `egrep` / `fgrep` | `--color=auto` | Keep | BSD grep supports color |
| `..` / `...` / `....` | `cd` up | Keep | |
| `home` / `desk` / `docs` / `downloads` | `cd` | Keep | iCloud “Desktop & Documents” can change paths — still valid |
| `gpg-check` / `gpg-retrieve` | gpg2/gpg | Keep | Install GnuPG (`brew install gnupg`) if missing |
| `addup` … `newtag` | long git verbs | Keep | |
| `gs` … `grh` | short git | Keep | Duplicates *style* of long names; both kept intentionally |
| `psa` / `psgrep` / `psmem` / `pscpu` | ps pipelines | Keep | macOS `ps` is BSD; flags differ from Linux but these use `auxf` which works |
| `:q` | `exit` | Keep | |
| `df` | `df -h` | Keep | |
| `free` | `vm_stat` | Review | Not human-readable like Linux `free`; **suggestion:** replace with a small function wrapping `vm_stat` + awk, or install `free` from brew if a formula exists |
| `ports` | `lsof … grep LISTEN` | Keep | |
| `myip` / `weather` | `curl` | Keep | Needs network |
| `showfiles` / `hidefiles` | Finder defaults | Keep | macOS only |
| `flushdns` | `dscacheutil` + mDNSResponder | Keep | sudo prompts |
| `venv` | `python3 -m venv venv` | Keep | |
| `npmg` / `npml` | npm list | Keep | Needs node/npm |
| `tk` | `tmux kill-server` | Review | Destructive; **keep** if you use tmux (`brew install tmux`) |
| `reloadtmux` | source `~/.tmux.conf` | Keep | |
| `c` | `clear` | Review | Shadows nothing critical in xonsh; **keep** |
| `agent` | path to `agent` binary | Review | Only defined if `agent` on PATH (e.g. Cursor); **keep** |
| `gdb-*` | gdb variants | Review | Only if `gdb` installed (`brew install gdb` — may need codesigning on macOS) |
| `gitdots` | git with `--git-dir` | Review | Fails if bare repo missing |
| `vim` | `nvim` | Keep | If nvim installed |
| `ls` / `tree` / `ll` / `la` | eza/exa or fallback `ls` | Keep | Prefer `brew install eza` |
| `333` / `reload` | `source ~/.xonshrc` | Review | Assumes `~/.xonshrc` is your entrypoint |

**Delete? candidates (your call):** none mandatory. **Review closely:** `free` (poor ergonomics), `tk` (destructive), `gdb-*` (often absent on Mac).

---

## Aliases / helpers (`30_functions.py`)

| Name | Mac | Note |
|------|-----|------|
| `tari` / `backup` / `passgen` / `share*` | Review | Only if `~/scripts/...` files exist |
| `tarx` | Keep | |
| `pushb` | Review | Needs `lua` + `pushb.lua` |
| `getpath` | Keep | Uses **`pbcopy`** when `fzf` present; **`xclip` branch** is Linux-oriented — on Mac, install `fzf` (`brew install fzf`) |
| `currency_convert()` | Review | **Not an alias**; raises unless `CURRENCY_API` in `shell_env` |

**Delete?** Remove **`xclip` branch** in `getpath` on a Mac-only repo if you want zero Linux cruft (optional).

---

## Brew / Mac equivalents (when something is weak on macOS)

| Topic | Suggestion |
|-------|------------|
| `free` | Keep `vm_stat` or add a prettier wrapper; no perfect brew drop-in |
| `eza` / `bat` / `fzf` / `tmux` / `rsync` | `brew install eza bat fzf tmux rsync` |
| `gdb` | `brew install gdb` + follow codesigning notes for Darwin |
| Package updates | Already have **`brewup`** abbrev — use instead of Linux `upd` abbrevs |
| Linux `journalctl` | Not ported; use **`log show`** / **Console.app** (not added as alias here) |

---

## Conflicts / priority (your earlier rule)

- Long-form git aliases (`commit`, `push`, …) **coexist** with shorts (`gc`, `gp`, …).
- **`ls` / `l`** abbrev: eza wins when installed; fallback `ls -G` is macOS BSD `ls`.

If you want edits from this audit, say which rows to **remove** or **replace**; I will not change `00_rc.py` further until you confirm.
