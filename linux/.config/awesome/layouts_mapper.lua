----------------------------------------------------------------------
--  Universal Layout Mapper
--
-- Dynamically maps layout_defs to the active window manager.
----------------------------------------------------------------------

local layoutsCore = require("layouts")
local layoutDefs = layoutsCore.layouts

----------------------------------------------------------------------
-- Detect current WM
-- You could also hardcode this or pass it via env var, e.g. WM=awesome
----------------------------------------------------------------------
local function detectWm()
    if awesome then return "awesome" end
    if os.getenv("HYPRLAND_INSTANCE_SIGNATURE") then return "hyprland" end
    if os.getenv("QTILE") then return "qtile" end
    return "generic"
end

local currentWm = detectWm()
----------------------------------------------------------------------
-- Mapper functions for each WM
----------------------------------------------------------------------

local mappers = {}

--  AwesomeWM mapper
--  returns an array with the awesome layout and the layout object.
mappers.awesome = function(layout_defs, args)
    local awful = args.awful

    local function resolve_layout(path)
        local node = awful.layout.suit
        for part in path:gmatch("[^%.]+") do
            node = node[part]
            if not node then
                error("Invalid layout: " .. path)
            end
        end
        return node
    end

    local layouts = {}
    local ordered = {}

    -- Collect and sort by position
    for name, def in pairs(layout_defs) do
        if def.enabled then
            table.insert(ordered, { name = name, position = def.position or math.huge })
        end
    end
    table.sort(ordered, function(a, b) return a.position < b.position end)

    -- Build awful.layout.layouts
    for _, entry in ipairs(ordered) do
        local map_path = layout_defs[entry.name].map.awesome
        if map_path then
            local layoutEntry = { awesomeLayout = resolve_layout(map_path), layout = entry }
            table.insert(layouts, layoutEntry)
            --table.insert(layouts, resolve_layout(map_path))
        end
    end

    return layouts
end

--  Hyprland mapper (example — returns layout names as strings)
mappers.hyprland = function(layout_defs, args)
    local layouts = {}
    for name, def in pairs(layout_defs) do
        if def.enabled and def.map.hyprland then
            table.insert(layouts, def.map.hyprland)
        end
    end
    table.sort(layouts)
    return layouts
end

--  Qtile mapper (example)
mappers.qtile = function(layout_defs, args)
    local layouts = {}
    for name, def in pairs(layout_defs) do
        if def.enabled and def.map.qtile then
            table.insert(layouts, def.map.qtile)
        end
    end
    return layouts
end

----------------------------------------------------------------------
-- Main universal loader
----------------------------------------------------------------------
-- args contains variables passed from the config of the wm
local function loadLayouts(args)
    local mapper = mappers[currentWm]
    if not mapper then
        error("No mapper found for window manager: " .. tostring(currentWm))
    end
    return mapper(layoutDefs,{ awful = args.awful })
end

----------------------------------------------------------------------
-- Example: using it in AwesomeWM
----------------------------------------------------------------------
--if current_wm == "awesome" then
--    local awful = require("awful")
--    awful.layout.layouts = loadLayouts()
--end

return {
    currentWm = currentWm,
    loadLayouts = loadLayouts,
    tags = layoutsCore.tags
}

