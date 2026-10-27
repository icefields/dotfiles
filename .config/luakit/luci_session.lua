local modes = require("modes")
local session = require("session")

-- :wsave <path>  — save current session to a file (like :w in vim)
-- :wload <path>  — restore session from a file (like :source in vim)
modes.add_cmds({
    { ":wsave", "Save session to file.", function (w, o)
        local file = o.arg
        if not file or file == "" then
            w:error("Usage: :wsave <file>")
            return
        end
        session.save(file)
        w:notify("Session saved to " .. file)
    end, format = "{file}" },

    { ":wload", "Load session from file.", function (w, o)
        local file = o.arg
        if not file or file == "" then
            w:error("Usage: :wload <file>")
            return
        end
        if not os.exists(file) then
            w:error("File not found: " .. file)
            return
        end
        -- Temporarily swap the session file path so restore() picks it up
        local original = session.session_file
        session.session_file = file
        session.restore(false)  -- false = don't delete the file
        session.session_file = original
        w:notify("Session loaded from " .. file)
    end, format = "{file}" },
})

