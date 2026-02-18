-- === CONFIG ===
local config = { }
config.baseUrl = "https://your.currency.api.url" -- use env.CURRENCY_API for consistency and DRY code.

-- random symbols to use as button icon
config.symbols = { "󰆬", "󰞺", "󰞻", "󰆭", "󰆮", "󰞼", "󰇁" }
config.cacheDir = os.getenv("HOME") .. "/.cache"
config.filePath = config.cacheDir .. "/awesome-currency.json"

-- symbols to exclude from the widget
config.exclude = { "ADM/CAD", "CAD/ADM", "CAD/BTC", "CAD/ETH" }

-- default decimals for currency values
local defaultDecimals = 2

-- special decimals rules for certain currencies
local decimalsMap = {
    ["JPY/CAD"] = 4,
    ["ETH/CAD"] = 0,
    ["BTC/CAD"] = 0,
}

return config

