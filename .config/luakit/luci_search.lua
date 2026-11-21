local settings = require("settings")

local midoriUrl = os.getenv("SEARCH_AI_URL")
local default = os.getenv("SEARCH_URL")
local duckUrl = "https://duckduckgo.com/?q=%s"
local duckAiUrl = "https://duck.ai/?q=%s"

settings.window.search_engines = {
	aur = "https://aur.archlinux.org/packages?K=%s",
	midori = midoriUrl,
	m = midoriUrl,
	duck = duckUrl,
	d = duckUrl,
	ai = duckAiUrl,
	searxng = default,
	default = default,
}

settings.window.default_search_engine = "default"

