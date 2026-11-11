
if not XSH.env.get("XONSH_INTERACTIVE", False):
    # aliases specific to non interactive shell
    pass
else:
    aliases["ollama"] =      ['podman', 'exec', '-it', 'ollama', 'ollama']
    aliases["ollamacloud"] = ['podman', 'exec', '-it', 'ollama-cloud', 'ollama']
    aliases["hermes"] =      ['podman', 'exec', '-it', 'hermes' 'hermes']
    aliases["hermes-logs"] = str(Paths.HOME / 'scripts/hermes-logs.sh')

