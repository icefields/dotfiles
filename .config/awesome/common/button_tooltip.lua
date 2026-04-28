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

    button:connect_signal("mouse::enter", function(c)
        c.bg = beautiful.bg_focus
        awful.spawn.easy_async_with_shell(tooltipScript, function(stdout)
            tooltip.text = stdout:gsub("%s+$", "")
        end)
    end)

    button:connect_signal("mouse::leave", function(c)
        c.bg = nil
    end)

    return tooltip
end

local function updateIcon(awful, button, icon, iconScript, iconCallback)
    if iconScript then
        awful.spawn.easy_async_with_shell(iconScript, function(stdout)
            local status = stdout:gsub("%s+", "")
            icon.text = status
            if iconCallback then iconCallback(button, icon) end
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

    if tooltipScript then
        local tooltip = createTooltip(button, awful, beautiful, tooltipScript, tooltipDefaultText)
    end

    -- If both script and callback exist, run the callback after receiving a
    -- response from the script call.
    -- If only callback present, call it directly.
    -- A delay can be set before updating the icon after click callback.
    button:connect_signal("button::press", function()
        button.bg = nil
        if buttonClickScript then
            awful.spawn.easy_async_with_shell(buttonClickScript, function()
                if buttonClickCallback then
                    buttonClickCallback(button, icon)
                end
                if clickResponseUpdateIconDelay then
                    gears.timer.start_new(clickResponseUpdateIconDelay, function()
                        updateIcon(awful, button, icon, buttonIconScript, buttonIconCallback)
                        return false
                    end)
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

