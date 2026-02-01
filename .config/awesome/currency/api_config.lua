-- === CONFIG ===
local config = { }
config.baseUrl = HomeEnv.CURRENCY_API --"http://192.168.50.161:36661/get?coin=CAD"
config.symbols = { "󰆬", "󰞺", "󰞻", "󰆭", "󰆮", "󰞼", "󰇁" }
config.cacheDir = os.getenv("HOME") .. "/.cache"
config.filePath = config.cacheDir .. "/awesome-currency.json"

return config

