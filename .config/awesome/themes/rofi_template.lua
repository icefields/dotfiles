-- ~/.config/awesome/themes/rofi_template.lua
--
-- Rofi .rasi template and file writer.
-- Takes a data table, formats the template, writes to disk.

local M = {}

--- Ensure the parent directory of `path` exists.
local function ensureDir(path)
    local dir = path:match("^(.*/)")
    if dir and dir ~= "" then
        os.execute("mkdir -p '" .. dir .. "'")
    end
end

--- The .rasi template string.
local RASI_TEMPLATE = [=[
/**
 * ROFI Color theme
 * NAME: luci4.rasi
 * DESCRIPTION: Auto-generated from AwesomeWM luci4 theme.
 * GENERATED: %s
 */

* {
    background-color:            %s;
    border-color:                %s;
    text-color:                  %s;
    font:                        "%s";
    prompt-font:                 "%s";
    prompt-background:           %s;
    prompt-foreground:           %s;
    prompt-padding:              %s;
    alternate-normal-background: %s;
    alternate-normal-foreground: %s;
    selected-normal-background:  %s;
    selected-normal-foreground:  %s;
    spacing:                     %d;
}

#window {
    border:  %d;
    padding: 5;
    border-radius: %d;
}

#mainbox {
    border:  0;
    padding: 0;
}

#message {
    border:       1px dash 0px 0px;
    padding:      1px;
}

#listview {
    fixed-height: 0;
    border:       2px solid 0px 0px;
    border-color: %s;
    spacing:      2px;
    scrollbar:    true;
    padding:      2px 0px 0px;
}

#element {
    border:  0;
    padding: 3px;
    border-radius: %d;
}

#element.selected.normal {
    background-color: @selected-normal-background;
    text-color:       @selected-normal-foreground;
}

#element.alternate.normal {
    background-color: @alternate-normal-background;
    text-color:       @alternate-normal-foreground;
}

#scrollbar {
    width:        0px;
    border:       0;
    handle-width: 0px;
    padding:      0;
}

#sidebar {
    border: 2px dash 0px 0px;
}

#button.selected {
    background-color: @selected-normal-background;
    text-color:       @selected-normal-foreground;
}

#inputbar {
    spacing:    0;
    padding:    1px;
}

#case-indicator {
    spacing:    0;
}

#entry {
    padding: 4px 4px;
    expand: false;
    width: 10em;
}

#prompt {
    padding:          @prompt-padding;
    background-color: @prompt-background;
    text-color:       @prompt-foreground;
    font:             @prompt-font;
    border-radius:    %dpx;
}

element-text {
    background-color: inherit;
    text-color:       inherit;
}

element-icon {
    background-color: inherit;
}
]=]

--- Format the template with the given data table and write to disk.
-- @param data table with keys: date, backgroundColor, borderColor, textColor,
--   rofiFont, rofiPromptFont, promptBackground, promptForeground, promptPadding,
--   alternateNormalBackground, alternateNormalForeground,
--   selectedNormalBackground, selectedNormalForeground,
--   spacing, borderWidth, rectRadius, listviewBorderColor, outputPath
-- @return true on success, false on failure
function M.generate(data)
    local rasi = string.format(RASI_TEMPLATE,
        data.date,
        data.backgroundColor,
        data.borderColor,
        data.textColor,
        data.rofiFont,
        data.rofiPromptFont,
        data.promptBackground,
        data.promptForeground,
        data.promptPadding,
        data.alternateNormalBackground,
        data.alternateNormalForeground,
        data.selectedNormalBackground,
        data.selectedNormalForeground,
        data.spacing,
        data.borderWidth,
        data.rectRadius,
        data.listviewBorderColor,
        data.rectRadius,
        data.rectRadius
    )

    ensureDir(data.outputPath)

    local f, err = io.open(data.outputPath, "w")
    if not f then
        io.stderr:write("rofi_template: " .. tostring(err) .. "\n")
        return false
    end
    f:write(rasi)
    f:close()
    return true
end

return M

