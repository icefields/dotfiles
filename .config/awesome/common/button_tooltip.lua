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

local function getCacheFilename(cmd)
    return HomeEnv.HOME .. '/.cache/' .. cmd:gsub("[^%w%-_]", "_") .. '.txt'
end

local function readCache(cacheFile, defaultText)
    local f = io.open(cacheFile, "r")
    local text = defaultText
    if f then
        local stdout = f:read("*a")
        f:close()

        text = stdout --:gsub("%s+$", "")
    end
    return text
end

local function writeToCache(cacheFile, text)
    -- write to cache
    if cacheFile ~= nil and text and #text > 0 then
        local f = io.open(cacheFile, "w")
        if f then
            f:write(text)
            f:close()
        end
    end
end

local function createTooltip(button, awful, beautiful, tooltipArgs)
    local tooltipScript = tooltipArgs.tooltipScript
    local text = tooltipArgs.text
    local tooltipUseCache = tooltipArgs.tooltipUseCache or (tooltipScript ~= nil)
    local cacheFile = nil
    if tooltipUseCache then cacheFile = getCacheFilename(tooltipScript) end

    local tooltip = awful.tooltip {
        objects = { button },
        mode = "outside",
        align = "top",
        margin_leftright = 8,
        margin_topbottom = 4,
        preferred_positions = { "top", "bottom" },
        text = text or "...",
        font = beautiful.tooltip_font, -- "FiraCode Nerd Font Mono 11",
        bg = beautiful.tooltip_bg_color,
        fg = beautiful.tooltip_fg_color
    }

    local tooltipSpawned = false -- avoid piling up requests
    button:connect_signal("mouse::enter", function(c)
        c.bg = beautiful.bg_focus
        if tooltipUseCache and not tooltipSpawned then
            local tooltipText = readCache(cacheFile, text)
            if tooltipText and #tooltipText > 0 and tooltipText ~= tooltip.text then
                tooltip.text = "* " .. tooltipText
            end
            tooltipSpawned = false
            -- tooltip.text = stdout:gsub("%s+$", "") .. " *"
        end
        if tooltipScript then
            if not tooltipSpawned then
                tooltipSpawned = true
                awful.spawn.easy_async_with_shell(tooltipScript, function(stdout)
                    tooltip.text = stdout:gsub("%s+$", "")
                    tooltipSpawned = false
                    -- write to cache
                    if tooltipUseCache then
                        writeToCache(cacheFile, stdout)
                    end
                end)
            end
        end
    end)

    button:connect_signal("mouse::leave", function(c) c.bg = nil end)
    return tooltip
end

local function updateIcon(beautiful, awful, button, icon, iconArgs)
    local iconScript = iconArgs.buttonIconScript
    local iconCallback = iconArgs.buttonIconCallback
    local iconUseCache = iconArgs.iconUseCache -- or (iconScript ~= nil)
    if (iconUseCache == nil) then iconUseCache = (iconScript ~= nil) end
    local cacheFile = nil
    if iconUseCache then cacheFile = getCacheFilename(iconScript) end

    if iconScript then
        if iconUseCache then
            local iconText = readCache(cacheFile, icon.text)
            -- local iconText = stdout:gsub("%s+$", "")
            if iconText and #iconText > 0 then
                if iconText ~= icon.text then
                    icon.text = iconText
                    button.fg = beautiful.colour1.shade7
                end
            end
        end

        awful.spawn.easy_async_with_shell(iconScript, function(stdout)
            local iconText = string.gsub(stdout, "%s+", " ")--:gsub("%s+", "")
            if iconText and #iconText > 0 and iconText ~= icon.text then
                icon.text = iconText
            end
            if (button.fg ~= beautiful.topBar_fg) then
                button.fg = beautiful.topBar_fg
            end
            if iconCallback then iconCallback(button, icon, iconText) end
            if iconUseCache then
                writeToCache(cacheFile, iconText)
            end
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
    local tooltipUseCache = buttonArgs.tooltipUseCache
    local iconUseCache = buttonArgs.iconUseCache
    local paddingL = buttonArgs.buttonPaddingLeft or 0 --beautiful.topBar_buttonSize
    local paddingR = buttonArgs.buttonPaddingRight or 0 --beautiful.topBar_buttonSize
    local mouseScrollDownCallback = buttonArgs.mouseScrollDownCallback
    local mouseScrollUpCallback = buttonArgs.mouseScrollUpCallback
    local mouseScrollDownScript = buttonArgs.mouseScrollDownScript
    local mouseScrollUpScript = buttonArgs.mouseScrollUpScript

    -- paddings can be negative, but not less than zero.
    local defaultPadding = 3
    if (defaultPadding + paddingL) < 0 then
        paddingL = 0
    else
        paddingL = applyDpi(defaultPadding + paddingL)
    end
    if (defaultPadding + paddingR) < 0 then
        paddingR = 0
    else
        paddingR = applyDpi(defaultPadding + paddingR)
    end

    local iconArgs = {
        buttonIconScript = buttonIconScript,
        buttonIconCallback = buttonIconCallback,
        iconUseCache = iconUseCache
    }

    local button = wibox.widget {
        {
            {
                {
                    id = "icon",
                    text = btnDefaultText,
                    widget = wibox.widget.textbox,
                    font = beautiful.topBar_button_font
                },
                widget = wibox.container.place,
                halign = "center",
                valign = "center",
                max_content_width = applyDpi(200)
            },
            widget = wibox.container.margin,
            left = paddingL,
            right = paddingR
        },
        widget = wibox.container.background,
        bg = "#00000000",
        fg = beautiful.topBar_fg,
        shape = gears.shape.rounded_bar,
        forced_height = applyDpi(beautiful.topBar_buttonSize),
        buttons = {
            -- This is redundant, check button:connect_signal("button::press",
            -- Left click
            awful.button({ }, 1, function()
            end),
            -- Scroll up
            awful.button({ }, 4, function()
            end),
            -- Scroll down
            awful.button({ }, 5, function()
            end),
        }
    }

    local icon = button:get_children_by_id("icon")[1]
    createTooltip(button, awful, beautiful, {
        tooltipScript = tooltipScript,
        text = tooltipDefaultText,
        tooltipUseCache = tooltipUseCache
    })

    local clickTimer = nil
    -- If both script and callback exist, run the callback after receiving a
    -- response from the script call.
    -- If only callback present, call it directly.
    -- A delay can be set before updating the icon after click callback.
    button:connect_signal("button::press", function(self, lx, ly, btn, mods)
        if btn == 1 then
            button.bg = nil
            if buttonClickScript then
                awful.spawn.easy_async_with_shell(buttonClickScript, function(stdout)
                    if buttonClickCallback then
                        buttonClickCallback(button, icon, stdout)
                    end
                    if clickResponseUpdateIconDelay then
                        if clickTimer then clickTimer:stop() end
                        clickTimer = gears.timer.start_new(clickResponseUpdateIconDelay, function()
                            updateIcon(beautiful, awful, button, icon, iconArgs)
                            return false
                        end)
                        clickTimer:again()
                    else
                        updateIcon(beautiful, awful, button, icon, iconArgs)
                    end
                end)
            elseif buttonClickCallback then
                buttonClickCallback(button, icon)
            end
        elseif btn == 4 then
            -- Scroll up
            if mouseScrollUpScript then
                awful.spawn.easy_async(mouseScrollUpScript, function() end)
            end
            if mouseScrollUpCallback then mouseScrollUpCallback() end
        elseif btn == 5 then
            -- Scroll down
            if mouseScrollDownScript then
                awful.spawn.easy_async(mouseScrollDownScript, function() end)
            end
            if mouseScrollDownCallback then mouseScrollDownCallback() end
        end
    end)


    button:connect_signal("button::release", function(c) c.bg = beautiful.bg_focus end)

    button:connect_signal("mouse::leave", function(c)
        if refreshIconOnMouseLeave then
            updateIcon(beautiful, awful, button, icon, iconArgs)
        end
        -- c.bg = "#00000000"
        if mouseLeaveCallback then mouseLeaveCallback(button, icon) end
    end)

    -- Initial icon update
    updateIcon(beautiful, awful, button, icon, iconArgs)

    return button
end

return getButton

