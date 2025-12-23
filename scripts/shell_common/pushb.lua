#!/usr/bin/env lua

local function pushb()
    -- get current git branch
    local handle = io.popen("git branch --show-current")
    if not handle then
        io.stderr:write("Failed to run git\n")
        os.exit(1)
    end

    local branch = handle:read("*l")
    handle:close()

    if not branch or branch == "" then
        io.stderr:write("Could not determine current branch\n")
        os.exit(1)
        -- return 1
    end

    -- Show command
    print("git push -u origin " .. branch)

    -- Confirm
    io.write("Proceed? [y/N] ")
    local confirm = io.read()

    if confirm and confirm:lower() == "y" then
        local ok, _, code = os.execute("git push -u origin " .. branch)
        if ok then
            os.exit(0)
        else
            os.exit(code or 1)
        end
    else
        os.exit(1)
    end
end

return pushb()

