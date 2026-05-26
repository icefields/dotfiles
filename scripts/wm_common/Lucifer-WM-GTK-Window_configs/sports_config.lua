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
          fallback = "Sports ERROR",
          titleFallback = "Sport",
          contentFont = "FiraCode Nerd Font",
          contentFontSize = 11,
          tabTitleFont = titleFont,
          tabTitleFontSize = titleFontSize,
          children = { {
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
              tabTitleFont = titleFont,
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
          }},
      },
      {
          titleScript = "curl -s 'wttr.in?m&format=%c+%t+%h'",
          titleFallback = "Weather",
          contentFont = "IosevkaTerm Nerd Font",
          contentFontSize = 9,
          tabTitleFont = titleFont,
          tabTitleFontSize = titleFontSize,
          children = { {
              command = "curl -s wttr.in?0",
              fallback = "Weather unavailable",
              titleScript = "echo 'Current Summary'",
              contentFont = "FiraCode Nerd Font Mono",
              contentFontSize = 18,
              titleFallback = "Local",
              interval = 300,
          },
          {
              command = "curl -s v2.wttr.in/CN+Tower?m&lang=en",
              fallback = "Weather unavailable",
              titleScript = "echo 'Detailed'",
              titleFallback = "Detailed",
              contentFont = "IosevkaTerm Nerd Font",
              contentFontSize = 14,
              interval = 300,
          },
          {
              command = "curl -s wttr.in/CN+Tower?m&lang=en",
              fallback = "Weather unavailable",
              titleScript = "echo '3-day'",
              titleFallback = "3-day",
              interval = 300,
          },},
      },
      {
          command = "fastfetch", --"lua ~/scripts/shell_common/midori-fetch/midorifetch.lua",
          fallback = "BTC price unavailable",
          titleScript = "echo 'System'",
          titleFallback = "system",
          interval = 0,
          contentFont = "FiraCode Nerd Font Mono",
          contentFontSize = 11,
          tabTitleFont = titleFont,
          tabTitleFontSize = titleFontSize,
    },
    {
          command = "curl -s rate.sx/btc",
          fallback = "BTC price unavailable",
          titleScript = "echo '₿ BTC'",
          titleFallback = "BTC",
          interval = 300,
          contentFont = "FiraCode Nerd Font Mono",
          contentFontSize = 11,
          tabTitleFont = titleFont,
          tabTitleFontSize = titleFontSize,
    }
  },
}

