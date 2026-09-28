# Agent Guide: dalpaca Environment

## Overview
The user has a custom manager script called `dalpaca` for controlling `llama.cpp` instances. 

## Commands
*   **`dalpaca run <model> [-config]`**: Runs the model in **CLI mode** (foreground, interactive). Kills any existing instances first.
*   **`dalpaca server <model> [-config]`**: Runs the model in **Server mode** (daemonized background process for Web UI/API). Kills any existing instances first.
*   **`dalpaca stop`**: Kills all running `llama-cli` and `llama-server` processes.
*   **`dalpaca list`**: Shows currently running models.

## Configuration
Config files (`.txt`) are parsed by the script. They support:
*   `-m <path>`: Path to the GGUF model file.
*   `--system "<prompt>"`: Sets the system prompt (persona).
*   `--ngl <int>`: Number of layers to offload to GPU (Default: 52).
*   `--ctx-size <int>`: Context window size (Default: 32768).
*   `--temp <float>`: Temperature (Default: 0.7).
*   `--threads <int>`: CPU threads (Default: 16).
*   `--numa`: Enables NUMA awareness (Default: enabled).
*   `--flash-attn`: Enables Flash Attention (Default: enabled).

## Default Optimizations 
*   **Model:** `Qwen-3.8-27B-Q4_K_M.gguf`
*   **VRAM Split:** 52 layers on GPU, 12 on CPU (to save ~3GB for KV cache).
*   **RAM:** `--mlock` is enabled to pin the 16.8GB GGUF to RAM (crucial for USB SSD performance).
*   **Context:** 32K is the recommended sweet spot for stability and speed (~30+ t/s).

## Common Tasks
*   **To run the CLI:** Use `dalpaca run {MyModel}`.
*   **To chat via Web UI:** Use `dalpaca server {MyModel}` and visit `http://localhost:11434`.
*   **To switch models:** Create a new `.txt` config file with the `-m` flag pointing to the new GGUF.
