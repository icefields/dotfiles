
if not XSH.env.get("XONSH_INTERACTIVE", False):
    # aliases specific to non interactive shell
    pass
else:
    aliases["ollama"] = ['podman', 'exec', '-it', 'ollama', 'ollama']
    aliases["ollamac"] = ['podman', 'exec', '-it', 'ollama-cloud', 'ollama']
    aliases["ollamacloud-start"] = ['systemctl', '--user', 'start', 'ollama-cloud.service']
    aliases["ollamacloud-stop"] = ['systemctl', '--user', 'stop', 'ollama-cloud.service']
    aliases["hermes"] = ['podman', 'exec', '-it', 'hermes', 'hermes']
    aliases["hermesc"] = ['podman', 'exec', '-it', 'hermes-cloud', 'hermes']
    aliases["hermes-logs"] = str(Paths.HOME / 'scripts/ai/hermes-logs.sh')

