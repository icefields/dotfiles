# add all the cross-platform functions here as aliases

aliases["tari"] = str(Paths.SHELL_COMMON_SCRIPTS_DIR / 'tari.sh')
aliases["tarx"] = "tar -zxvf"
aliases["pushb"] = ["lua", str(Paths.SHELL_COMMON_SCRIPTS_DIR / 'pushb.lua')]
aliases["backup"] = str(Paths.SHELL_COMMON_SCRIPTS_DIR / 'backup.sh')
aliases["share"] = str(Paths.SCRIPTS_DIR / 'share.sh')
aliases["passgen"] = str(Paths.SHELL_COMMON_SCRIPTS_DIR / 'passgen_wrapper.sh')
aliases["getpath"] = "find -type f | fzf | sed 's/^..//' | tr -d '\\n' | xclip -selection c"

aliases.update({
    "rebootToMac": "sudo sh -c 'echo 1 | asahi-bless; reboot'",
    "toreset": str(Paths.SCRIPTS_DIR / 'tor_relay_reset.sh'), #f"{os.environ['HOME']}/scripts/tor_relay_reset.sh",
    "toripify": "torsocks wget -qO - https://api.ipify.org; echo",
})

