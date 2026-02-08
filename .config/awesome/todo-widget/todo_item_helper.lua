-- Generate a random UUID v4
local function generateUUID()
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    return string.gsub(template, "[xy]", function(c)
        local v = math.random(0, 15)
        if c == "y" then
            v = (v & 0x3) | 0x8  -- RFC4122 variant
        end
        return string.format("%x", v)
    end)
end

-- Generate UTC timestamp in YYYYMMDDTHHMMSSZ format
local function isoTimestamp()
    return os.date("!%Y%m%dT%H%M%SZ")
end

-- Create a new todo item
local function newTodoItem(todoItemStr)
    local ts = isoTimestamp()
    return {
        categories = "",
        modified = ts,
        description = "",
        completed = "",
        todo_item = todoItemStr or "",
        priority = "0",
        UID = generateUUID(),
        created = ts,
        dtstamp = ts,
        due = "",
        percentComplete = "0",
        sequence = "0",
        status = false
    }
end

return {
    newTodoItem = newTodoItem
}

