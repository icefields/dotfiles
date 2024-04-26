-- Luci4 script to set a random wallpaper for each screen
-- use this every restart or in chronjob that will change the background over
-- time. 

for screenNumber = 0,1 do
    os.execute("nitrogen --set-zoom-fill --random ~/.config/awesome/themes/luci4/wallpapers --head="..screenNumber.." > /dev/null 2>&1")
end

