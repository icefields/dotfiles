-- === CONFIG ===
local config = { }
config.baseUrl = HomeEnv.CURRENCY_API
config.symbols = { "󰆬", "󰞺", "󰞻", "󰆭", "󰆮", "󰞼", "󰇁" }
config.cacheDir = os.getenv("HOME") .. "/.cache"
config.filePath = config.cacheDir .. "/awesome-currency.json"

return config

