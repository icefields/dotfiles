local json = require("json-library.json")
local gfs = require("gears.filesystem")
local lfs = require("lfs")

local JsonHelper = {}
JsonHelper.__index = JsonHelper

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

function JsonHelper.new(storage, emptyJsonStr)
    local self = setmetatable({}, JsonHelper)
    self.storage = storage
    
    -- Ensure STORAGE exists and has initial content
    if not gfs.file_readable(storage) then
        ensureDir(storage)
        local f = assert(io.open(storage, "w"))
        f:write(emptyJsonStr)
        f:close()
    end

    --if not gfs.file_readable(STORAGE) then
    --    spawn.easy_async(string.format([[bash -c "dirname %s | xargs mkdir -p && echo '{\"todo_items\":{}}' > %s"]],
    --    STORAGE, STORAGE))
    --end

    return self
end

function JsonHelper:getItems()
    local content
    local readSuccess, readErr = pcall(function()
    local f = assert(io.open(self.storage, "r"))
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
    return json.decode(content)
    --return content
end

function JsonHelper:writeItems(result, onDone)
    if not result then return end
    local STORAGE = self.storage

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
        onDone(self:getItems())
    end
end




return JsonHelper

