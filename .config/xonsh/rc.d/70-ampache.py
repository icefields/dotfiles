# ~/.config/xonsh/rc.d/70-ampache.py
# Interactive guard
if not XSH.env.get("XONSH_INTERACTIVE", False):
    # aliases specific to non interactive shell
    pass
else:
    import os
    _amp = os.environ.get("AMPACHE_XONSH_PATH", os.path.expanduser("~/Code/Python/ampache-data-xonsh"))
    _glue = os.path.join(_amp, "ampache.xsh")
    if not os.path.isfile(_glue):
        print("[ampache] not loaded - " + _glue + " not found")
        print("[ampache] clone the repo or fix AMPACHE_XONSH_PATH")
    else:
        exec(compile(open(_glue).read(), _glue, "exec"))

