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

-- Function to create the Todo Item window
local function getTodoItemWindow(data)
    local created = formatDate(data.created)
    local dtstamp = formatDate(data.dtstamp)
    local due = formatDate(data.due)
    local modified = formatDate(data.modified)

    local todoItemWindow = wibox({
        width  = 300,
        height = 300,
        visible = true,
        ontop = true,
        type = "normal",     -- IMPORTANT: makes it a real window
        bg = "#1e1e2e"
    })
    awful.placement.centered(todoItemWindow)
    -- todoItemWindow.shape = gears.shape.rounded_rect -- Rounded corners
    todoItemWindow.border_width = 0.5
    todoItemWindow.border_color = "#89b4fa"
    todoItemWindow.shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 4)
    end
    
    -- Close button
    local close_button = wibox.widget {
        text = "󰅘",
        font = beautiful.symbolFont,
        widget = wibox.widget.textbox,
        align = "center",
        valign = "center",
        markup = taskText("", beautiful.errorColour, beautiful.symbolFont) 
    }

    close_button:buttons(gears.table.join(
        awful.button({}, 1, function()
            todoItemWindow.visible = false  -- Close the window when clicked
        end)
    ))

    -- Title widget
    local title_widget = wibox.widget {
        markup = taskText(data.todo_item, beautiful.topBar_fg, beautiful.titleFont),
        font = beautiful.titleFont,
        align = "left",
        valign = "center",
        widget = wibox.widget.textbox
    }

    -- Description widget
    local taskDescription = data.description or ""
    local description_widget = wibox.widget {
        -- text = markdownToPango(taskDescription),
        markup = taskText(markdownToPango(taskDescription), beautiful.topBar_fg, beautiful.descriptionFont),
        --font = "Monospace 11",
        font = beautiful.descriptionFont,
        align = "left",
        valign = "top",
        widget = wibox.widget.textbox
    }

    -- Metadata section
    local metadataOld = {
        "due: " .. due,
        "created: " .. created,
        "modified: " .. modified,
        "dtstamp: " .. dtstamp,
        "completed: " .. (data.completed == "true" and "Yes" or "No"),
        "categories: " .. (data.categories ~= "" and data.categories or "N/A"),
        "priority: " .. data.priority,
        "uuid: " .. data.UID,
        "percentComplete: " .. data.percentComplete .. "%",
        "status: " .. (data.status and "Active" or "Inactive")
    }

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

    -- Create the layout for the window content
    local layout = wibox.layout.align.vertical()
    layout:set_top(title_widget)           -- Title at the top
    layout:set_middle(description_widget)  -- Description in the middle
    layout:set_bottom(metadata_widget)     -- Metadata at the bottom

    local header = wibox.widget {
        nil,                -- left
        nil,                -- center
        close_button,       -- right
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

local function getTodoItemWindowSimple(title, description)
    local todoItemWindow = wibox({
        width  = 400,
        height = 200,
        visible = true,
        ontop = true,
        type = "normal",     -- IMPORTANT: makes it a real window
        bg = "#1e1e2e"
    })
    awful.placement.centered(todoItemWindow)
    todoItemWindow.shape = gears.shape.rounded_rect -- Rounded corners

    -- Create the close button
    local close_button = wibox.widget {
        text = "",  -- Nerd Font "X" character
        font = "FontAwesome 16",  -- Adjust depending on your Nerd Font
        widget = wibox.widget.textbox,
        align = "center",
        valign = "center",
        markup = '<span foreground="#ff0000"></span>'  -- Optional: Red color for the close button
    }

    -- Add a click event to close the window when the button is clicked
    close_button:buttons(gears.table.join(
        awful.button({}, 1, function()
            todoItemWindow.visible = false  -- Close the window when clicked
        end)
    ))

    -- Create the title text widget
    local title_widget = wibox.widget {
        text = title,
        font = "Monospace 12",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    -- Create the description text widget (you can add this as needed)
    local description_widget = wibox.widget {
        text = description or "",  -- If no description is provided, use an empty string
        font = "Monospace 10",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    -- Create the layout for the window content
    local layout = wibox.layout.align.vertical()
    layout:set_top(title_widget)
    layout:set_middle(description_widget)  -- Place description in the middle (optional)
    
    -- Create a container for the top-right close button
    local header = wibox.widget {
        close_button,
        layout = wibox.layout.fixed.horizontal
    }

    -- Wrap everything in a vertical container with a fixed header (the close button)
    local final_layout = wibox.layout.align.vertical()
    final_layout:set_top(header)  -- Set header (close button) at the top
    final_layout:set_middle(layout)  -- Set title and description in the middle

    -- Set the final layout to the window
    todoItemWindow:set_widget(final_layout)
end

return {
    getTodoItemWindow = getTodoItemWindow
}

