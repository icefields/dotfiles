# add all the cross-platform functions here as aliases

def currency_convert(multiplier = 1, pair = "USD/CAD"):
    api_url = __xonsh__.env['CURRENCY_API']
    cmd = f'curl -s {api_url} | jq -r \'.result["{pair}"]\''
    rate_str = subprocess.check_output(cmd, shell=True, text=True).strip()
    return float(rate_str) * multiplier

def disktree(args=None):
    """Run the disktree.py script as a Python module in-process."""
    import importlib.util
    script_path = Paths.SHELL_COMMON_SCRIPTS_DIR / "disktree.py"
    spec = importlib.util.spec_from_file_location("disktree", script_path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    mod.run()

def dusize(maxDepth=1, tailSize=40, path="."):
    """Disk chaos (usage) analyzer."""
    # import subprocess # already imported
    import shlex

    du = subprocess.Popen(
        ["du", "-h", path, f"--max-depth={maxDepth}"],
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL
    )
    sort = subprocess.Popen(["sort", "-hr"], stdin=du.stdout, stdout=subprocess.PIPE)
    head = subprocess.Popen(["head", "-n", str(tailSize)], stdin=sort.stdout)
    head.communicate()
    du.communicate()

