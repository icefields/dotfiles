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

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

-- LUCI4 COLOUR THEME
local colours = {
    black = "#000000",
    red = "#91231c",
    green = "#65726f",
    badass = { -- source https://www.color-hex.com/color/bada55
        main = "#bada55",
        shade1 = "#a7c44c",
        shade6 = "#4a5722",
        shade8 = "#252b11",
        shade9 = "#121508",
        tint1 = "#c0dd66"
    },
    dead = { -- source https://www.color-hex.com/color/ffdead
        main = "#ffdead",
        shade2 = "#ccb18a",
        shade4 = "#998567",
        shade5 = "#7f6f56",
        shade6 = "#665845",
        shade7 = "#4c4233",
        shade8 = "#332c22",
        shade9 = "#191611",
        tint5 = "#ffeed6",
        tint6 = "#fff1de"
    }
}
-- END LUCI4 Colour Theme

theme.font = "UbuntuSansMono Nerd Font Mono Medium 11"

theme.topBar_bg = colours.dead.shade9

theme.bg_normal     = colours.dead.shade9
theme.bg_focus      = colours.dead.shade7 -- "#224442"
theme.bg_urgent     = colours.badass.main
theme.bg_minimize   = theme.bg_normal
theme.bg_systray    = colours.dead.shade8 -- "#4a5722" --theme.bg_normal
theme.systray_icon_spacing = dpi(5)

theme.fg_normal     = colours.dead.main -- "#d2f0cb"
theme.fg_focus      = colours.dead.tint5
theme.fg_urgent     = colours.badass.shade8
theme.fg_minimize   = colours.dead.shade4
theme.fg_systray = colours.dead.tint6

theme.useless_gap   = dpi(2)
theme.border_width  = dpi(2)
theme.border_normal = colours.dead.shade8
theme.border_focus  = colours.badass.main -- "#71cf5f"
theme.border_marked = colours.red

theme.topBar_border = dpi(0)
theme.mute_volume = colours.red

theme.taglist_font = "UbuntuSansMono Nerd Font Mono SemiBold 14"
theme.tasklist_fg_normal = colours.dead.tint6
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
    taglist_square_size, colours.green -- theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, colours.green -- theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
-- beautiful.notification_icon_size = dpi(66)
theme.notification_icon_size = dpi(66)

-- Variables set for theming the menu:
theme.menu_bg_normal = colours.badass.shade9 -- "#121716"
theme.menu_bg_focus = colours.badass.shade6
theme.menu_fg_normal = colours.dead.tint6
-- theme.menu_fg_focus = "#0000ff"
-- theme.menu_border_color = 
theme.menu_border_width = dpi(2)
-- theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_submenu = " "--" " --"▶ "
theme.menu_height = dpi(30)
theme.menu_width  = dpi(200)

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

-- application icons
theme.powerampache2speaker_icon = "~/.config/awesome/themes/luci4/icons/ic_speaker_colored_432px.svg"
theme.kitty_icon = "~/.config/awesome/themes/luci4/icons/kitty.svg"
theme.kittyArch_icon = "~/.config/awesome/themes/luci4/icons/kitty-arch.svg"
theme.ubuntu_icon = "~/.config/awesome/themes/luci4/icons/ubuntu.png"
theme.signal_icon = "~/.config/awesome/themes/luci4/icons/signal-desktop.png"
theme.notepadqq_icon = "~/.config/awesome/themes/luci4/icons/notepadqq.svg"
theme.kdenlive_icon = "~/.config/awesome/themes/luci4/icons/kdenlive.svg"
theme.neovim_icon = "~/.config/awesome/themes/luci4/icons/org.daa.NeovimGtk.svg"
theme.androidStudio_icon = "~/.config/awesome/themes/luci4/icons/studio.svg"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
