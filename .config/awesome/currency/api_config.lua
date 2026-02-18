-- === CONFIG ===
local config = { }
config.baseUrl = HomeEnv.CURRENCY_API
config.symbols = { "󰆬", "󰞺", "󰞻", "󰆭", "󰆮", "󰞼", "󰇁" }
config.cacheDir = os.getenv("HOME") .. "/.cache"
config.filePath = config.cacheDir .. "/awesome-currency.json"
config.exclude = { "ADM/CAD", "CAD/ADM", "CAD/BTC", "CAD/ETH" }
config.defaultDecimals = 2
config.decimalsMap = {
    ["JPY/CAD"] = 4,
    ["ETH/CAD"] = 0,
    ["BTC/CAD"] = 0,
}

return config

