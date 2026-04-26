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
    local files = {}
    local p, err = io.popen('ls -1 "' .. dir .. '" 2>/dev/null')
    if not p then
        return nil
    end

    local ok, iter = pcall(function()
        return p:lines()
    end)

    if ok then
        for file in iter do
            if file:match("%.png$") or file:match("%.jpg$") or file:match("%.jpeg$") or file:match("%.webp$") then
                table.insert(files, string.format("%s/%s", dir, file))
            end
        end
    end

    p:close()

    if #files > 0 then
        local chosen = files[math.random(#files)]
        files = nil
        return chosen
    end
    return nil
end

-- DEPRECATED
local function deprecated_getRandomWallpaper(dir)
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
            -- NOTE: gears.wallpaper is deprecated in favor of awful.wallpaper, but
            -- using gears.wallpaper.maximized() because awful.wallpaper has a known issue
            -- with maximizing wallpapers, they appear centered with borders instead of
            -- properly filling the screen. See: https://github.com/awesomeWM/awesome/issues/3547
            -- TODO: Migrate to awful.wallpaper once the maximize issue is resolved or when
            -- gears.wallpaper is removed in a future major version.
            gears.wallpaper.maximized(wallpaper, s, true)
        else
            gears.wallpaper.set("#000000") -- fallback color
        end
    end
end

local function startRotation(gears, screen, interval)
    local timer =  gears.timer {
        timeout = interval,
        autostart = true,
        call_now = false,
        callback = function()
            for s in screen do
                -- emit a signal captured by rc.lua, which will set the wallpaper:
                -- screen.connect_signal("request::wallpaper", function(s)
                --      wallpaper.setWallpaper(s, awesomeArgs)
                -- end)
                s:emit_signal("request::wallpaper")
            end
        end
    }
    return timer
end

-- Start the wallpaper rotation timer
-- @param args table - Arguments passed to setWallpaper (contains interval, isRotateWallpapers)
-- @param gears - Awesome Gears
-- Returns the timer, to allow the caller to stop it if needed
local function initWallpaper(gears, screen, args)
    local interval = args.interval or 7200
    local isRotateWallpapers = args.isRotateWallpapers ~= false
    local isAurGitVersion = args.isAurGitVersion ~= false

    -- newest AUR version awesome-git, sets the wallpaper automatically when it 
    -- starts, for the older version wallpaper must be set manually, after a 
    -- small delay, which fixes the startup sizing issue.
    if isAurGitVersion == false then
        local initialTimer = nil
        initialTimer = gears.timer {
            timeout = 0.666,  -- 666ms delay for screen geometry to settle
            autostart = true,
            single_shot = true,
            callback = function()
                for s in screen do
                    s:emit_signal("request::wallpaper")
                end
                initialTimer = nil  -- cleanup
            end
        }
    end

    local timer = nil
    if isRotateWallpapers then
        timer = startRotation(gears, screen, interval)
    end
    return timer
end

return {
    setWallpaper = setWallpaper,
    initWallpaper = initWallpaper
}

