-- LGIwindow config
-- Each tab runs a CLI command and displays its output in monospace
--
-- interval: auto-refresh in seconds. 0 = no auto-refresh (fetch once on load)

local titleFont = "FiraCode Nerd Font"
local titleFontSize = 11
return {
  title = "Luci4 Dashboard",

  tabs = {
    {
      command = 'python3 ~/scripts/shell_common/SportsFetch/sports.py mlb scores && python3 ~/scripts/shell_common/SportsFetch/sports.py  mlb scores --last 2',
      fallback = "MLB Results ERROR",
      titleFallback = "MLB Results",
      interval = 30,
      contentFont = "FiraCode Nerd Font",
      contentFontSize = 11,
      tabTitleFont = titleFont,
      tabTitleFontSize = titleFontSize,
    },
    {
      command = 'python3 ~/scripts/shell_common/SportsFetch/sports.py mlb standings',
      fallback = "MLB STANDINGS ERROR",
      titleFallback = "MLB Standings",
      interval = 0,
      contentFont = "FiraCode Nerd Font",
      contentFontSize = 11,
      tabTitleFont = "sans-serif",
      tabTitleFontSize = titleFontSize,
    },
    {
      command = 'python3 ~/scripts/shell_common/SportsFetch/sports.py nhl scores && python3 ~/scripts/shell_common/SportsFetch/sports.py nhl scores --last 2',
      fallback = "NHL RESULTS ERROR",
      titleFallback = "NHL Results",
      interval = 0,
      contentFont = "FiraCode Nerd Font",
      contentFontSize = 11,
      tabTitleFont = titleFont,
      tabTitleFontSize = titleFontSize,
    },
    {
      command = 'python3 ~/scripts/shell_common/SportsFetch/sports.py indycar standings',
      fallback = "INDY STANDINGS ERROR",
      titleFallback = "Indycar Standings",
      interval = 0,
      contentFont = "IosevkaTerm Nerd Font",
      contentFontSize = 11,
      tabTitleFont = titleFont,
      tabTitleFontSize = titleFontSize,
    },
    {
      command = "curl -s wttr.in?Tm",
      fallback = "Weather unavailable",
      titleScript = "curl -s 'wttr.in?m&format=%c+%t+%h'",
      titleFallback = "Weather",
      interval = 300,
      contentFont = "IosevkaTerm Nerd Font",
      contentFontSize = 9,
      tabTitleFont = titleFont,
      tabTitleFontSize = titleFontSize,
    },
    {
      command = "lua ~/scripts/shell_common/midori-fetch/midorifetch.lua",
      fallback = "BTC price unavailable",
      titleScript = "echo 'System'",
      titleFallback = "system",
      interval = 0,
      contentFont = "IosevkaTerm Nerd Font",
      contentFontSize = 11,
      tabTitleFont = titleFont,
      tabTitleFontSize = titleFontSize,
    },
  },
}

