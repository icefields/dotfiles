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

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local colours = require("themes.luci4.colours")

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}
theme.icons = require("themes.luci4.application_icons")

local colour1 = colours.dead
local colour2 = colours.teal

theme.rect_radius = 6

theme.font          = "UbuntuSansMono Nerd Font Mono Medium 11"
theme.tasklist_font = "UbuntuSansMono Nerd Font Mono 10"
theme.taglist_font  = "UbuntuSansMono Nerd Font Mono SemiBold 14"

theme.topBar_bg     = colour2.shade8
theme.topBar_border = dpi(0)

theme.bg_normal     = colour1.shade9
theme.bg_focus      = colour1.shade7 -- "#224442"
theme.bg_urgent     = colour2.main
theme.bg_minimize   = colour2.black-- shade8 --theme.bg_normal
theme.bg_systray    = colour2.shade4 -- "#4a5722" --theme.bg_normal
theme.systray_icon_spacing = dpi(4)
theme.systray_margin = dpi(3)

theme.fg_normal     = colour1.tint5 -- "#d2f0cb"
theme.fg_focus      = colour1.tint5
theme.fg_urgent     = colour2.shade8
theme.fg_minimize   = colour1.shade2
theme.fg_systray    = colour1.tint6

theme.useless_gap   = dpi(2)
theme.border_width  = dpi(2)
theme.border_normal = colour1.shade8
theme.border_focus  = colour2.main -- "#71cf5f"
theme.border_marked = colours.red

theme.mute_volume   = colours.red

theme.tasklist_fg_normal = colour1.tint6
-- theme.taglist_bg_focus = theme.bg_normal
-- theme.taglist_fg_focus = theme.fg_systray
-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(11)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, colour2.shade2 -- colours.green
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, colour2.main -- theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_icon_size = dpi(66)

-- Variables set for theming the menu:
theme.menu_bg_normal    = colour2.shade9 -- "#121716"
theme.menu_bg_focus     = colour2.shade6
theme.menu_fg_normal    = colour1.tint6
-- theme.menu_fg_focus = "#0000ff"
-- theme.menu_border_color = 
theme.menu_border_width = dpi(2)
-- theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_submenu = " "--" " --"▶ "
theme.menu_height = dpi(30)
theme.menu_width  = dpi(200)

theme.clock_bg = colour2.shade4
theme.clock_fg = colour2.tint3
theme.tasklist_border_width  = dpi(1.5)
theme.tasklist_border_colour = colour2.shade3
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path.."default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path.."default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_path.."default/titlebar/maximized_focus_active.png"

-- Luci4 wallpaper, comment out if not using nitrogen
-- theme.wallpaper =  "/home/lucifer/Pictures/wallpapers/wallhalla-28-2560x1440.jpg" --wallhalla-48-3840x2160.jpg"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
