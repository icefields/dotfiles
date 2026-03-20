-- loop_on_stop.lua

function loop()
    mp.set_property("loop-file", "inf")
end

function stop_event(event)
    if event == "end-file" then
        loop()
    end
end

mp.register_event("end-file", function()
    loop()
end)

-- mp.observe_property("pause", "bool", function(name, value)
--    if value == false then
--        stop_event("end-file")
--    end
-- end)

