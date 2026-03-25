# add all the cross-platform functions here as aliases

aliases["tari"] = str(Paths.SHELL_COMMON_SCRIPTS_DIR / 'tari.sh')
aliases["tarx"] = "tar -zxvf"
aliases["pushb"] = ["lua", str(Paths.SHELL_COMMON_SCRIPTS_DIR / 'pushb.lua')]
aliases["backup"] = str(Paths.SHELL_COMMON_SCRIPTS_DIR / 'backup.sh')
aliases["share"] = str(Paths.SCRIPTS_DIR / 'share.sh --ntfy -p')
aliases["sharesec"] = str(Paths.SCRIPTS_DIR / 'share.sh --ntfy --secret -p')
aliases["sharemega"] = str(Paths.SCRIPTS_DIR / 'share.sh -m --ntfy --secret -p')
aliases["passgen"] = str(Paths.SHELL_COMMON_SCRIPTS_DIR / 'passgen_wrapper.sh')
aliases["getpath"] = "find -type f | fzf | sed 's/^..//' | tr -d '\\n' | xclip -selection c"

aliases.update({
    "rebootToMac": "sudo sh -c 'echo 1 | asahi-bless; reboot'",
    "toreset": str(Paths.SCRIPTS_DIR / 'tor_relay_reset.sh'), #f"{os.environ['HOME']}/scripts/tor_relay_reset.sh",
    "toripify": "torsocks wget -qO - https://api.ipify.org; echo",
})

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

