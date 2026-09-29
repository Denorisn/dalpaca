# dalpaca

A lightweight, optimized manager for `llama.cpp` tailored to local creative writing workflows.

## Overview
dalpaca streamlines the process of loading, running, and managing quantized GGUF models on a dedicated AMD hardware setup. It eliminates manual flag management, handles VRAM allocation intelligently, and provides both interactive CLI and persistent server modes.

## Use Case
Designed primarily for creative writing, roleplay, and extended narrative sessions. The default configuration balances inference speed with a 32K context window, ensuring smooth generation without VRAM exhaustion.

## Commands

- `dalpaca` (no args): Opens the **interactive wizard** (TUI) with arrow-key navigation, registered model list, and a CLI / Server / Back sub-prompt.
- `dalpaca run <model|config>`: Launches the model in foreground CLI mode.
- `dalpaca server <model|config>`: Launches the model as a background daemon (Web UI and API on localhost:11434).
- `dalpaca recommend <model_file>`: Prints a GPU offload & context recommendation table (reads GGUF header + VRAM).
- `dalpaca stop`: Kills all active `llama-cli` and `llama-server` processes.
- `dalpaca ps`: Displays currently running model instances.
- `dalpaca register <name> -f <config>`: Registers a config file as a named model.
- `dalpaca list`: Lists all registered models.
- `dalpaca rm <name>`: Removes a registered model.
- `dalpaca set-llama [directory]`: Sets the llama.cpp binary directory.
- `dalpaca help / --help / -h`: Displays usage information.

## Configuration Files

Create `.txt` files to store custom profiles. The parser extracts the model path and any additional flags.

All llama.cpp config flags are supported. Example directives:

- `-m <path>`: Location of the GGUF file
- `--system "<prompt>"`: Sets the initial system prompt
- `--ngl <int>`: GPU offload layer count (default: 52)
- `--ctx-size <int>`: Context window in tokens (default: 32768)
- `--temp <float>`: Generation temperature (default: 0.7)
- `--threads <int>`: CPU thread count (default: 16)
- `--cache-type-k <f16\|q8_0\|q4_0>`: KV cache key quantization
- `--cache-type-v <f16\|q8_0\|q4_0>`: KV cache value quantization
- `--numa`: Enables NUMA-aware memory routing
- `--flash-attn`: Enables Flash Attention optimization
- `--auto-ngl`: Dalpaca-internal — auto-calculate GPU layer count
- `--auto-context`: Dalpaca-internal — auto-calculate context size

### No-Defaults Rule

If **any** llama.cpp flag is specified (via CLI or config file), dalpaca's built-in defaults are **not** applied:
```
--mlock --ngl 52 --ctx-size 32768 --threads 16 --numa --flash-attn --temp 0.7
```
`--auto-ngl` and `--auto-context` are dalpaca-internal flags — they do not count as user-specified llama.cpp flags. Auto-injected `--ngl` / `--ctx-size` values still take effect via flag ordering.

## Installation

First, build `llama.cpp` from source:
```bash
git clone https://github.com/ggml-org/llama.cpp
cd llama.cpp && cmake -B build && cmake --build build --config Release
```

Then, clone this repo and install:
```bash
git clone https://github.com/Denorisn/dalpaca.git
cd dalpaca
./install.sh
```

The install script **requires** you to specify the path to your `llama.cpp` build directory (must contain `llama-cli` and/or `llama-server`). The path is persisted to `~/.dalpaca/llama_dir.conf`.

The command will be available system-wide after installation. To revert, run `./uninstall.sh`.

## Agent Documentation
See `AGENTS.md` for a concise reference guide formatted for AI assistants.
