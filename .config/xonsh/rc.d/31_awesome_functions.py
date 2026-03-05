import subprocess
import time
from datetime import datetime

def log_awesome_memory(logfile = str(Paths.HOME / '.cache/memlog.txt'), interval = 60):
    """
    Log Awesome WM Lua memory and RSS memory (VmRSS) in MB with timestamps.
    Prints the same info to the console.
    
    Args:
        logfile (str): File to append logs.
        interval (int): Seconds between measurements.
    """
    # Get Awesome PID once
    pid = subprocess.check_output(["pidof", "awesome"], text=True).strip()

    while True:
        # Get Lua memory (KB) and convert to MB
        lua_raw = subprocess.check_output(
            ["awesome-client", 'return collectgarbage("count")'],
            text=True
        ).strip()
        try:
            lua_mb = float(lua_raw.split()[-1]) / 1024
        except ValueError:
            lua_mb = 0.0

        # Get VmRSS from /proc/<pid>/status and convert to MB
        try:
            with open(f"/proc/{pid}/status") as f:
                for line in f:
                    if line.startswith("VmRSS:"):
                        rss_kb = int(line.split()[1])
                        rss_mb = rss_kb / 1024
                        break
                else:
                    rss_mb = 0.0
        except FileNotFoundError:
            rss_mb = 0.0

        # Build log string
        log_line = f"{datetime.now():%F %T} Lua: {lua_mb:.2f} MB | RSS: {rss_mb:.2f} MB"

        # Print to console
        print(log_line)

        # Write to logfile
        with open(logfile, "a") as f:
            f.write(log_line + "\n")

        time.sleep(interval)

# --------------------------------------------------------------------

def force_awesome_gc(verbose = True):
    """
    Force garbage collection for Awesome WM Lua memory.

    Args:
        verbose (boolean): print memory in kb after garbage collection.
    """
    luaRaw = subprocess.check_output(["awesome-client", 'collectgarbage("collect"); return collectgarbage("count")'], text=True).strip()
    if verbose == True:
        print(luaRaw)
    return luaRaw

