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
--- button_tooltip.lua
--- Generic AwesomeWM wibar button with tooltip and configurable callbacks.
---
--- Creates a clickable wibar button with:
---   - An icon textbox that updates from a shell script or callback
---   - A tooltip that populates from a shell script on hover
---   - Configurable click behavior (script, callback, or both)
---   - Optional icon refresh on mouse leave
---   - Optional delay before updating icon after click
---
--- Dependencies (passed via `args`):
---   args.gears     - gears module
---   args.awful     - awful module
---   args.beautiful - beautiful theme table
---   args.wibox     - wibox module
---   args.applyDpi  - DPI scaling function
---
--- Button arguments (passed via `buttonArgs`):
---   tooltipScript                - string: shell command run on hover to populate tooltip text
---   tooltipDefaultText           - string: fallback tooltip text before script returns (default: "...")
---   btnDefaultText               - string: default icon glyph (unicode or text)
---   buttonIconScript             - string: shell command to fetch icon text
---   buttonIconCallback           - function(button, icon): called after icon script returns,
---                                   or directly if no script provided
---   buttonClickScript            - string: shell command run on button press
---   buttonClickCallback          - function(button, icon): called after click script returns,
---                                   or directly if no click script provided
---   clickResponseUpdateIconDelay - number: seconds to wait before refreshing icon after
---                                   click script completes (default: immediate)
---   mouseLeaveCallback           - function(button, icon): called on mouse leave
---   refreshIconOnMouseLeave      - boolean: refresh icon from script on mouse leave
---                                   (default: true if no mouseLeaveCallback, false otherwise)
---
--- Returns: wibox widget (button with tooltip attached)
---
--- Examples:
---
---   -- 1. VPN toggle button with script + callback + delayed icon refresh
---   local buttonTooltip = require("common.button_tooltip")
---
---   local toggleScript = "vpn-toggle"
---   local statusScript = "vpn-status"
---   local function updateIcon(wifiButton, wifiIcon)
---       updateWifiIcon(awful, wifiIcon)
---   end
---
---   local button = buttonTooltip(args, {
---       tooltipScript             = statusScript,
---       buttonIconCallback        = updateIcon,
---       mouseLeaveCallback        = updateIcon,
---       clickResponseUpdateIconDelay = 5,
---       btnDefaultText            = "<U+F252>",
---       tooltipDefaultText        = "VPN Status ...",
---       buttonClickCallback = function(wifiButton, wifiIcon)
---           wifiButton.bg = nil
---           awful.spawn.easy_async_with_shell(toggleScript, function()
---               gears.timer.start_new(5, function()
---                   updateWifiIcon(awful, wifiIcon)
---                   return false
---               end)
---           end)
---       end,
---   })
---
---   -- 2. Simple reconnect button with script-only click
---   local buttonTooltip = require("common.button_tooltip")
---
---   local function getButton(args)
---       return buttonTooltip(args, {
---           tooltipScript      = config.statusScript,
---           btnDefaultText     = "<U+F0773>",
---           tooltipDefaultText = "VPN Status ...",
---           buttonClickScript  = config.reconnectScript,
---       })
---   end
---
---   return getButton
---
---   -- 3. Callback-only button (no shell scripts)
---   local button = buttonTooltip(args, {
---       btnDefaultText      = "<U+F011>",
---       tooltipDefaultText  = "Power menu",
---       buttonClickCallback = function(btn, ico)
---           -- handle click logic here
---       end,
---   })
---
--- Signal behavior:
---   mouse::enter  → sets bg to beautiful.bg_focus, spawns tooltipScript, updates tooltip
---   mouse::leave  → resets bg, optionally refreshes icon, calls mouseLeaveCallback
---   button::press → resets bg, runs buttonClickScript then buttonClickCallback,
---                    then updates icon (immediately or with delay)
---   button::release → restores bg to beautiful.bg_focus
---

local function createTooltip(button, awful, beautiful, tooltipScript, text)
    local tooltip = awful.tooltip {
        objects = { button },
        mode = "outside",
        align = "top",
        margin_leftright = 8,
        margin_topbottom = 4,
        preferred_positions = { "top", "bottom" },
        text = text or "...",
        bg = beautiful.tooltip_bg_color,
        fg = beautiful.tooltip_fg_color
    }

    local tooltipSpawned = false -- avoid piling up requests
    button:connect_signal("mouse::enter", function(c)
        c.bg = beautiful.bg_focus
        if tooltipScript then
            if not tooltipSpawned then
                tooltipSpawned = true
                awful.spawn.easy_async_with_shell(tooltipScript, function(stdout)
                    tooltip.text = stdout:gsub("%s+$", "")
                    tooltipSpawned = false
                end)
            end
        end
    end)

    button:connect_signal("mouse::leave", function(c) c.bg = nil end)
    return tooltip
end

local function updateIcon(awful, button, icon, iconScript, iconCallback)
    if iconScript then
        awful.spawn.easy_async_with_shell(iconScript, function(stdout)
            local status = stdout:gsub("%s+", "")
            icon.text = status
            if iconCallback then iconCallback(button, icon, status) end
        end)
    elseif iconCallback then
        iconCallback(button, icon)
    end
end

local function getButton(args, buttonArgs)
    local gears = args.gears
    local awful = args.awful
    local beautiful = args.beautiful
    local wibox = args.wibox
    local applyDpi = args.applyDpi

    local buttonIconScript = buttonArgs.buttonIconScript
    local buttonIconCallback = buttonArgs.buttonIconCallback
    local buttonClickScript = buttonArgs.buttonClickScript
    local buttonClickCallback = buttonArgs.buttonClickCallback
    local tooltipScript = buttonArgs.tooltipScript
    local btnDefaultText = buttonArgs.btnDefaultText or ""
    local tooltipDefaultText = buttonArgs.tooltipDefaultText or "..."
    local mouseLeaveCallback = buttonArgs.mouseLeaveCallback
    local clickResponseUpdateIconDelay = buttonArgs.clickResponseUpdateIconDelay
    local refreshIconOnMouseLeave = buttonArgs.refreshIconOnMouseLeave or (mouseLeaveCallback == nil)

    local button = wibox.widget {
        {
            id = "icon",
            text = btnDefaultText,
            widget = wibox.widget.textbox,
            align = "center",
            valign = "center",
            font = beautiful.topBar_button_font
        },
        widget = wibox.container.background,
        bg = "#00000000",
        fg = beautiful.topBar_fg,
        shape = gears.shape.rounded_bar,
        forced_width = applyDpi(beautiful.topBar_buttonSize),
        forced_height = applyDpi(beautiful.topBar_buttonSize),
    }
    local icon = button:get_children_by_id("icon")[1]
    local tooltip = createTooltip(button, awful, beautiful, tooltipScript, tooltipDefaultText)

    local clickTimer = nil
    -- If both script and callback exist, run the callback after receiving a
    -- response from the script call.
    -- If only callback present, call it directly.
    -- A delay can be set before updating the icon after click callback.
    button:connect_signal("button::press", function()
        button.bg = nil
        if buttonClickScript then
            awful.spawn.easy_async_with_shell(buttonClickScript, function(stdout)
                if buttonClickCallback then
                    buttonClickCallback(button, icon, stdout)
                end
                if clickResponseUpdateIconDelay then
                    if clickTimer then clickTimer:stop() end
                    clickTimer = gears.timer.start_new(clickResponseUpdateIconDelay, function()
                        updateIcon(awful, button, icon, buttonIconScript, buttonIconCallback)
                        return false
                    end)
                    clickTimer:again()
                else
                    updateIcon(awful, button, icon, buttonIconScript, buttonIconCallback)
                end
            end)
        elseif buttonClickCallback then
            buttonClickCallback(button, icon)
        end
    end)


    button:connect_signal("button::release", function(c) c.bg = beautiful.bg_focus end)

    button:connect_signal("mouse::leave", function(c)
        if refreshIconOnMouseLeave then
            updateIcon(awful, button, icon, buttonIconScript, buttonIconCallback)
        end
        -- c.bg = "#00000000"
        if mouseLeaveCallback then mouseLeaveCallback(button, icon) end
    end)

    -- Initial icon update
    updateIcon(awful, button, icon, buttonIconScript, buttonIconCallback)

    return button
end

return getButton

