"""Xonsh completer for cheat.sh"""

from xonsh.completers.tools import contextual_command_completer

CHTSH_URL = __xonsh__.env['CHTSH_URL'] #os.environ["CHTSH_URL"] # os.getenv("CHTSH_URL")

@contextual_command_completer
def chtsh_completer(ctx):
    """Completes cheat.sh queries using the :list endpoint"""
    if ctx.command != "cht.sh":
        return set()

    import urllib.request

    prefix = ctx.prefix if ctx.prefix else ""

    try:
        url = f"{CHTSH_URL}/:list"
        req = urllib.request.Request(url, headers={"User-Agent": "curl/cht.sh"})
        with urllib.request.urlopen(req, timeout=2) as resp:
            topics = resp.read().decode().strip().split("\n")
    except Exception:
        return set()

    if prefix:
        return {t for t in topics if t.startswith(prefix)}
    return set(topics)

