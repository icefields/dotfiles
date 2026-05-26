-- ~/.config/awesome/themes/rofi_dmenu_template.lua
--
-- Rofi .rasi dmenu template and file writer.
-- Takes a data table, formats the template, writes to disk.

local M = {}

--- Ensure the parent directory of `path` exists.
local function ensureDir(path)
    local dir = path:match("^(.*/)")
    if dir and dir ~= "" then
        os.execute("mkdir -p '" .. dir .. "'")
    end
end

--- The dmenu .rasi template string.
local RASI_TEMPLATE = [=[
/**
 * ROFI Color theme (dmenu mode)
 * NAME: luci4-dmenu.rasi
 * DESCRIPTION: Auto-generated from AwesomeWM luci4 theme (dmenu layout).
 * GENERATED: %s
 */

* {
    background-color:           %s;
    border-color:               %s;
    text-color:                 %s;
    height:                     %s;
    font:                        "%s";
    prompt-font:                 "%s";
    prompt-background:           %s;
    prompt-foreground:           %s;
    prompt-padding:             %s;
    selected-normal-background:  %s;
    selected-normal-foreground:  %s;
}

#window {
    anchor: north;
    location: north;
    width: 100%%;
    padding: 0px;
    children: [ horibox ];
}

#horibox {
    orientation: horizontal;
    children: [ prompt, entry, listview ];
}

#prompt {
    padding:          @prompt-padding;
    background-color: @prompt-background;
    text-color:       @prompt-foreground;
    font:             @prompt-font;
}

#listview {
    layout: horizontal;
    lines: 100;
}

#entry {
    padding: 4px;
    expand: false;
    width: 10em;
}

#element {
    padding: 2px 8px;
}

#element selected {
    background-color: @selected-normal-background;
    text-color:       @selected-normal-foreground;
}

element-text {
    background-color: inherit;
    text-color:       inherit;
}
]=]

--- Format the dmenu template with the given data table and write to disk.
-- @param data table with keys: date, backgroundColor, borderColor, textColor,
--   dmenuHeight, rofiFont, rofiPromptFont, promptBackground, promptForeground,
--   promptPadding, selectedNormalBackground, selectedNormalForeground, dmenuOutputPath
-- @return true on success, false on failure
function M.generate(data)
    local rasi = string.format(RASI_TEMPLATE,
        data.date,
        data.backgroundColor,
        data.backgroundColor,  -- border-color matches background for seamless bar
        data.textColor,
        data.dmenuHeight,
        data.rofiFont,
        data.rofiPromptFont,
        data.promptBackground,
        data.promptForeground,
        data.promptPadding,
        data.selectedNormalBackground,
        data.selectedNormalForeground
    )

    ensureDir(data.dmenuOutputPath)

    local f, err = io.open(data.dmenuOutputPath, "w")
    if not f then
        io.stderr:write("rofi_dmenu_template: " .. tostring(err) .. "\n")
        return false
    end
    f:write(rasi)
    f:close()
    return true
end

return M

