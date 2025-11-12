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

local homeDir = os.getenv("HOME")

local statusCmd = "redshift -p"
local toggleCmd = homeDir .. "/scripts/applaunch/redshift_toggle.sh" 
local getIconCmd = homeDir .. "/scripts/applaunch/redshift_get.sh"

local function createRedshiftTooltip(button, args)
    local awful = args.awful
    local beautiful = args.beautiful
    local gears = args.gears

    local filterTooltip = awful.tooltip {
        objects = { button },
        mode = "outside",
        align = "top",
        margin_leftright = 8,
        margin_topbottom = 4,
        preferred_positions = { "top", "bottom" },
        text = "Loading ...",
        bg = beautiful.tooltip_bg_color,
        fg = beautiful.tooltip_fg_color,
        font = beautiful.topBar_button_font
    }
    return filterTooltip
end

local function getButton(args)
    local gears = args.gears
    local awful = args.awful
    local beautiful = args.beautiful
    local wibox = args.wibox
    local fallbackIcon = ""  --      

    local button = wibox.widget {
        {
            id = "icon",
            text = fallbackIcon,
            widget = wibox.widget.textbox,
            align = "center",
            valign = "center",
            font = beautiful.topBar_button_font
        },
        widget = wibox.container.background,
        bg = "#00000000",  -- Transparent background
        fg = beautiful.topBar_fg,
        shape = gears.shape.rounded_bar,
        forced_height = beautiful.topBar_buttonSize
    }

    local filterTooltip = createRedshiftTooltip(button, args)
    local iconWidget = button:get_children_by_id("icon")[1]

    -- Function to update the icon based on Redshift status
    local function updateIcon(awful, iconWidget)
        awful.spawn.easy_async_with_shell(getIconCmd, function(stdout)
            iconWidget.text = stdout:gsub("\n", ""):gsub("\r", "")
        end)
    end

    -- Initial update.
    awful.spawn.easy_async_with_shell(toggleCmd, function(stdout)
        local icon = stdout:gsub("\n", ""):gsub("\r", "")
        if icon == "" then icon = fallbackIcon end
        iconWidget.text = icon
    end)

    -- Toggle on button press.
    button:connect_signal("button::press", function()
        awful.spawn.easy_async_with_shell(toggleCmd, function(stdout)
            local icon = stdout:gsub("\n", ""):gsub("\r", "")
            if icon == "" then icon = fallbackIcon end
            iconWidget.text = icon
        end)
    end)

    button:connect_signal("mouse::enter", function(c)
        c.bg = beautiful.bg_focus
        awful.spawn.easy_async_with_shell(statusCmd, function(stdout)
            filterTooltip.text = stdout:gsub("%s+$", "")
            updateIcon(awful, iconWidget)
        end)
    end)

    -- Clear background on mouse leave.
    button:connect_signal("mouse::leave", function(c) c.bg = nil end)

    return wibox.container.margin(button, 1, 1, 0, 0) -- with added padding
end

return getButton

