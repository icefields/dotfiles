-------------------------------------------------
-- ToDo Widget for Awesome Window Manager
-- 
-- @author Antonio Tari (Icefields)
-- @copyright 2026 Antonio Tari 
-- initially forked from Pavel Makhov (https://github.com/streetturtle/awesome-wm-widgets/tree/master/todo-widget)
-------------------------------------------------

-- if not running from awesome, ie. for testing, add json.lua to the path at runtime
-- package.path = package.path .. ";../json-library/?.lua"

local todoItemHelper = require("todo-widget.todo_item_helper")
local todoItemWindow = require("todo-widget.todo_item_window")
local awful = require("awful")
local wibox = require("wibox")
local json = require("json-library.json")
local spawn = require("awful.spawn")
local gears = require("gears")
local beautiful = require("beautiful")
local gfs = require("gears.filesystem")
local naughty = require("naughty")
local lfs = require("lfs")

local HOME_DIR = os.getenv("HOME")
-- local WIDGET_DIR = debug.getinfo(1, "S").source:match("@(.*/)")
local WIDGET_DIR = HOME_DIR .. '/.config/awesome/todo-widget'
local STORAGE = HOME_DIR .. '/.cache/awesome-todo.json'

-- local GET_TODO_ITEMS = 'bash -c "cat ' .. STORAGE .. '"'

-- Nerd Font icon.
local function nfIcon(symbol, color, font)
    return string.format(
        "<span font='%s' foreground='%s'>%s</span>",
        font or beautiful.topBar_button_font,
        color or beautiful.topBar_fg,
        symbol
    )
end

local function getItems()
    local content
    local readSuccess, readErr = pcall(function()
    local f = assert(io.open(STORAGE, "r"))
    content = f:read("*a")
        f:close()
    end)

    if not readSuccess then
        naughty.notify({
            title  = "Failed to read todo items",
            text   = readErr or "Could not read file",
            preset = naughty.config.presets.critical,
        })
        content = nil
    end
    return content
end

local function writeItems(result, onDone)
    if not result then return end

    local success, err = pcall(function()
        local tmpPath = STORAGE .. ".tmp"
        local bckPath = STORAGE .. ".bck"

        -- Backup the old file if it exists
        local oldFile = io.open(STORAGE, "r")
        if oldFile then
            oldFile:close()
            os.rename(STORAGE, bckPath)  -- move original to backup
        end

        -- Write new JSON to temp file
        local file = assert(io.open(tmpPath, "w"))
        file:write(json.encode(result))
        file:close()

        -- Atomically replace the original file
        os.rename(tmpPath, STORAGE)
    end)

    if not success then
        naughty.notify({
            title  = "Failed to write todo items",
            text   = err,
            preset = naughty.config.presets.critical,
        })
        return
    end

    if onDone then
        onDone(getItems())
    end
    --if onDone then
    --    spawn.easy_async(GET_TODO_ITEMS, 
    --        function(items) onDone(items) end
    --    )
    --end
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
        self:get_children_by_id("txt")[1].markup = nfIcon(new_value)
    end,
    --set_icon = function(self, new_value)
    --    self:get_children_by_id("icon")[1].image = new_value
    --end
    setIcon = function(self, new_symbol)
        local icon_widget = self:get_children_by_id("icon")[1]
        icon_widget.markup =  nfIcon(new_symbol)
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
            markup = nfIcon("󱍷", beautiful.fg_normal, beautiful.topBar_button_font),
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
    local fetchScript = WIDGET_DIR .. "/fetchTasks.lua"
    spawn.easy_async_with_shell(
        string.format(
            "bash -c 'cd %s && exec lua5.1 %s'",
            WIDGET_DIR,
            fetchScript
        ),
        function(stdout, stderr, reason, exit_code)
            if exit_code ~= 0 then
                naughty.notify({
                    title = "Failed to fetch tasks",
                    text = stderr or "Unknown error",
                    preset = naughty.config.presets.critical,
                })
            else
                update_widget(getItems())
                naughty.notify({
                    title  = "Tasks Refreshed",
                    text   = "Nextcloud tasks have been refreshed",
                    preset = naughty.config.presets.normal,
                })
            end
        end
    )
end)
refreshButton:connect_signal("mouse::enter", function(c) c:set_bg(beautiful.bg_focus) end)
refreshButton:connect_signal("mouse::leave", function(c) c:set_bg(beautiful.topBar_bg) end)

local add_button = wibox.widget {
    {
        {   --   󰐖 󰐗   󱇬
            markup = nfIcon("󰐖", beautiful.fg_normal, beautiful.topBar_button_font ),
            align  = 'center',
            valign = 'center',
            widget = wibox.widget.textbox
        },

        --{               
        --    image = WIDGET_DIR .. '/list-add-symbolic.svg',
        --    -- resize = false means the image keeps its natural size
        --    -- it won’t stretch to fit its container.
        --    resize = false,
        --    widget = wibox.widget.imagebox
        --},

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

add_button:connect_signal("button::press", function()
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
            --spawn.easy_async(GET_TODO_ITEMS, function(stdout)
            local res = json.decode(getItems())
            -- table.insert(res.todo_items, {todo_item = input_text, status = false}) 
            table.insert(res.todo_items, todoItemHelper.newTodoItem(input_text)) 
            writeItems(res, function(items) update_widget(items) end)

                --spawn.easy_async_with_shell("echo '" .. json.encode(res) .. "' > " .. STORAGE, function()
                --    spawn.easy_async(GET_TODO_ITEMS, function(items) update_widget(items) end)
                --end)
            --end)
        end
    }
    popup:setup(rows)
end)
add_button:connect_signal("mouse::enter", function(c) c:set_bg(beautiful.bg_focus) end)
add_button:connect_signal("mouse::leave", function(c) c:set_bg(beautiful.topBar_bg) end)

local function worker(user_args)

    local args = user_args or {}

    local icon = args.icon or "󰄵" --󰱒 -- WIDGET_DIR .. '/checkbox-checked-symbolic.svg'

    todo_widget.widget:setIcon(icon)

    function update_widget(stdout)
        local result = json.decode(stdout)
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
                    markup = nfIcon("ToDo", beautiful.fg_normal, beautiful.font), -- '<span size="large" font_weight="bold" color="' .. beautiful.topBar_fg .. '">ToDo</span>',
                    align = 'center',
                    forced_width = 320, -- for horizontal alignment
                    forced_height = 40,
                    widget = wibox.widget.textbox
                },
                add_button,
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

                --spawn.easy_async_with_shell("echo '" .. json.encode(result) .. "' > " .. STORAGE, function ()
                --    todo_widget:update_counter(result.todo_items)
                --end)
            end)


            local trash_button = wibox.widget {
                {
                    {   --  
                        markup = nfIcon("", beautiful.errorColour, beautiful.topBar_button_font ),
                        align  = 'center',
                        valign = 'center',
                        widget = wibox.widget.textbox
                    },
                    --{    
                    --    image = WIDGET_DIR .. '/window-close-symbolic.svg',
                    --    resize = false,
                    --    widget = wibox.widget.imagebox
                    --},
                    margins = 5,
                    layout = wibox.container.margin
                },
                border_width = 1,
                shape = function(cr, width, height)
                    gears.shape.circle(cr, width, height, 10)
                end,
                widget = wibox.container.background
            }

            trash_button:connect_signal("button::press", function()
                table.remove(result.todo_items, i)
                writeItems(result, function(items) update_widget(items) end)
                -- -- spawn.easy_async_with_shell("printf '" .. json.encode(result) .. "' > " .. STORAGE, function ()
                --spawn.easy_async_with_shell("echo '" .. json.encode(result) .. "' | jq > " .. STORAGE, function ()
                --    spawn.easy_async(GET_TODO_ITEMS, function(items) update_widget(items) end)
                --end)
            end)

            local move_up = wibox.widget {
                markup = nfIcon("", beautiful.fg_focus, beautiful.topBar_button_font ),
                align  = 'center',
                valign = 'center',
                widget = wibox.widget.textbox
            }

            -- local move_up = wibox.widget {
            --    image = WIDGET_DIR .. '/chevron-up.svg',
            --    resize = false,
            --    widget = wibox.widget.imagebox
            -- }

            move_up:connect_signal("button::press", function()
                local temp = result.todo_items[i]
                result.todo_items[i] = result.todo_items[i-1]
                result.todo_items[i-1] = temp
                writeItems(result, function(items) update_widget(items) end)

                --spawn.easy_async_with_shell("printf '" .. json.encode(result) .. "' > " .. STORAGE, function ()
                --    spawn.easy_async(GET_TODO_ITEMS, function(items) update_widget(items) end)
                --end)
            end)

            local move_down = wibox.widget {
                markup = nfIcon("", beautiful.fg_focus, beautiful.topBar_button_font ),
                align  = 'center',
                valign = 'center',
                widget = wibox.widget.textbox
            }

            --local move_down = wibox.widget {
            --    image = WIDGET_DIR .. '/chevron-down.svg',
            --    resize = false,
            --    widget = wibox.widget.imagebox
            --}

            move_down:connect_signal("button::press", function()
                local temp = result.todo_items[i]
                result.todo_items[i] = result.todo_items[i+1]
                result.todo_items[i+1] = temp
                writeItems(result, function(items) update_widget(items) end)
                --spawn.easy_async_with_shell("printf '" .. json.encode(result) .. "' > " .. STORAGE, function ()
                --    spawn.easy_async(GET_TODO_ITEMS, function(items) update_widget(items) end)
                --end)
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
                                markup = nfIcon(todo_item.todo_item, beautiful.topBar_fg, beautiful.tooltip_font),  
                                --"<span color='" .. beautiful.topBar_fg .. "' font='" .. beautiful.tooltip_font .. "'>" .. todo_item.todo_item ..  "</span>",
                                -- text = todo_item.todo_item,
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
                                trash_button,
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
            local itemText = row:get_children_by_id('item_text_widget')[1]
            itemText:connect_signal("button::press", function()
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
    -- spawn.easy_async(GET_TODO_ITEMS, function(stdout) update_widget(stdout) end)

    return todo_widget.widget
end

-- Ensure the directory exists
local function ensureDir(path)
    local dir = path:match("(.*/)")
    if dir then
        local attr = lfs.attributes(dir)
        if not attr then
            -- Recursively create directories
            local current = ""
            for part in dir:gmatch("[^/]+") do
                current = current .. part .. "/"
                if not lfs.attributes(current) then
                    lfs.mkdir(current)
                end
            end
        end
    end
end

-- Ensure STORAGE exists and has initial content
if not gfs.file_readable(STORAGE) then
    ensureDir(STORAGE)
    local f = assert(io.open(STORAGE, "w"))
    f:write('{"todo_items":{}}')
    f:close()
end

--if not gfs.file_readable(STORAGE) then
--    spawn.easy_async(string.format([[bash -c "dirname %s | xargs mkdir -p && echo '{\"todo_items\":{}}' > %s"]],
--    STORAGE, STORAGE))
--end

return setmetatable(todo_widget, { __call = function(_, ...) return worker(...) end })
