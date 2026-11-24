
local function execute(awful, command, isShell)
    if type(command) == "function" then
        command()
    else
        if isShell then
            awful.spawn.with_shell(command)
        else
            awful.spawn(command)
        end
    end
end

return {
    execute = execute
}

