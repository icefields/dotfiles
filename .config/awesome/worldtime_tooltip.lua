local lgi = require("lgi")
local GLib = lgi.GLib

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
  local longest = 0
  for _, loc in ipairs(locations) do
    if #loc.name > longest then
      longest = #loc.name
    end
  end

  local times = ""
  -- Get current UTC time once, then convert per timezone
  local nowUtc = GLib.DateTime.new_now_utc()

  for _, loc in ipairs(locations) do
    local tz = GLib.TimeZone.new(loc.tz)
    local localTime = nowUtc:to_timezone(tz)
    -- GLib format specifiers match date's: %H:%M (%b %d)
    local time = localTime:format("%H:%M (%b %d)")
    times = times .. string.format("%-" .. longest .. "s %s", loc.name, time) .. "\n"
  end

  return times:gsub("%s+$", "")
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
        worldTimeTooltip.text = getWorldTimes()
    end)

    -- show tooltip on right click
    --widget:connect_signal("button::press", function(_, _, _, button)
    --    if button == 3 then
    --        worldTimeTooltip.text = getWorldTimes()
    --    end
    --end)

    return worldTimeTooltip
end

return {
    createWorldTimeTooltip = createWorldTimeTooltip
}

