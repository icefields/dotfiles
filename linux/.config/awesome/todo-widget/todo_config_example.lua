-- === CONFIG ===
local config = { }
config.username = "nextcloud_username"
config.appPassword = "app_password"
config.baseUrl = "https://your.nextcloud.url/remote.php/dav/calendars/".. config.username

-- tasklists to pull from Nextcloud
config.tasklists = { "personal", "shopping", "work" }

-- do not edit the next 2 lines
config.cacheDir = os.getenv("HOME") .. "/.cache"
config.filePath = config.cacheDir .. "/awesome-todo.json"

return config

