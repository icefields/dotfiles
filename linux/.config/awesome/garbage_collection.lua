-----------------------------------------------------
-- ----------------------------------------------- --
--   ▄        ▄     ▄  ▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄  ▄     ▄   --
--  ▐░▌      ▐░▌   ▐░▌▐░█▀▀▀▀▀  ▀▀█░█▀▀ ▐░▌   ▐░▌  --
--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░█   █░▌  --
--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░░░░░░░▌  --
--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌    ▀▀▀▀▀█░▌  --
--  ▐░█▄▄▄▄▄ ▐░█▄▄▄█░▌▐░█▄▄▄▄▄  ▄▄█░█▄▄       ▐░▌  --
--   ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀        ▀   --
-- ----------------------------------------------- --
-- -------- Luci4 config for Awesome WM  --------- --
-- -------- https://github.com/icefields --------- --
-----------------------------------------------------
-- garbage_collection.lua
-- Periodic garbage collection to mitigate lazy GC behavior in AwesomeWM
--
--[[
## What Does "incremental" Do?

Lua has **two GC modes**:

| Mode            | Behavior                                                                 |
|-----------------|--------------------------------------------------------------------------|
| `"full"` (default) | Stops the world, collects all garbage in one pass. Can cause CPU spikes and brief UI freezes. |
| `"incremental"` | Performs collection in small steps interleaved with normal execution. Smoother, no perceptible pause. |

When you call `collectgarbage("incremental")`, it performs a single incremental step rather than a full cycle. This is ideal for a timer — it spreads the work over time instead of dumping it all at once.

---

## What Do `setpause` and `setstepmul` Do?

These tune Lua's **automatic** garbage collector behavior:

### `collectgarbage("setpause", value)`

| Parameter | Meaning                                                                 |
|-----------|-------------------------------------------------------------------------|
| `pause`   | How long the GC waits **before starting a new cycle** after finishing the previous one. |
| Default   | 200 (in units of 1/1000 of a second, so ~0.2 seconds)                   |
| Lower value | GC starts sooner → more frequent collection                            |
| Higher value | GC waits longer → less frequent collection                             |

**Example**: `setpause = 110` means the GC will start a new cycle after ~0.11 seconds instead of ~0.2 seconds.

### `collectgarbage("setstepmul", value)`

| Parameter | Meaning                                                                 |
|-----------|-------------------------------------------------------------------------|
| `stepmul` | How aggressively the GC works **per step** relative to memory allocation speed. |
| Default   | 200 (GC works 2x as fast as allocation)                                 |
| Lower value | Slower collection, less CPU usage                                      |
| Higher value | Faster collection, more CPU usage                                      |

**Example**: `stepmul = 400` means GC works 4x as fast as allocation — more aggressive, but uses more CPU.
--]]

local garbageCollection = {}
local thirtyMinutes = 1800
local collectionModeIncremental = "incremental"
local collectionModeFull = "full"

-- Default configuration
garbageCollection.config = {
    timeout = thirtyMinutes,
    mode = collectionModeIncremental
}

-- Tuning GC parameters for more aggressive automatic collection
-- setpause: lower = more frequent GC cycles (default: 200)
-- setstepmul: higher = more aggressive per-step collection (default: 200)
garbageCollection.tuneGc = function(pause, stepmul)
    collectgarbage("setpause", pause or 110)
    collectgarbage("setstepmul", stepmul or 400)
end

-- Start the periodic GC timer
-- @param gears table - The gears module from AwesomeWM (require("gears"))
-- @param opts table - Optional configuration { timeout = number, mode = "full"|"incremental" }
-- @return timer - The timer object
garbageCollection.start = function(gears, opts)
    opts = opts or {}
    local timeout = opts.timeout or garbageCollection.config.timeout
    local mode = opts.mode or garbageCollection.config.mode

    local timer = gears.timer {
        timeout = timeout,
        autostart = true,
        callback = function()
            if mode == collectionModeIncremental then
                collectgarbage("incremental")
            else
                collectgarbage()
            end
        end
    }

    return timer
end

return garbageCollection

