local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local function formatDate(date)
    if date and date ~= "" then
        return date
    else
        return "nil or empty"
    end
end

-- Function to create the Todo Item window
local function getTodoItemWindow(data)
    local created = formatDate(data.created)
    local dtstamp = formatDate(data.dtstamp)
    local due = formatDate(data.due)
    local modified = formatDate(data.modified)

    local todoItemWindow = wibox({
        width  = 400,
        height = 400,
        visible = true,
        ontop = true,
        type = "normal",     -- IMPORTANT: makes it a real window
        bg = "#1e1e2e"
    })
    awful.placement.centered(todoItemWindow)
    todoItemWindow.shape = gears.shape.rounded_rect -- Rounded corners

    -- Close button
    local close_button = wibox.widget {
        text = "",
        font = "FontAwesome 16",
        widget = wibox.widget.textbox,
        align = "center",
        valign = "center",
        markup = '<span foreground="#ff0000"></span>'
    }

    close_button:buttons(gears.table.join(
        awful.button({}, 1, function()
            todoItemWindow.visible = false  -- Close the window when clicked
        end)
    ))

    -- Title widget
    local title_widget = wibox.widget {
        text = data.todo_item,
        font = "Monospace 14",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    -- Description widget
    local description_widget = wibox.widget {
        text = data.description or "",
        font = "Monospace 11",
        align = "left",
        valign = "top",
        widget = wibox.widget.textbox
    }

    -- Metadata section
    local metadata = {
        "created: " .. created,
        "dtstamp: " .. dtstamp,
        "due: " .. due,
        "modified: " .. modified,
        "completed: " .. (data.completed == "true" and "Yes" or "No"),  -- Check if completed
        "categories: " .. (data.categories ~= "" and data.categories or "N/A"),
        "priority: " .. data.priority,
        "uuid: " .. data.UID,
        "percentComplete: " .. data.percentComplete .. "%",
        "status: " .. (data.status and "Active" or "Inactive")
    }

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
            font = "Monospace 9",
            align = "left",
            valign = "top",
            widget = wibox.widget.textbox
        }
        metadata_widget:add(line_widget)
    end

    -- Create the layout for the window content
    local layout = wibox.layout.align.vertical()
    layout:set_top(title_widget)           -- Title at the top
    layout:set_middle(description_widget)  -- Description in the middle
    layout:set_bottom(metadata_widget)     -- Metadata at the bottom

    -- Create a container for the close button
    local header = wibox.widget {
        close_button,
        layout = wibox.layout.fixed.horizontal
    }

    -- Wrap everything in a vertical container with a fixed header (the close button)
    local final_layout = wibox.layout.align.vertical()
    final_layout:set_top(header)
    final_layout:set_middle(layout)

    todoItemWindow:set_widget(final_layout)
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

