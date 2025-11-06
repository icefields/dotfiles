-----------------------------------------------------
-- ----------------------------------------------- --
--   ▄        ▄     ▄  ▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄  ▄     ▄   --
--  ▐░▌      ▐░▌   ▐░▌▐░█▀▀▀▀▀  ▀▀█░█▀▀ ▐░▌   ▐░▌  --
--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░█   █░▌  --
--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░░░░░░░▌  --
--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌    ▀▀▀▀▀█░▌  --
--  ▐░█▄▄▄▄▄ ▐░█▄▄▄█░▌▐░█▄▄▄▄▄  ▄▄█░█▄▄       ▐░▌  --
--   ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀        ▀   --
-- ----------------------------------------------- --
-- -------- Luci4 config for Awesome WM  --------- --
-- -------- https://github.com/icefields --------- --
-----------------------------------------------------
-- awesome_wallpaper.lua
-- helper function to set wallpaper using Awesome API

-- Seed RNG once for wallpaper randomization.
math.randomseed(os.time())

-- Function to pick a random wallpaper from a directory
local function getRandomWallpaper(dir)
    local files = { }

    -- List files in the directory
    local p = io.popen('ls -1 "' .. dir .. '"')
    if p then
        for file in p:lines() do
            if file:match("%.png$") or file:match("%.jpg$") or file:match("%.jpeg$") or file:match("%.webp$") then
                table.insert(files, dir .. "/" .. file)
            end
        end
        p:close()
    end

    if #files > 0 then
        return files[math.random(#files)]
    else
        return nil
    end
end

local function setWallpaper(s, args)
    local beautiful = args.beautiful
    local gears = args.gears

    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    else
        local wallpaper = getRandomWallpaper(beautiful.wallpapersPath)
        if wallpaper and gears.filesystem.file_readable(wallpaper) then
            gears.wallpaper.maximized(wallpaper, s, true)
        else
            -- FALLBACK to nitrogen
            --local wallpaperScript = "nitrogen --set-zoom-fill --random " .. beautiful.wallpapersPath .. " --head=" .. (s.index-1) -- .. " > /dev/null 2>&1"
            --awful.spawn.with_shell(wallpaperScript)
            gears.wallpaper.set("#000000") -- fallback color
        end
    end
end

return setWallpaper

