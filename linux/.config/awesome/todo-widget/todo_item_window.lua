local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

function parseUtcTimestamp(ts)
    -- extract parts
    local year, month, day, hour, min, sec =
        ts:match("(%d%d%d%d)(%d%d)(%d%d)T(%d%d)(%d%d)(%d%d)Z")

    -- convert to a time table (UTC)
    local timeTable = {
        year = tonumber(year),
        month = tonumber(month),
        day = tonumber(day),
        hour = tonumber(hour),
        min = tonumber(min),
        sec = tonumber(sec),
        isdst = false
    }

    -- format as a readable string (still UTC)
    return os.date("!%b %d %Y at %H:%M UTC", os.time(timeTable))
    -- return os.date("!%Y-%m-%d %H:%M:%S UTC", os.time(timeTable))
end

local function formatDate(date)
    if date and date ~= "" then
        return parseUtcTimestamp(date)
    else
        return ""
    end
end

local function validateInsert(metadata, key, value, stringToAppend)
    stringToAppend = stringToAppend or ""
    
    if type(value) == "boolean" or type(value) == "number" then
        value = tostring(value)  -- Convert to string
    end

    if value and value ~= "" then
        table.insert(metadata, key .. ": " .. value .. stringToAppend)
    end
end

function markdownToPango(markdown)
    -- bold (both **bold** and __bold__)
    markdown = markdown:gsub("%*%*(.-)%*%*", "<b>%1</b>")
    markdown = markdown:gsub("__(.-)__", "<b>%1</b>")
    
    -- italic (both *italic* and _italic_)
    markdown = markdown:gsub("%*(.-)%*", "<i>%1</i>")
    markdown = markdown:gsub("_(.-)_", "<i>%1</i>")
    
    -- monospace (code) (`code`)
    markdown = markdown:gsub("`(.-)`", "<tt>%1</tt>")
    
    -- links [text](url)
    markdown = markdown:gsub("%[([%w%s%-]+)%]%(([%w://%.%-]+)%)", '<a href="%2">%1</a>')
    
    -- Convert list items (- item or * item) to bullet points (•)
    -- NOT WORKING
    --markdown = markdown:gsub("([%-%*])%s+(.-)\n", function(_, item)
    --    return "• " .. item .. "\n"
    --end)
    
    markdown = markdown:gsub("\\n", "\n")
    return markdown
end

local function taskText(text, color, font)
    return string.format(
        "<span font='%s' foreground='%s'>%s</span>",
        font or beautiful.topBar_button_font,
        color or beautiful.topBar_fg,
        text
    )
end

local function getMetadataWidget(data)
    local created = formatDate(data.created)
    local dtstamp = formatDate(data.dtstamp)
    local due = formatDate(data.due)
    local modified = formatDate(data.modified)

    local metadata = { }
    -- completed is the nextcloud remote state, status is the local completed state
    table.insert(metadata, "completed: " .. ((data.completed == "true" or data.status == true) == true and "Yes" or "No"))
    validateInsert(metadata, "percentComplete", data.percentComplete, "%")
    -- validateInsert(metadata, "status", data.status)
    table.insert(metadata, "------------------------")
    validateInsert(metadata, "due", due)
    validateInsert(metadata, "created", created)
    validateInsert(metadata, "modified", modified)
    validateInsert(metadata, "dtstamp", dtstamp)
    --table.insert(metadata, "------------------------")
    --table.insert(metadata, "uuid: " .. data.UID)

    -- Container for metadata section
    local metadata_widget = wibox.widget {
        layout = wibox.layout.fixed.vertical,  -- Align items vertically
        widget = wibox.container.margin,
        margins = 10  -- Add margins around the metadata container
    }

    -- Loop through the metadata and create text widgets for each
    for _, line in ipairs(metadata) do
        local line_widget = wibox.widget {
            text = line,
            font = "Monospace 9", -- beautiful.colour2.shade3
            align = "left",
            valign = "top",
            widget = wibox.widget.textbox
        }
        line_widget:set_markup(line)
        metadata_widget:add(line_widget)
    end
    
    return metadata_widget
end

local function getTitleWidget(title)
    -- Title widget
    local titleWidget = wibox.widget {
        markup = taskText(title, beautiful.topBar_fg, beautiful.titleFont),
        font = beautiful.titleFont,
        align = "left",
        valign = "center",
        widget = wibox.widget.textbox
    }
    return titleWidget
end

local function getDescriptionWidget(description)
    -- Description widget
    local taskDescription = description or ""
    local descriptionWidget = wibox.widget {
        -- text = markdownToPango(taskDescription),
        markup = taskText(markdownToPango(taskDescription), beautiful.topBar_fg, beautiful.descriptionFont),
        --font = "Monospace 11",
        font = beautiful.descriptionFont,
        align = "left",
        valign = "top",
        widget = wibox.widget.textbox
    }
    return descriptionWidget
end

-- Function to create the Todo Item window
local function getTodoItemWindow(data)
    local titleWidget = getTitleWidget(data.todo_item)
    local descriptionWidget = getDescriptionWidget(data.description)
    local metadataWidget = getMetadataWidget(data)
    
    local todoItemWindowWidth = 300
    local titlePaddingBottom = 10
    local todoItemWindowHeight = descriptionWidget:get_height_for_width(todoItemWindowWidth, screen.primary)
        + titleWidget:get_height_for_width(todoItemWindowWidth, screen.primary) 
        + titlePaddingBottom
        + 140 -- approx metadata widget height. -- + metadataWidget:get_height_for_width(todoItemWindowWidth, screen.primary) 
    local todoItemWindow = wibox({
        width  = todoItemWindowWidth,
        height = todoItemWindowHeight,
        visible = true,
        ontop = true,
        type = "normal",     -- IMPORTANT: makes it a real window
        bg = beautiful.colour2.shade7, -- "#1e1e2e"
        border_width = 1,
        border_color = beautiful.tooltip_border_color
    })
    awful.placement.centered(todoItemWindow)
    todoItemWindow.shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 4)
    end
    
    -- add padding at the bottom of the title -- wibox.container.margin(widget, left, right, top, bottom)
    local titleWidgetPadding = wibox.container.margin(titleWidget, 0, 0, 0, titlePaddingBottom)

    -- Close button
    local closeButton = wibox.widget {
        text = "󰅘",
        font = beautiful.symbolFont,
        widget = wibox.widget.textbox,
        align = "center",
        valign = "center",
        markup = taskText("", beautiful.tooltip_border_color, beautiful.symbolFont) 
    }

    closeButton:buttons(gears.table.join(
        awful.button({}, 1, function()
            todoItemWindow.visible = false  -- Close the window when clicked
        end)
    )) 
        
    -- Create the layout for the window content
    local layout = wibox.layout.align.vertical()
    layout:set_top(titleWidgetPadding)           -- Title at the top
    layout:set_middle(descriptionWidget)  -- Description in the middle
    layout:set_bottom(metadataWidget)     -- Metadata at the bottom

    local header = wibox.widget {
        nil,                -- left
        nil,                -- center
        closeButton,       -- right
        layout = wibox.layout.align.horizontal
    }

    -- Wrap everything in a vertical container with a fixed header (the close button)
    local final_layout = wibox.layout.align.vertical()
    final_layout:set_top(header)
    final_layout:set_middle(layout)
    todoItemWindow:set_widget(
        wibox.widget {
            final_layout,
            left = 8,
            bottom = 8,
            --margins = 8,
            widget  = wibox.container.margin
        }
    )
    -- todoItemWindow:set_widget(final_layout)
end

return {
    getTodoItemWindow = getTodoItemWindow
}

