# add all the cross-platform functions here as aliases
scriptsLocation = "~/scripts/shell_common/"
aliases["tari"] = [scriptsLocation + "tari.sh"]
aliases["tarx"] = ["tar -zxvf"]
aliases["pushb"] = ["lua", scriptsLocation + "pushb.lua"]
aliases["backup"] = [scriptsLocation + "backup.sh"]
aliases["share"] = ["~/scripts/" + "share.sh"]
aliases["passgen"] = [scriptsLocation + "passgen_wrapper.sh"]
aliases["getpath"] = ["find -type f | fzf | sed 's/^..//' | tr -d '\\n' | xclip -selection c"]

