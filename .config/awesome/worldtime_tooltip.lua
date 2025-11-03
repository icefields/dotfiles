local locations = {
  { name = "Toronto", tz = "America/Toronto" },
  { name = "UTC", tz = "UTC" },
  { name = "Rome", tz = "Europe/Rome" },
  { name = "UTC+5", tz = "Etc/GMT-5" },
  { name = "Tokyo", tz = "Asia/Tokyo" },
  { name = "Adelaide", tz = "Australia/Adelaide" },
  { name = "Vancouver", tz = "America/Vancouver" },
}

local function getWorldTimes()
    -- Find the longest city name for alignment
    local longest = 0
    for _, loc in ipairs(locations) do
      if #loc.name > longest then
        longest = #loc.name
      end
    end

    local times = ""
    -- Print times
    for _, loc in ipairs(locations) do
      -- Use the 'TZ' environment variable to get local time
      local cmd = string.format("TZ=%s date '+%%H:%%M (%%b %%d)'", loc.tz)
      local handle = io.popen(cmd)
      local time = handle:read("*l")
      handle:close()

      -- build and return string for tooltip
      times = times .. (string.format("%-" .. longest .. "s %s", loc.name, time)) .. "\n"
    end
    return times
end

local function createWorldTimeTooltip(widget, awful, beautiful)
    local worldTimeTooltip = awful.tooltip {
        objects = { widget },
        mode = "outside",
        align = "top",
        margin_leftright = 8,
        margin_topbottom = 4,
        preferred_positions = { "top", "bottom" },
        text = "World Time...",
        bg = beautiful.tooltip_bg_color,
        fg = beautiful.tooltip_fg_color
    }

    widget:connect_signal("mouse::enter", function(c)
        worldTimeTooltip.text = getWorldTimes():gsub("%s+$", "")
    end)

    return worldTimeTooltip
end

return {
    createWorldTimeTooltip = createWorldTimeTooltip
}

