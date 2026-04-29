-----------------------------------------------------
-- ----------------------------------------------- --
--   ▄        ▄     ▄  ▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄  ▄     ▄   --
--  ▐░▌      ▐░▌   ▐░▌▐░█▀▀▀▀▀  ▀▀█░█▀▀ ▐░▌   ▐░▌  --
--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░█   █░▌  --
--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░░░░░░░▌  --
--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌    ▀▀▀▀▀█░▌  --
--  ▐░█▄▄▄▄▄ ▐░█▄▄▄█░▌▐░█▄▄▄▄▄  ▄▄█░█▄▄       ▐░▌  --
--   ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀        ▀   --
-- ----------------------------------------------- --
-- -------- Luci4 config for Awesome WM  --------- --
-- -------- https://github.com/icefields --------- --
-----------------------------------------------------
-- common/notification.lua
--- notification.lua
--- Generic AwesomeWM notification wrapper for consistent, DRY notifications.
---
--- Provides a centralized `send` function and enum-style constants for
--- positions and presets. All theming is pulled from `beautiful`, so your
--- entire wibar and notification stack stays visually consistent without
--- scattering hardcoded colors everywhere.
---
--- Dependencies (injected per call):
---   naughty  - naughty notification module
---   beautiful - beautiful theme table
---
--- Exported table:
---   send(button, icon, ...)   - wait no that's button_tooltip
---   send(naughty, beautiful, notifArgs) - sends a notification
---   POSITION  - enum table for notification positions
---   PRESET    - enum table for notification presets (maps to naughty.config.presets)
---
--- POSITION enum:
---   TOP_RIGHT    = "top_right"
---   TOP_LEFT     = "top_left"
---   BOTTOM_RIGHT = "bottom_right"
---   BOTTOM_LEFT  = "bottom_left"
---   TOP_MIDDLE   = "top_middle"
---   BOTTOM_MIDDLE = "bottom_middle"
---
--- PRESET enum:
---   LOW      = "low"       → naughty.config.presets.low
---   NORMAL   = "normal"    → naughty.config.presets.normal
---   CRITICAL = "critical"  → naughty.config.presets.critical
---
--- notifArgs fields:
---   title   - string: notification title (default: "")
---   text    - string: notification body text (default: "")
---   icon    - string: path to icon file (default: nil)
---   timeout - number: seconds before auto-dismiss, 0 = persistent (default: 5)
---   position - string: one of POSITION enum values (default: POSITION.TOP_RIGHT)
---   preset   - string: one of PRESET enum values (default: PRESET.NORMAL)
---
--- Theming (all pulled from beautiful, no overrides exposed by design):
---   bg           → beautiful.tooltip_bg_color
---   fg           → beautiful.tooltip_fg_color
---   border_color → beautiful.border_normal
---   border_width → beautiful.border_width_dpi
---   font         → beautiful.titleFont
---
--- Notes:
---   - Uses `preset` (not `urgency`). On some Arch git builds of AwesomeWM,
---     `urgency` causes a nil table insert crash. `preset` maps directly to
---     `naughty.config.presets` keys via the PRESET enum, which is safer.
---   - If the preset key doesn't exist in `naughty.config.presets` on your
---     build, it falls back to `naughty.config.presets.normal` instead of
---     passing nil and exploding.
---   - `position` may also be unsupported on git builds. If it causes issues,
---     handle positioning through naughty rules in rc.lua instead.
---
--- Examples:
---
---   -- 1. Minimal notification (all defaults)
---   local notif = require("common.notification")
---
---   notif.send(naughty, beautiful, {
---       title = "VPN Connected",
---       text = "Tunnel is up",
---   })
---
---   -- 2. Critical persistent notification
---   notif.send(naughty, beautiful, {
---       title = "Ampache Down",
---       text = "Music server unreachable",
---       timeout = 0,
---       preset = notif.PRESET.CRITICAL,
---   })
---
---   -- 3. Full control with custom position and icon
---   notif.send(naughty, beautiful, {
---       title = "Docker Container Restarted",
---       text = "mastodon-web is back online",
---       icon = "/usr/share/icons/docker.png",
---       timeout = 10,
---       position = notif.POSITION.TOP_LEFT,
---       preset = notif.PRESET.LOW,
---   })
---
---   -- 4. Inside a button_tooltip click callback [1]
---   local buttonTooltip = require("common.button_tooltip")
---   local notif = require("common.notification")
---
---   local button = buttonTooltip(args, {
---       btnDefaultText = "<U+F252>",
---       tooltipDefaultText = "VPN Status ...",
---       tooltipScript = statusScript,
---       buttonClickCallback = function(btn, ico)
---           awful.spawn.easy_async_with_shell(toggleScript, function()
---               notif.send(naughty, beautiful, {
---                   title = "VPN Toggled",
---                   text = "Reconnecting in 5s...",
---                   preset = notif.PRESET.NORMAL,
---               })
---           end)
---       end,
---   })
---
---   -- 5. Low-priority background notification
---   notif.send(naughty, beautiful, {
---       title = "Matrix Sync",
---       text = "Bridges reconnected",
---       timeout = 3,
---       preset = notif.PRESET.LOW,
---       position = notif.POSITION.BOTTOM_RIGHT,
---   })
---

local POSITION = {
    TOP_RIGHT = "top_right",
    TOP_LEFT = "top_left",
    BOTTOM_RIGHT = "bottom_right",
    BOTTOM_LEFT = "bottom_left",
    TOP_MIDDLE = "top_middle",
    BOTTOM_MIDDLE = "bottom_middle",
}

local PRESET = {
    LOW = "low",
    NORMAL = "normal",
    CRITICAL = "critical",
}

local function send(naughty, beautiful, notifArgs)
    local title = notifArgs.title or ""
    local text = notifArgs.text or ""
    local icon = notifArgs.icon
    local timeout = notifArgs.timeout or 5
    local position = notifArgs.position or POSITION.TOP_RIGHT
    local preset = notifArgs.preset or PRESET.NORMAL

    -- Guard against nil preset.
    local presetObj = naughty.config.presets[preset] or naughty.config.presets.normal

    naughty.notify({
        title = title,
        text = text,
        timeout = timeout,
        icon = icon,
        position = position,
        bg = beautiful.tooltip_bg_color,
        fg = beautiful.tooltip_fg_color,
        border_color = beautiful.border_normal,
        border_width = beautiful.border_width_dpi,
        font = beautiful.titleFont,
        preset = presetObj,
    })
end

return {
    send = send,
    POSITION = POSITION,
    PRESET = PRESET,
}

