# Leader Key (dotfiles backup)

Prefer **`macos/leaderkey/leaderkey.README.md`** for the full chord table, leader shortcut (**⌥ .**), prefs, and sync notes.

**Cursor / AI agents:** see **[`PLAYBOOK.md`](../../PLAYBOOK.md)** at repo root (paths, deploy vs backup, XDG vs Application Support, stop conditions).

| File | Live location |
|------|----------------|
| `config.json` | `~/Library/Application Support/Leader Key/config.json` |
| `com.brnbw.Leader-Key.plist` | XML copy of `~/Library/Preferences/com.brnbw.Leader-Key.plist` |

**Deploy from repo:**  
`cp macos/leaderkey/config.json ~/Library/Application\ Support/Leader\ Key/config.json && open 'leaderkey://config-reload'`
