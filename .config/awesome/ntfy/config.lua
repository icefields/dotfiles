-- config file for the ntfy awesome library
local icons = require("themes.luci4.application_icons")

local topics = HomeEnv.NTFY_TOPICS
local baseUrl = HomeEnv.NTFY_URL
if baseUrl:sub(-1) ~= "/" then baseUrl = baseUrl .. "/" end
if type(topics) == "table" then topics = table.concat(topics, ",") end

local config = { }
config.baseUrl = baseUrl
config.topics = topics
config.baseUrl = baseUrl
config.url = baseUrl .. topics .. "/json"
config.connectionRetry = 5
config.fallbackTitle = "Ntfy"
config.icon = icons.ntfy
config.timeout = 0  -- 0 = never auto-expires, dismissed by hand
config.logFile = "/tmp/ntfy.log"
return config

