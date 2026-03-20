local lfs = require("lfs")

function get_icon_for_application(config_dir, appName)
    local defaultIcon = config_dir.."themes/luci4/icons/ic_speaker_colored_432px.svg"
    local directory = config_dir.."themes/icons-global/"
    local files = get_files_in_directory(directory)
    
    local icon
    local splitNameArray = split_app_name(appName)
    for _, iconName in ipairs(files) do
        if string.find(string.lower(iconName), string.lower(appName)) 
            or string.find(string.lower(appName), string.lower(iconName)) 
            then
            icon = directory..iconName..".svg"
        end
    end

    -- if icon still nil try with splitting the app name
    if(icon == nil) then
        for _, iconName in ipairs(files) do
            if (splitNameArray[1] ~= nil and string.find(iconName, splitNameArray[1])) 
                or (splitNameArray[2] ~= nil and string.find(iconName, splitNameArray[2])) 
                or (splitNameArray[3] ~= nil and string.find(iconName, splitNameArray[3])) 
                then
                icon = directory..iconName..".svg"
                break
            end
        end
    end

    if (icon == nil) then icon = defaultIcon end

    return icon
end

function get_files_in_directory(directory)
    local files = {}
    for file in lfs.dir(directory) do
        -- Skip the current (.) and parent (..) directories
        if file ~= "." and file ~= ".." then
            -- Remove the ".svg" extension if present
            local base_name = file
            if base_name:match("%.svg$") then
                base_name = base_name:sub(1, -5) -- Remove the last 4 characters (".svg")
            end
            table.insert(files, base_name)
        end
    end
    return files
end

function split_app_name(appName)
    local array = {}
    for word in string.gmatch(appName, "[^%s%-.,]+") do
        table.insert(array, string.lower(word))
    end
    return array
end

