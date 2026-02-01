-- === CONFIG ===
local config = { }
config.baseUrl = "https://your.currency.api.url"

-- random symbols to use as button icon
config.symbols = { "󰆬", "󰞺", "󰞻", "󰆭", "󰆮", "󰞼", "󰇁" }
config.cacheDir = os.getenv("HOME") .. "/.cache"
config.filePath = config.cacheDir .. "/awesome-currency.json"

return config

