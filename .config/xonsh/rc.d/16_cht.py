import os
import importlib.util

# Point cht.sh client at self-hosted instance
# Not needed if CHTSH_URL is an env var loaded in a previous stage. 
# __xonsh__.env['CHTSH_URL'] = 'https://cheat.yourdomain.tld'

# Load completer from explicit path — no sys.path pollution
completer_path = os.path.join(Paths.HOME, '.config', 'xonsh', 'cht_completer.py')
spec = importlib.util.spec_from_file_location('cht_completer', completer_path)
cht_completer = importlib.util.module_from_spec(spec)
spec.loader.exec_module(cht_completer)

# Register and prioritize
__xonsh__.completers['chtsh'] = cht_completer.chtsh_completer
__xonsh__.completers.move_to_end('chtsh', last=False)


## Add config dir to Python path
#config_dir = os.path.join(os.path.expanduser('~'), '.config', 'xonsh')
#sys.path.insert(0, config_dir)
#
## Register native cheat.sh completer
#from cht_completer import chtsh_completer
#__xonsh__.completers['chtsh'] = chtsh_completer
#__xonsh__.completers.move_to_end('chtsh', last=False)
