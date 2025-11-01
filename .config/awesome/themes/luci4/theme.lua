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
-- ----- Luci4 Custom Theme for Awesome WM ------- --
-- -------- https://github.com/icefields --------- --
-----------------------------------------------------
-- theme.lua
-- wm-agnostic theme settings.

local colours = require("themes.luci4.colours")

local theme = {}
-- theme.icons = require("themes.luci4.application_icons")
theme.wallpapersPath = os.getenv("HOME") .. "/.config/awesome/themes/luci4/wallpapers"

local colour1 = colours.dead
local colour2 = colours.teal
theme.colour1 = colour1
theme.colour2 = colour2

-- opacity for tooltip, notifications, etc...
local mainOpacity = 0.6
local fgWidgetMain = colour2.tint7

theme.rect_radius = 4

local mainFont = "Terminess Nerd Font"  -- "UbuntuSansMono Nerd Font Mono Medium 11"
local sansFont = "UbuntuSans Nerd Font"
local heavyFont = "HeavyData Nerd Font" -- "UbuntuSansMono Nerd Font Mono SemiBold 14"

theme.font          = mainFont .. " SemiBold 12.5"
theme.tasklist_font = sansFont .. " 11"
theme.taglist_font  = heavyFont .. " 14"
theme.tooltip_font  = mainFont .. " 12"
theme.notification_font = sansFont .. " 10.5"
theme.hotkeys_font = mainFont .. " SemiBold 12.5"
theme.hotkeys_description_font = sansFont .. " 10"

-- awesome bar
theme.topBar_bg     = colour2.shade8
theme.topBar_height = 24
theme.topBar_border_dpi = 0
theme.topBar_position = "top"
theme.topBar_buttonSize = 24
theme.topBar_button_font = "Symbols Nerd Font Mono 9"
theme.topBar_buttonTooltip_font = "DejaVu Sans Mono 9"
theme.topBar_fg = colour2.tint7
-- theme.clock_bg = colour2.shade4

theme.bg_normal     = colour1.shade9
theme.bg_focus      = colour1.shade7 -- "#224442"
theme.bg_urgent     = colour2.main
theme.bg_minimize   = colour2.black-- shade8 --theme.bg_normal
theme.bg_systray    = colour2.shade4 -- "#4a5722" --theme.bg_normal
theme.systray_icon_spacing_dpi = 4
theme.systray_margin_dpi = 3

theme.fg_normal     = colour1.tint5 -- "#d2f0cb"
theme.fg_focus      = colour1.tint5
theme.fg_urgent     = colour2.shade8
theme.fg_minimize   = colour1.shade2
theme.fg_systray    = colour1.tint6

theme.useless_gap_dpi = 2
theme.border_width_dpi = 2
theme.border_normal = colour1.shade8
theme.border_focus  = colour1.main -- "#71cf5f"
theme.border_marked = colours.red

theme.mute_volume   = colours.red

-- tasklist_[bg|fg]_[focus|urgent]
theme.tasklist_border_width_dpi= 1.5
theme.tasklist_border_colour = colour2.main
theme.tasklist_fg_normal = fgWidgetMain
theme.tasklist_bg_focus = colour2.shade5
theme.tasklist_fg_focus = colour1.tint6

-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
theme.tooltip_opacity = mainOpacity
theme.tooltip_fg_color = fgWidgetMain
theme.tooltip_bg_color = colour2.shade9
theme.tooltip_border_width_dpi = 1
theme.tooltip_border_color = colour2.main

-- Generate taglist squares:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
theme.taglist_bg_focus = colour2.shade5
theme.taglist_fg_focus = colour1.tint7 --fgWidgetMain
theme.taglist_bg_empty = theme.bg_normal
theme.taglist_fg_empty = colour2.shade5
theme.taglist_bg_occupied = theme.bg_normal
theme.taglist_fg_occupied = colour2.tint4
theme.taglist_fg_urgent = theme.bg_normal
theme.taglist_bg_urgent = colour1.main

-- Variables set for theming notifications:
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_opacity = mainOpacity
theme.notification_icon_size_dpi = 66
theme.notification_bg = colour2.shade9
theme.notification_fg = fgWidgetMain
theme.notification_margin_dpi = 8
theme.notification_border_color = colour2.main
theme.notification_border_width_dpi = 2

-- Variables set for theming the menu:
theme.menu_bg_normal    = colour2.shade9 -- "#121716"
theme.menu_bg_focus     = colour2.shade6
theme.menu_fg_normal    = colour1.tint6
-- theme.menu_fg_focus = "#0000ff"
-- theme.menu_border_color = 
theme.menu_border_width_dpi = 2
-- theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_submenu = " "--" " --"▶ "
theme.menu_height_dpi = 30
theme.menu_width_dpi = 200

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
theme.hotkeys_opacity = mainOpacity
theme.hotkeys_group_margin_dpi = 12
-- theme.hotkeys_shape = 
theme.hotkeys_modifiers_fg = colour1.main
theme.hotkeys_bg = colour2.shade9
theme.hotkeys_fg = colour2.tint9
theme.hotkeys_border_width_dpi = 2
theme.hotkeys_border_color = colour2.tint4
theme.hotkeys_label_bg = colour2.tint7
theme.hotkeys_label_fg = colour2.shade9

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- titlebar_[bg|fg]_[normal|focus]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
