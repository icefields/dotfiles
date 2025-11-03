----------------------------------------------------------------------
-- Layout Definitions Table (Universal with map field)
--
-- Clean, WM-agnostic layout definition system.
-- Works for AwesomeWM, Hyprland, Qtile, or any other tiling WM.
--
-- Fields:
--   enabled        – Whether layout should be active
--   position       – Sort order (lower = earlier)
--   label          – Display name
--   group          – Category ("tiling", "floating", "special")
--   variant        – Optional subcategory ("left", "dwindle", etc.)
--   icon           – Icon path or theme variable (shared)
--   comment        – Description / documentation
--   default_tag    – Default tag(s) for AwesomeWM (or workspace(s) elsewhere)
--   shortcut       – Suggested keybinding mnemonic
--   map            – WM-specific identifiers (awesome / qtile / hyprland)
--   modifier       – Optional runtime config function
--   deprecated     – Marks layout as legacy
--   aliases        – Alternate lookup names
--   gaps           – Optional layout-specific gap override
--   extra          – Custom user-defined metadata
----------------------------------------------------------------------

-- TODO: provide icons.
local icons = {}

local layouts = {
    tile = {
        enabled  = true,
        position = 1,
        label    = "Tile",
        group    = "tiling",
        variant  = "default",
        icon     = icons.layout_tile,
        comment  = "Standard tiling layout with master window on the left.",
        default_tag = { "1", "2" },
        shortcut = "t",
        gaps     = 5,
        map = {
            awesome  = "tile",
            qtile    = "layout.Tile",
            hyprland = "master",
        },
    },

    floating = {
        enabled  = false,
        position = 2,
        label    = "Floating",
        group    = "floating",
        comment  = "Free window placement (no tiling).",
        icon     = icons.layout_floating,
        map = {
            awesome  = "floating",
            qtile    = "layout.Floating",
            hyprland = "floating",
        },
    },

    tile_left = {
        enabled  = true,
        position = 3,
        label    = "Tile Left",
        group    = "tiling",
        variant  = "left",
        comment  = "Master area on the left side.",
        icon     = icons.layout_tileleft,
        map = {
            awesome  = "tile.left",
            qtile    = "layout.TileLeft",
            hyprland = "master_left",
        },
    },

    tile_bottom = {
        enabled  = false,
        position = 4,
        label    = "Tile Bottom",
        group    = "tiling",
        variant  = "bottom",
        comment  = "Master area on the bottom.",
        icon     = icons.layout_tilebottom,
        map = {
            awesome  = "tile.bottom",
            qtile    = "layout.TileBottom",
            hyprland = "master_bottom",
        },
    },

    tile_top = {
        enabled  = false,
        position = 5,
        label    = "Tile Top",
        group    = "tiling",
        variant  = "top",
        comment  = "Master area on the top side.",
        icon     = icons.layout_tiletop,
        map = {
            awesome  = "tile.top",
            qtile    = "layout.TileTop",
            hyprland = "master_top",
        },
    },

    fair = {
        enabled  = true,
        position = 6,
        label    = "Fair",
        group    = "tiling",
        comment  = "Evenly distributes window sizes.",
        icon     = icons.layout_fairv,
        map = {
            awesome  = "fair",
            qtile    = "layout.Fair",
            hyprland = "fair",
        },
    },

    fair_horizontal = {
        enabled  = false,
        position = 7,
        label    = "Fair Horizontal",
        group    = "tiling",
        comment  = "Horizontal variant of fair layout.",
        icon     = icons.layout_fairh,
        map = {
            awesome  = "fair.horizontal",
            qtile    = "layout.FairHorizontal",
            hyprland = "fair_h",
        },
    },

    spiral = {
        enabled  = true,
        position = 8,
        label    = "Spiral",
        group    = "spiral",
        comment  = "Arranges windows in a spiral pattern.",
        icon     = icons.layout_spiral,
        map = {
            awesome  = "spiral",
            qtile    = "layout.Spiral",
            hyprland = "spiral",
        },
    },

    spiral_dwindle = {
        enabled  = true,
        position = 9,
        label    = "Spiral Dwindle",
        group    = "spiral",
        variant  = "dwindle",
        comment  = "Smaller windows toward the end of the spiral.",
        icon     = icons.layout_dwindle,
        map = {
            awesome  = "spiral.dwindle",
            qtile    = "layout.SpiralDwindle",
            hyprland = "dwindle",
        },
    },

    max = {
        enabled  = false,
        position = 10,
        label    = "Max",
        group    = "maximized",
        comment  = "All windows maximized, no overlap.",
        icon     = icons.layout_max,
        map = {
            awesome  = "max",
            qtile    = "layout.Max",
            hyprland = "max",
        },
    },

    max_fullscreen = {
        enabled  = false,
        position = 11,
        label    = "Fullscreen",
        group    = "maximized",
        comment  = "Single window fullscreen layout.",
        icon     = icons.layout_fullscreen,
        map = {
            awesome  = "max.fullscreen",
            qtile    = "layout.Fullscreen",
            hyprland = "fullscreen",
        },
    },

    magnifier = {
        enabled  = false,
        position = 12,
        label    = "Magnifier",
        group    = "special",
        comment  = "Focused window magnified in the center.",
        icon     = icons.layout_magnifier,
        map = {
            awesome  = "magnifier",
            qtile    = "layout.Magnifier",
            hyprland = "magnifier",
        },
    },

    corner_nw = {
        enabled  = false,
        position = 13,
        label    = "Corner NW",
        group    = "corner",
        variant  = "nw",
        comment  = "Master window in the top-left corner.",
        icon     = icons.layout_cornernw,
        map = {
            awesome  = "corner.nw",
            qtile    = "layout.CornerNW",
            hyprland = "corner_nw",
        },
    },

    corner_ne = {
        enabled  = false,
        position = 14,
        label    = "Corner NE",
        group    = "corner",
        variant  = "ne",
        comment  = "Master window in the top-right corner.",
        icon     = icons.layout_cornerne,
        map = {
            awesome  = "corner.ne",
            qtile    = "layout.CornerNE",
            hyprland = "corner_ne",
        },
    },

    corner_sw = {
        enabled  = false,
        position = 15,
        label    = "Corner SW",
        group    = "corner",
        variant  = "sw",
        comment  = "Master window in the bottom-left corner.",
        icon     = icons.layout_cornersw,
        map = {
            awesome  = "corner.sw",
            qtile    = "layout.CornerSW",
            hyprland = "corner_sw",
        },
    },

    corner_se = {
        enabled  = false,
        position = 16,
        label    = "Corner SE",
        group    = "corner",
        variant  = "se",
        comment  = "Master window in the bottom-right corner.",
        icon     = icons.layout_cornerse,
        map = {
            awesome  = "corner.se",
            qtile    = "layout.CornerSE",
            hyprland = "corner_se",
        },
    },
}

return layouts

