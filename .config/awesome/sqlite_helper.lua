-- Helper for sqlite3
---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Example usage:
---------------------------------------------------------------------------
-- local DB = require("db")
--
-- local db = DB.new("mydata.db")
--
-- -- Create table
-- db:execute([[
--     CREATE TABLE IF NOT EXISTS users (
--         id INTEGER PRIMARY KEY AUTOINCREMENT,
--         name TEXT,
--         age INTEGER
--     );
-- ]])
-- 
-- Insert
-- db:insert(
--     "INSERT INTO users (name, age) VALUES (?, ?)",
--     {"Bob", 25}
-- )
--
-- -- Query
-- local users = db:query(
--     "SELECT * FROM users WHERE age > ?",
--     {20}
-- )
--
-- for _, user in ipairs(users) do
--     print(user.id, user.name, user.age)
-- end
--
-- db:close()
---------------------------------------------------------------------------
---------------------------------------------------------------------------

local gears = require("gears")
local sqlite3 = require("lsqlite3")

local configDir = gears.filesystem.get_configuration_dir()
local DB = {}
DB.__index = DB

-- Create / open database
function DB.new(dbName)
    local self = setmetatable({}, DB)
    self.db = sqlite3.open(configDir .. dbName)
    return self
end

-- Execute simple SQL (no results returned)
function DB:execute(sql)
    local result = self.db:exec(sql)
    if result ~= sqlite3.OK then
        error("SQLite error: " .. self.db:errmsg())
    end
end

-- Insert with parameters (safe against SQL injection)
function DB:insert(sql, params)
    local stmt = self.db:prepare(sql)

    for i, v in ipairs(params) do
        stmt:bind(i, v)
    end

    stmt:step()
    stmt:finalize()
end

-- Query and return results as table
function DB:query(sql, params)
    local stmt = self.db:prepare(sql)
    local results = {}

    if params then
        for i, v in ipairs(params) do
            stmt:bind(i, v)
        end
    end

    for row in stmt:nrows() do
        table.insert(results, row)
    end

    stmt:finalize()
    return results
end

-- Close DB
function DB:close()
    self.db:close()
end

return DB

