-- Read env vars defined in ~/.shell_env and use them in Awesome
--

local env = {}

local home = os.getenv("HOME")
local file = io.open(home .. "/.shell_env", "r")

if file then
    for line in file:lines() do
        -- skip comments and empty lines
        if not line:match("^%s*#") and line:match("%S") then
            local key, value = line:match('^%s*([%w_]+)%s*=%s*"(.*)"%s*$')
            if key and value then
                env[key] = value
            end
        end
    end
    file:close()
end

return env

