-------------------------------------------------
-- ToDo Widget for Awesome Window Manager
-- 
-- @author Antonio Tari (Icefields)
-- @copyright 2026 Antonio Tari 
-- initially forked from Pavel Makhov (https://github.com/streetturtle/awesome-wm-widgets/tree/master/todo-widget)
-------------------------------------------------
-- CONFIG:
-- rename todo_config_example.lua to todo_config.lua and edit with your server info
-------------------------------------------------
-- if not running from awesome, ie. for testing, add json.lua to the path at runtime
-- package.path = package.path .. ";../json-library/?.lua"
-------------------------------------------------
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local config = require("todo-widget.todo_config")
local todoItemHelper = require("todo-widget.todo_item_helper")
local todoItemWindow = require("todo-widget.todo_item_window")
local refreshNextcloud = require("todo-widget.nextcloud_refresh")

-- Storage Helper
local StorageHelper = require("todo-widget.storage_helper")
local storagePath = (config.filePath ~= nil and config.filePath ~= "") 
    and config.filePath 
    or (os.getenv("HOME") .. '/.cache/awesome-todo.json')
local jsonHelper = StorageHelper.new(storagePath, '{"todo_items":{}}')
local function getItems() return jsonHelper:getItems() end
local function writeItems(result, onDone) return jsonHelper:writeItems(result, onDone) end
---- text/symbol icon string.
local icons = config.icons

-- Nerd Font icon/text with font and colour.
local function spannedText(symbol, color, font)
    return string.format(
        "<span font='%s' foreground='%s'>%s</span>",
        font or beautiful.topBar_button_font,
        color or beautiful.topBar_fg,
        symbol
    )
end

local rows  = { layout = wibox.layout.fixed.vertical }
local todo_widget = {}
local update_widget
todo_widget.widget = wibox.widget {
    {
        {
            {
                {
                    id = "icon",
                    align  = 'center',
                    valign = 'center',
                    widget = wibox.widget.textbox
                    --forced_height = 16,
                    --forced_width = 16,
                    --widget = wibox.widget.imagebox
                },
                valign = 'center',
                layout = wibox.container.place
            },
            {
                id = "txt",
                widget = wibox.widget.textbox
            },
            spacing = 4, -- space between the checkbox icon and the counter, on the top bar.
            layout = wibox.layout.fixed.horizontal,
        },
        margins = 4,
        layout = wibox.container.margin
    },
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 4)
    end,
    widget = wibox.container.background,
    set_text = function(self, new_value)
        -- self:get_children_by_id("txt")[1].text = new_value
        self:get_children_by_id("txt")[1].markup = spannedText(new_value)
    end,
    --set_icon = function(self, new_value)
    --    self:get_children_by_id("icon")[1].image = new_value
    --end
    setIcon = function(self, new_symbol)
        local icon_widget = self:get_children_by_id("icon")[1]
        icon_widget.markup =  spannedText(new_symbol)
    end
}

function todo_widget:update_counter(todos)
    local todo_count = 0
    for _,p in ipairs(todos) do
        if not p.status then
            todo_count = todo_count + 1
        end
    end

    todo_widget.widget:set_text(todo_count)
end

local popup = awful.popup{
    bg = beautiful.topBar_bg,
    ontop = true,
    visible = false,
    shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, beautiful.rect_radius or 4)
    end,
    border_width = 1,
    border_color = beautiful.tooltip_border_color,
    maximum_width = 400,
    offset = { y = 5 },
    widget = {}
}

local refreshButton = wibox.widget {
    {
        {
            markup = spannedText(icons.refresh, beautiful.fg_normal, beautiful.topBar_button_font),
            align  = 'center',
            valign = 'center',
            widget = wibox.widget.textbox
        },
        top = 6,
        bottom = 6,
        left = 6,
        right = 6,
        layout = wibox.container.margin
    },
    shape = function(cr, width, height)
        gears.shape.circle(cr, width, height, 12)
    end,
    widget = wibox.container.background
}

refreshButton:connect_signal("button::press", function()
    refreshNextcloud.refreshNextcloud(function(items) 
        update_widget(getItems())
    end)
end)
refreshButton:connect_signal("mouse::enter", function(c) c:set_bg(beautiful.bg_focus) end)
refreshButton:connect_signal("mouse::leave", function(c) c:set_bg(beautiful.topBar_bg) end)

local addButton = wibox.widget {
    {
        {
            markup = spannedText(icons.add, beautiful.fg_normal, beautiful.topBar_button_font ),
            align  = 'center',
            valign = 'center',
            widget = wibox.widget.textbox
        },
        -- Adds padding around the image to make the button larger and balanced.
        -- Without margins, the icon would sit tightly against the circular border.
        top = 6,
        bottom = 6,
        left = 6,
        right = 6,
        layout = wibox.container.margin
    },
    shape = function(cr, width, height)
        gears.shape.circle(cr, width, height, 12)
    end,
    widget = wibox.container.background
}

addButton:connect_signal("button::press", function()
    local pr = awful.widget.prompt()

    table.insert(rows, wibox.widget {
        {
            {
                pr.widget,
                spacing = 8,
                layout = wibox.layout.align.horizontal
            },
            margins = 8,
            layout = wibox.container.margin
        },
        bg = beautiful.topBar_bg,
        widget = wibox.container.background
    })
    awful.prompt.run{
        prompt = "<b>New item</b>: ",
        bg = beautiful.topBar_bg,
        bg_cursor = beautiful.topBar_fg,
        textbox = pr.widget,
        exe_callback = function(input_text)
            if not input_text or #input_text == 0 then return end
            -- local res = json.decode(getItems())
            local res = getItems()
            table.insert(res.todo_items, todoItemHelper.newTodoItem(input_text)) 
            writeItems(res, function(items) update_widget(items) end)
        end
    }
    popup:setup(rows)
end)
addButton:connect_signal("mouse::enter", function(c) c:set_bg(beautiful.bg_focus) end)
addButton:connect_signal("mouse::leave", function(c) c:set_bg(beautiful.topBar_bg) end)

local function worker(user_args)
    local args = user_args or {}
    local icon = args.icon or "󰄵" --󰱒 
    todo_widget.widget:setIcon(icon)

    function update_widget(result)
        -- local result = json.decode(stdout)
        if result == nil or result == '' then result = {} end
        todo_widget:update_counter(result.todo_items)

        for i = 0, #rows do rows[i]=nil end

        -- header, title
        local first_row = wibox.widget {
            {
                {
                    widget = wibox.widget.textbox
                },
                refreshButton,
                {
                    markup = spannedText("ToDo", beautiful.fg_normal, beautiful.font),
                    align = 'center',
                    forced_width = 320, -- for horizontal alignment
                    forced_height = 40,
                    widget = wibox.widget.textbox
                },
                addButton,
                spacing = 8,
                layout = wibox.layout.fixed.horizontal
            },
            bg = beautiful.topBar_bg,
            widget = wibox.container.background
        }

        table.insert(rows, first_row)

        for i, todo_item in ipairs(result.todo_items) do
            local checkbox = wibox.widget {
                checked       = todo_item.status,
                color         = beautiful.colour2.shade4,
                paddings      = 2,
                shape         = gears.shape.circle,
                forced_width = 20,
                forced_height = 20,
                check_color = beautiful.colour2.shade3,
                widget        = wibox.widget.checkbox
            }

            checkbox:connect_signal("button::press", function(c)
                c:set_checked(not c.checked)
                todo_item.status = not todo_item.status
                result.todo_items[i] = todo_item
                
                writeItems(result, function(items) 
                    todo_widget:update_counter(result.todo_items)
                end)
            end)

            local trash_button = wibox.widget {
                {
                    {
                        markup = spannedText(icons.trash, beautiful.errorColour, beautiful.topBar_button_font ),
                        align  = 'center',
                        valign = 'center',
                        widget = wibox.widget.textbox
                    },
                    margins = 4,
                    layout = wibox.container.margin
                },
                border_width = 1,
                shape = gears.shape.circle,
                shape_border_color = beautiful.errorColour,
                shape_border_width = 0,
                --shape = function(cr, width, height)
                --    gears.shape.circle(cr, width, height, 10)
                --end,
                widget = wibox.container.background
            }

            local trashButtonPadding = wibox.widget {
                trash_button,
                left = 10,
                right = 1,
                top = 1,
                bottom = 1,
                widget = wibox.container.margin
            }

            trash_button:connect_signal("button::press", function()
                table.remove(result.todo_items, i)
                writeItems(result, function(items) update_widget(items) end)
            end)
            trash_button:connect_signal("mouse::enter", function(c) c:set_bg(beautiful.topBar_bg) end)
            trash_button:connect_signal("mouse::leave", function(c) c:set_bg(nil) end)

            local move_up = wibox.widget {
                markup = spannedText(icons.moveUp, beautiful.fg_focus, beautiful.topBar_button_font),
                align  = 'center',
                valign = 'center',
                widget = wibox.widget.textbox
            }

            move_up:connect_signal("button::press", function()
                local temp = result.todo_items[i]
                result.todo_items[i] = result.todo_items[i-1]
                result.todo_items[i-1] = temp
                writeItems(result, function(items) update_widget(items) end)
            end)

            local move_down = wibox.widget {
                markup = spannedText(icons.moveDown, beautiful.fg_focus, beautiful.topBar_button_font ),
                align  = 'center',
                valign = 'center',
                widget = wibox.widget.textbox
            }

            move_down:connect_signal("button::press", function()
                local temp = result.todo_items[i]
                result.todo_items[i] = result.todo_items[i+1]
                result.todo_items[i+1] = temp
                writeItems(result, function(items) update_widget(items) end)
            end)

            local move_buttons = {
                layout = wibox.layout.fixed.vertical
            }

            if i == 1 and #result.todo_items > 1 then
                table.insert(move_buttons, move_down)
            elseif i == #result.todo_items and #result.todo_items > 1 then
                table.insert(move_buttons, move_up)
            elseif #result.todo_items > 1 then
                table.insert(move_buttons, move_up)
                table.insert(move_buttons, move_down)
            end

            local row = wibox.widget {
                {
                    {
                        {
                            checkbox,
                            valign = 'center',
                            layout = wibox.container.place,
                        },
                        {
                            {
                                id = "item_text_widget",
                                markup = spannedText(todo_item.todo_item, beautiful.topBar_fg, beautiful.tooltip_font),  
                                align = 'left',
                                widget = wibox.widget.textbox
                            },
                            left = 10,
                            layout = wibox.container.margin
                        },
                        {
                            {
                                move_buttons,
                                valign = 'center',
                                layout = wibox.container.place
                            },
                            {
                                trashButtonPadding,
                                valign = 'center',
                                layout = wibox.container.place
                            },
                            spacing = 8,
                            layout = wibox.layout.align.horizontal
                        },
                        spacing = 8,
                        layout = wibox.layout.align.horizontal
                    },
                    left = 8,
                    right = 8,
                    top = 2,
                    bottom = 2,
                    -- margins = 8,
                    layout = wibox.container.margin
                },
                bg = beautiful.topBar_bg,
                widget = wibox.container.background
            }

            row:connect_signal("mouse::enter", function(c) c:set_bg(beautiful.bg_focus) end)
            row:connect_signal("mouse::leave", function(c) c:set_bg(beautiful.topBar_bg) end)
            row:get_children_by_id('item_text_widget')[1]:connect_signal("button::press", function()
                todoItemWindow.getTodoItemWindow(todo_item)
            end) 
            table.insert(rows, row)
        end

        popup:setup(rows)
    end

    todo_widget.widget:buttons(
        gears.table.join(
            awful.button({}, 1, function()
                if popup.visible then
                    todo_widget.widget:set_bg('#00000000')
                    popup.visible = not popup.visible
                else
                    todo_widget.widget:set_bg(beautiful.bg_focus)
                    popup:move_next_to(mouse.current_widget_geometry)
                end
            end)
        )
    )

    update_widget(getItems())

    return todo_widget.widget
end

return setmetatable(todo_widget, { __call = function(_, ...) return worker(...) end })
