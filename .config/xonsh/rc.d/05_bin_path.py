if not isDistrobox():
    localBin = Paths.HOME / '.local/bin'
    if os.path.isdir(localBin) and localBin not in __xonsh__.env['PATH']:
        __xonsh__.env['PATH'].insert(0, localBin)

