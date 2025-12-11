-- Lua script to fetch Nextcloud tasks and save to ~/.cache/awesome-todo.json

local http = require("socket.http")
local ltn12 = require("ltn12")
require("LuaXML")  -- https://github.com/hishamhm/lua-xml
local mime = require("mime")
local json = require("dkjson")
local config = require("nextcloud_config")
-- rename nextcloud_config_example to called nextcloud_config and edit with your server info

-- Fetch tasks using curl
local function fetchTasksCurl()
    local curl_cmd = string.format([[
      curl  -s -u "%s:%s"  -X REPORT \
              -H "Content-Type: application/xml" \
              -H "Depth: 1" \
              --data '<?xml version="1.0" encoding="utf-8" ?>
     <calendar-query xmlns="urn:ietf:params:xml:ns:caldav">
       <prop xmlns="DAV:">
         <getetag/>
         <calendar-data xmlns="urn:ietf:params:xml:ns:caldav"/>
       </prop>
       <filter>
         <comp-filter name="VCALENDAR">
           <comp-filter name="VTODO"/>
         </comp-filter>
       </filter>
     </calendar-query>' \
           "%s"
    ]], config.username, config.appPassword, config.baseUrl)


    local handle = io.popen(curl_cmd)
    local xml_text = handle:read("*a")
    print(xml_text)
    handle:close()
    return xml_text
end

-- Recursive function to find all <cal:calendar-data> nodes
local function find_calendar_data(node)
    local results = {}
    if type(node) == "table" then
        local tag = node:tag()
        if tag and tag:match("calendar%-data$") and node[1] then
            table.insert(results, node[1])
        end
        for _, child in ipairs(node) do
            if type(child) == "table" then
                local sub = find_calendar_data(child)
                for _, v in ipairs(sub) do
                    table.insert(results, v)
                end
            end
        end
    end
    return results
end

-- Parse single VTODO block
local function parse_vtodo(vtodo)
    local function get_field(field)
        return vtodo:match(field .. ":(.-)\r?\n") or ""
    end

    local status = get_field("STATUS")
    if status == "COMPLETED" then return nil end
    return {
        description = get_field("DESCRIPTION"),
        UID = get_field("UID"),
        created = get_field("CREATED"),
        modified = get_field("LAST%-MODIFIED"),
        dtstamp = get_field("DTSTAMP"),
        due = get_field("DUE"),
        categories = get_field("CATEGORIES"),
        sequence = get_field("SEQUENCE"),
        priority = get_field("PRIORITY"),
        percentComplete = get_field("PERCENT%-COMPLETE"),
        completed = get_field("COMPLETED"),
        todo_item =  get_field("SUMMARY"),
        status = (status == "COMPLETED") -- false if NEEDS-ACTION
    }
end

-- Parse VCALENDAR content and extract VTODOs
local function parse_vcalendar(content)
    local todos = {}
    for vtodo_block in content:gmatch("BEGIN:VTODO(.-)END:VTODO") do
        local todo = parse_vtodo(vtodo_block)
        if todo ~= nil then
            table.insert(todos, todo)
        end
    end
    return todos
end

-- Main
local function fetchTasks()
    local xml_text = fetchTasksCurl()
    local root = xml.eval(xml_text)  -- use LuaXML eval
    local calendar_data_nodes = find_calendar_data(root)

    local todo_items = {}
    for _, cal_data in ipairs(calendar_data_nodes) do
        local todos = parse_vcalendar(cal_data)
        for _, t in ipairs(todos) do
            table.insert(todo_items, t)
        end
    end

    local result = { todo_items = todo_items }

    -- Save to ~/.cache/awesome-todo.json
    --local cache_dir = os.getenv("HOME") .. "/.cache"
    os.execute("mkdir -p " .. config.cacheDir)
    --local file_path = cache_dir .. "/awesome-todo.json"
    local f = io.open(config.filePath, "w")
    if not f then
        error("Failed to open file for writing: " .. config.filePath)
    end
    f:write(json.encode(result, { indent = true }))
    f:close()

    print(#todo_items .. " tasks saved to " .. config.filePath)
end

-- uncomment to run the script directly from command line
--fetchTasks()
-- there is a script in the dir, call lua5.1 fetchTasks.lua
return {
    fetchTasks = fetchTasks
}

