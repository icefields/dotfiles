
local function execute(awful, cmdItem)
    if type(cmdItem.command) == "function" then
        cmdItem.command()
    else
        if cmdItem.shell then
            awful.spawn.with_shell(cmdItem.command)
        else
            awful.spawn(cmdItem.command)
        end
    end
end

return {
    execute = execute
}

