# Agent Guide: dalpaca Environment

## Overview
The user has a custom manager script called `dalpaca` for controlling `llama.cpp` instances.

## Version
**dalpaca v0.1.0**

## Commands

| Command | Description |
|---|---|
| `dalpaca` (no args) | Launches the **interactive wizard** (TUI) — arrow-key navigation over registered models, with a CLI / Server / Back sub-prompt. |
| `dalpaca run <model>` | Runs the model in **CLI mode** (foreground, interactive). |
| `dalpaca run ./config.txt` | Runs using a registered or file config. |
| `dalpaca server <model>` | Runs the model in **Server mode** (daemonized background for Web UI / API). |
| `dalpaca recommend <model_file>` | Prints a GPU offload & context recommendation table (reads GGUF header + VRAM). |
| `dalpaca stop` | Kills all running `llama-cli` and `llama-server` processes. |
| `dalpaca ps` | Shows currently running llama instances. |
| `dalpaca register <name> -f <config>` | Registers a config file under `~/.dalpaca/<name>.txt`. |
| `dalpaca list` | Lists all registered models. |
| `dalpaca rm <name>` | Removes a registered model. |
| `dalpaca set-llama [directory]` | Sets the llama.cpp binary directory (stored in `~/.dalpaca/llama_dir.conf`). |
| `dalpaca help` / `--help` / `-h` | Displays usage information. |

## Configuration

Config files (`.txt`) are parsed by the script. Supported flags:

| Flag | Description | Example |
|---|---|---|
| `-m <path>` | Path to the GGUF model file (required). | `-m Qwen3.8-27B-Q4_K_M.gguf` |
| `--system "<prompt>"` | Sets the system prompt (persona). Multi-word values supported. | `--system "You are a coding expert"` |
| `--ngl <int>` | Number of layers to offload to GPU. | `--ngl 52` |
| `--ctx-size <int>` | Context window size in tokens. | `--ctx-size 32768` |
| `--threads <int>` | CPU threads. | `--threads 16` |
| `--temp <float>` | Generation temperature. | `--temp 0.7` |
| `--cache-type-k <f16\|q8_0\|q4_0>` | KV cache key quantization. | `--cache-type-k q8_0` |
| `--cache-type-v <f16\|q8_0\|q4_0>` | KV cache value quantization. | `--cache-type-v q8_0` |
| `--numa` | Enables NUMA-aware memory routing. | `--numa` |
| `--flash-attn` | Enables Flash Attention. | `--flash-attn` |
| `--auto-ngl` | Dalpaca-internal: auto-calculate optimal GPU layer count. | `--auto-ngl` |
| `--auto-context` | Dalpaca-internal: auto-calculate optimal context size. | `--auto-context` |
| `--host <addr>` | Server bind address. | `--host 127.0.0.1` |
| `--port <int>` | Server port. | `--port 11434` |

### No-Defaults Rule
If the user specifies **any** llama.cpp flag (via CLI `--ngl`, `--ctx-size`, etc., or any non-`-m` line in a config file), dalpaca's built-in `DEFAULT_FLAGS` are **not** applied:
```
DEFAULT_FLAGS="--mlock --ngl 52 --ctx-size 32768 --threads 16 --numa --flash-attn --temp 0.7"
```
`--auto-ngl` and `--auto-context` are dalpaca-internal flags (consumed, not forwarded to llama.cpp) — they do **not** count as "user-specified llama.cpp flags" for this rule. Auto-injected `--ngl` / `--ctx-size` values still override via flag ordering (last-flag-wins in llama.cpp).

### Config Line Parsing
- Each non-empty, non-comment line in a config file is treated as a flag line.
- `--system` lines: the value after `--system` is parsed as the prompt (surrounding quotes stripped if present).
- All other flag lines are word-split into individual arguments (e.g., `--ngl 52` → two arguments).
- Comment lines starting with `#` and blank lines are ignored.

### Example Config File
```
-m Qwen3.8-27B-Q4_K_M.gguf
--ngl 52
--ctx-size 32768
--threads 16
--numa
--flash-attn
--temp 0.8
--top_p 0.9
--system "You are a coding expert specializing in clean code architecture"
```

## Default Optimizations
*   **Model:** `Qwen-3.8-27B-Q4_K_M.gguf`
*   **VRAM Split:** 52 layers on GPU, 12 on CPU (to save ~3GB for KV cache).
*   **RAM:** `--mlock` is enabled to pin the 16.8GB GGUF to RAM (crucial for USB SSD performance).
*   **Context:** 32K is the recommended sweet spot for stability and speed (~30+ t/s).

## Common Tasks
*   **To run the CLI:** Use `dalpaca run {MyModel}` or `dalpaca run ./config.txt`.
*   **To chat via Web UI:** Use `dalpaca server {MyModel}` and visit `http://localhost:11434`.
*   **To switch models:** Create a new `.txt` config file with the `-m` flag pointing to the new GGUF, then register it.
*   **To get recommendations:** Use `dalpaca recommend ./model.gguf` to see optimal layer/ctx/KV settings.
*   **To use the wizard:** Run `dalpaca` with no arguments — arrow-key TUI with CLI/Server/Back sub-prompt.
*   **To set the llama.cpp directory:** Use `dalpaca set-llama /path/to/build` or let `install.sh` prompt you.
