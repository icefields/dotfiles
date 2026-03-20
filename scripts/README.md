# Scripts — repo-wide index

This repo keeps **portable utility scripts** under OS-specific trees. Use this file as the **single catalog** of what lives where; platform folders may hold **longer usage notes** (especially [`macos/scripts/README.md`](../macos/scripts/README.md)).

**Out of scope for row-by-row listings:** helper binaries and snippets **inside** app configs (for example `linux/.config/waybar/scripts/`, `linux/.config/awesome/scripts/`, `linux/.config/mpv/scripts/`). Treat those as **part of their parent config**; only add them here if you promote them to **`linux/scripts/`** or **`macos/scripts/`**.

---

## macOS — [`macos/scripts/`](../macos/scripts/)

| Script | Summary |
|--------|---------|
| [`xdg.swift`](../macos/scripts/xdg.swift) | XDG-style `$HOME` dot audit, Markdown report, optional verified migration (Bun, LM Studio, Cursor, npm, Docker). Prompts: [`xdg-prompts/`](../macos/scripts/xdg-prompts/). |
| [`dock-no-animation.swift`](../macos/scripts/dock-no-animation.swift) | Sets `com.apple.dock` `autohide-time-modifier` to `0` and restarts Dock (instant autohide). |

**Detail + examples:** [`macos/scripts/README.md`](../macos/scripts/README.md).

---

## Linux — [`linux/scripts/`](../linux/scripts/)

### Top level

| Script | Summary |
|--------|---------|
| [`backup-mariadb.sh`](../linux/scripts/backup-mariadb.sh) | MariaDB backup helper. |
| [`btrfs-trim.sh`](../linux/scripts/btrfs-trim.sh) | Trigger Btrfs `fstrim` / maintenance. |
| [`clipboard.sh`](../linux/scripts/clipboard.sh) | Clipboard utility (X11/Wayland context). |
| [`cloneSdcard.sh`](../linux/scripts/cloneSdcard.sh) | SD card clone/imaging workflow. |
| [`github_latest_download.sh`](../linux/scripts/github_latest_download.sh) | Download latest release asset from GitHub. |
| [`instagram-video-convert.sh`](../linux/scripts/instagram-video-convert.sh) | FFmpeg-oriented convert for Instagram-friendly video. |
| [`kitty-font-restore.sh`](../linux/scripts/kitty-font-restore.sh) | Restore Kitty font settings. |
| [`kittyviewer.sh`](../linux/scripts/kittyviewer.sh) | Cycle through images in cwd via Kitty. |
| [`mount-btrfs-usb.sh`](../linux/scripts/mount-btrfs-usb.sh) | Mount Btrfs USB volume. |
| [`openwebui-docker.sh`](../linux/scripts/openwebui-docker.sh) | Run Open WebUI via Docker. |
| [`oscheck.sh`](../linux/scripts/oscheck.sh) | Print kernel, distro, and package counts (Arch/Mint/Fedora branches). |
| [`passgen.sh`](../linux/scripts/passgen.sh) | Password generator. |
| [`play_dir.sh`](../linux/scripts/play_dir.sh) | Play audio files under a directory with `mpv` (sorted or `--random`). |
| [`png2svg.sh`](../linux/scripts/png2svg.sh) | PNG → SVG conversion helper. |
| [`rebootToMac.sh`](../linux/scripts/rebootToMac.sh) | Reboot into macOS (dual-boot machines). |
| [`screenshot.sh`](../linux/scripts/screenshot.sh) | Screenshot capture. |
| [`screenshot_extra_features.sh`](../linux/scripts/screenshot_extra_features.sh) | Screenshot with extra options. |
| [`share.sh`](../linux/scripts/share.sh) | Upload via [self-hosted-sharelink](https://github.com/icefields/self-hosted-sharelink); optional Mega path. |
| [`share-mega.py`](../linux/scripts/share-mega.py) | Upload file to Mega.nz and copy link to clipboard (`MEGA_*` env). |
| [`share_find.sh`](../linux/scripts/share_find.sh) | `find` under `$HOME` with prune paths from [`share_find.conf`](../linux/scripts/share_find.conf). |
| [`start-ollama.sh`](../linux/scripts/start-ollama.sh) | Start Ollama service/workflow. |
| [`test-fonts.sh`](../linux/scripts/test-fonts.sh) | Font preview / test. |
| [`toggle-pipewire-profile.sh`](../linux/scripts/toggle-pipewire-profile.sh) | Switch PipeWire profile. |
| [`toggle-wifi-profile.sh`](../linux/scripts/toggle-wifi-profile.sh) | Switch Wi‑Fi connection profile. |
| [`tor_relay_reset.sh`](../linux/scripts/tor_relay_reset.sh) | Disable torsocks mode and signal Tor control port (NEWNYM-style reset). |
| [`unzip-bulk.sh`](../linux/scripts/unzip-bulk.sh) | Bulk unzip archives. |
| [`update-openwebui.sh`](../linux/scripts/update-openwebui.sh) | Update Open WebUI deployment. |
| [`vpn_home.sh`](../linux/scripts/vpn_home.sh) | OpenVPN client using `VPN_HOME_*` / `OVPN_HOME_CONFIG` env creds. |
| [`zip_and_cloak.sh`](../linux/scripts/zip_and_cloak.sh) | Create encrypted 7z archive with header encryption (`-mhe`). |

### `linux/scripts/applaunch/`

| Script | Summary |
|--------|---------|
| [`power-management.sh`](../linux/scripts/applaunch/power-management.sh) | Power / session management launcher. |
| [`redshift_get.sh`](../linux/scripts/applaunch/redshift_get.sh) | Query Redshift state. |
| [`redshift_toggle.sh`](../linux/scripts/applaunch/redshift_toggle.sh) | Toggle Redshift on/off. |
| [`sound-settings.sh`](../linux/scripts/applaunch/sound-settings.sh) | Open sound settings UI. |

### `linux/scripts/ffmpeg/`

| Script | Summary |
|--------|---------|
| [`convert-mp3.fish`](../linux/scripts/ffmpeg/convert-mp3.fish) | Fish: convert media to MP3. |
| [`convert-opus.fish`](../linux/scripts/ffmpeg/convert-opus.fish) | Fish: convert media to Opus. |

### `linux/scripts/shell_common/`

| Path | Summary |
|------|---------|
| [`backup.sh`](../linux/scripts/shell_common/backup.sh) | Backup helper. |
| [`luci_greeting.sh`](../linux/scripts/shell_common/luci_greeting.sh) / [`luci_greeting.lua`](../linux/scripts/shell_common/luci_greeting.lua) | Shell / Lua greeting for login or prompt hooks. |
| [`passgen_wrapper.sh`](../linux/scripts/shell_common/passgen_wrapper.sh) | Wrapper around password generation. |
| [`pushb.lua`](../linux/scripts/shell_common/pushb.lua) | Lua: interactive `git push -u origin` for the current branch. |
| [`shell_greeting.lua`](../linux/scripts/shell_common/shell_greeting.lua) | Lua greeting script. |
| [`tari.sh`](../linux/scripts/shell_common/tari.sh) | Create a `.tar.gz` of a path; archive name flattens `/` in the argument. |
| [`update_packages.sh`](../linux/scripts/shell_common/update_packages.sh) | Distro package update wrapper. |
| [`colour_schemes/`](../linux/scripts/shell_common/colour_schemes/) | Named terminal colour snippets (e.g. Dracula, Nord), not standalone entrypoints. |

### `linux/scripts/distrobox-remount_host.sh`

Bind-mounts host `resolv.conf` / `hosts` into the guest paths used by Distrobox (paths inside the file are **machine-specific**; edit before use).

---

## Instructions for AI agents

**Keep the catalog honest.** When you **add**, **remove**, or **rename** any tracked script under **`macos/scripts/`** or **`linux/scripts/`**, or change what a script **does** in a way users would search for in this index:

1. **Update this file** (`scripts/README.md`): adjust the **table row** (path + one-line summary). If you add a **new subdirectory** of scripts, add a **subsection** and table.
2. **macOS only:** update **[`macos/scripts/README.md`](../macos/scripts/README.md)** in the **same commit/change** with **usage**, **flags**, and **dependencies** as needed (this file stays **brief**).
3. **Linux only:** if a script is non-obvious, prefer a **short comment or `--help`** in the script itself; only expand `linux/scripts/` README if one is added later.
4. **Playbook:** if scripts become a **new top-level workflow** (new canonical folder, deploy rules), add a row or subsection to **[`PLAYBOOK.md`](../PLAYBOOK.md)**.

**While iterating:** if you touch a script multiple times in one session, **refresh the summary row once** before finishing so the index matches the final behaviour.

**Do not** list every file under `linux/.config/**/scripts/` here unless the user asks for a full WM/mpv inventory; those stay documented with their stack (Awesome, Waybar, etc.).
