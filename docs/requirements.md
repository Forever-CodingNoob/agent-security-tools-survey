# System Requirements

An evaluation uses two roles, which may be played by one machine or by two:
+ The *Ollama server*: a machine with GPUs that hosts the three agent models behind [Ollama](https://github.com/ollama/ollama)'s HTTP API.
+ The *client*: the machine that holds this artifact, runs the benchmark tools, and sends model requests to the server over HTTP.

The requirements below are given per role. The "Tested environment" subsections describe the machines we used.

## Table of Contents
+ [Hardware Requirements](#hardware-requirements)
    + [Ollama server](#ollama-server)
    + [Client](#client)
    + [Tested environment](#tested-environment)
+ [Software Requirements](#software-requirements)
    + [Ollama server](#ollama-server-1)
    + [Client](#client-1)
    + [Tested versions](#tested-versions)
+ [References](#references)

## Hardware Requirements

### Ollama server

#### GPU
The server's GPU memory decides which models it can host, so the table below lists the three agent models used in our evaluation. The columns are:
+ Parameters and quantization: as reported by the Ollama server (`GET /api/tags`).
+ Weights on disk: the download size, which is also the minimum memory the model needs before any context is allocated.
+ Memory when loaded: the weights plus the key-value cache for the configured context window. The cache grows with `OLLAMA_CONTEXT_LENGTH`, so the loaded size is larger than the weights.

| Model | Parameters | Quantization | Weights on disk | Memory when loaded |
|-------|------------|--------------|-----------------|--------------------|
| `qwen3:14b` | 14.8B | Q4_K_M | 8.6 GiB | 15.1 GiB (measured at a 40,960-token context) |
| `qwen3-coder:30b` | 30.5B | Q4_K_M | 17.3 GiB | more than 17.3 GiB |
| `gpt-oss:120b` | 116.8B | MXFP4 | 60.9 GiB | more than 60.9 GiB |

> [!TIP]
> If a model does not fit in GPU memory, Ollama spills part of it to system RAM and inference slows down by an order of magnitude. 
> One can check `GET /api/ps` after loading: the model spills into the system RAM iff `size_vram` < `size` in response.

#### Other server resources
+ Disk: 87 GiB for the three models, in the directory set by `OLLAMA_MODELS`. Put it on a volume without a small quota.
+ System RAM: when the models fit in GPU memory, little system RAM is needed. Our Slurm job served all three models with 32 GB allocated.
+ CPU: no special requirement. Our Slurm job allocates 8 cores.

### Client

The benchmark tools are HTTP clients, so the client machine needs no GPU.
Instaed, it needs:
+ Disk: about 7 GB for the three tool directories with their virtual environments (AgentDojo 0.8 GB, AgentHarm 0.8 GB, ASB 5.2 GB, most of it PyTorch pulled in by ASB's dependencies).
+ Network: HTTP access to the Ollama server's host and port for the whole run. A full evaluation of one tool takes between 3 and 60 hours per model (see the "Execution Time" section of each tool README), so run the scripts under `tmux`, `screen`, or `nohup`.
+ A workstation-class CPU and RAM. The runs are bound by the server's inference speed, not by the client.

### Tested environment

+ Client: [SORA-WS2](https://jgarcia.ics.uci.edu/), a workstation with a 12th Gen Intel Core i7-12700KF CPU (24 logical cores), about 31 GiB of RAM, Ubuntu 22.04.5 LTS, and Linux kernel 6.8.0-85-generic.
+ Server: [korn](https://wiki.ics.uci.edu/doku.php/hardware:cluster:opengpu) (korn.ics.uci.edu), a node of [UCI's OpenGPU cluster](https://wiki.ics.uci.edu/doku.php/hardware:cluster:opengpu), with an AMD EPYC 9124 CPU at 3 GHz (32 logical cores), 4 NVIDIA RTX 4000 Ada Generation GPUs with 20 GB of GDDR6 each (80 GB in total), and 752 GB of RAM. Ollama ran as a Slurm job allocated 4 GPUs, 8 CPU cores, 32 GB of RAM, and a 7-day time limit (see [`scripts/ollama.sbatch`](../scripts/ollama.sbatch)).

## Software Requirements

### Ollama server

+ Linux on x86_64.
+ An NVIDIA GPU supported by Ollama, with a current NVIDIA driver. Ollama ships its own CUDA runtime, so no separate CUDA toolkit is needed. See [Ollama's GPU documentation](https://docs.ollama.com/gpu) for the supported GPU list.
+ [Ollama](https://github.com/ollama/ollama/releases) 0.23.1. Other versions may work, but the tool patches and the results in this artifact were made against this one.
+ `curl`, to pull and preload models through the HTTP API.
+ Slurm, only if you start the server as a cluster job as described in [`install.{md|html}`](install.html).

### Client

+ Linux on x86_64.
+ `git` with submodule support (any version from the last several years), to clone this artifact together with the three tool repositories.
+ `curl` and `python3`, for the HTTP checks in [`install.{md|html}`](install.html).
+ A Python interpreter and environment manager per tool, since each tool has its own virtual environment:

| Tool | Python | Environment manager | Dependency file |
|------|--------|---------------------|-----------------|
| AgentDojo | 3.10 or newer (`requires-python = ">= 3.10"`) | `venv` and `pip` | `pyproject.toml` |
| AgentHarm | 3.11 or newer (`requires-python = ">=3.11"` in `inspect_evals`) | [`uv`](https://github.com/astral-sh/uv) | `pyproject.toml` and `uv.lock` |
| ASB | 3.10 or 3.11 (the upstream README creates a Python 3.11 conda environment, and our run used 3.10) | `venv` and `pip` | `requirements.txt` plus six packages it omits, listed in [`asb/README.md`](../asb/README.md) |

For more detailed info, each tool's README documents the exact install commands and the source patches that the tool needs to run against Ollama.

### Tested versions

+ Ollama: v0.23.1
+ Python: v3.10.12 for AgentDojo and ASB, v3.12.2 for AgentHarm
+ uv: v0.11.29
+ git: v2.34.1
+ Tool (evaluation targets) versions: 
    + AgentDojo: v0.1.35
    + `inspect_ai`: v0.3.247 (for AgentHarm)
    + ASB: commit `1f561dc` 


## References
+ Ollama: [github.com/ollama/ollama](https://github.com/ollama/ollama), [GPU documentation](https://docs.ollama.com/gpu), [API reference](https://docs.ollama.com/api)
+ UCI OpenGPU cluster: [wiki.ics.uci.edu/doku.php/hardware:cluster:opengpu](https://wiki.ics.uci.edu/doku.php/hardware:cluster:opengpu)
