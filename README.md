# dalpaca

A lightweight, optimized manager for `llama.cpp` tailored to local creative writing workflows.

## Overview
dalpaca streamlines the process of loading, running, and managing quantized GGUF models on a dedicated AMD hardware setup. It eliminates manual flag management, handles VRAM allocation intelligently, and provides both interactive CLI and persistent server modes.

## Use Case
Designed primarily for creative writing, roleplay, and extended narrative sessions. The default configuration balances inference speed with a 32K context window, ensuring smooth generation without VRAM exhaustion.

## Commands
- `dalpaca run <model|config>`: Launches the model in foreground CLI mode. Automatically terminates any existing instances before starting.
- `dalpaca server <model|config>`: Launches the model as a background daemon (Web UI and API on localhost:11434). Automatically terminates existing instances first.
- `dalpaca stop`: Kills all active llama-cli and llama-server processes.
- `dalpaca list`: Displays currently running model instances.

## Configuration Files
Create `.txt` files to store custom profiles. The parser extracts the model path and any additional flags.
Supported directives:
- `-m <path>`: Location of the GGUF file
- `--system "<prompt>"`: Sets the initial system prompt
- `--ngl <int>`: GPU offload layer count (default: 52)
- `--ctx-size <int>`: Context window in tokens (default: 32768)
- `--temp <float>`: Generation temperature (default: 0.7)
- `--threads <int>`: CPU thread count (default: 16)
- `--numa`: Enables NUMA-aware memory routing
- `--flash-attn`: Enables Flash Attention optimization

## Installation
Place the `dalpaca`, `install.sh`, and `uninstall.sh` files in your project directory. Run:
```bash
./install.sh
```
The command will be available system-wide after installation. To revert, run `./uninstall.sh`.

## Agent Documentation
See `AGENTS.md` for a concise reference guide formatted for AI assistants.
