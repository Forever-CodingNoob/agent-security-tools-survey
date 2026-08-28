# Installation Guide

This guide sets up the two roles described in [`requirements.{md|html}`](requirements.html), i.e., (1) an Ollama server that hosts the models and (2) a client that holds this artifact and runs the benchmark tools.

## Table of Contents
+ [1. Clone the artifact](#1-clone-the-artifact)
+ [2. Install Ollama on the server](#2-install-ollama-on-the-server)
    + [On any GPU server](#on-any-gpu-server)
    + [On the UCI OpenGPU cluster](#on-the-uci-opengpu-cluster)
+ [3. Start the Ollama server](#3-start-the-ollama-server)
    + [On any GPU server](#on-any-gpu-server-1)
    + [On the UCI OpenGPU cluster as a Slurm job](#on-the-uci-opengpu-cluster-as-a-slurm-job)
+ [4. Pull and preload the models](#4-pull-and-preload-the-models)
+ [5. Verify the server from the client](#5-verify-the-server-from-the-client)
+ [6. Set up a tool to evaluate](#6-set-up-a-tool-to-evaluate)
+ [7. Shut down the server](#7-shut-down-the-server)
+ [References](#references)

## 1. Clone the artifact

On the client, clone this repository together with the three tool repositories, which are git submodules under `agentdojo/agentdojo/`, `agentharm/agentharm/`, and `asb/asb/`:
```sh
git clone --recurse-submodules <url_of_this_artifact>
cd codesafe
```
If you already cloned without submodules, fetch them afterwards:
```sh
git submodule update --init --recursive
```
The submodules are pinned to the commits we evaluated, so do not update them to newer upstream commits before reproducing our results.

## 2. Install Ollama on the server

### On any GPU server

1. Install Ollama 0.23.1 on the machine that will host the models. Either extract the released tarball into your home directory (no root needed) or run the official installation script (system-wide, root needed):
   ```sh
   # Option A: install into $HOME/ollama without root
   curl -LO https://github.com/ollama/ollama/releases/download/v0.23.1/ollama-linux-amd64.tgz
   mkdir -p ~/ollama
   tar -xzf ollama-linux-amd64.tgz -C ~/ollama
   echo 'export PATH=$HOME/ollama/bin:$PATH' >> ~/.bashrc
   source ~/.bashrc

   # Option B: install for the whole system with root
   curl -fsSL https://ollama.com/install.sh | OLLAMA_VERSION=0.23.1 sh
   ```
2. Check the version:
   ```sh
   ollama -v
   # ollama version is 0.23.1
   ```

### On the UCI OpenGPU cluster

Ollama 0.23.1 is already installed on the cluster nodes, so there is nothing to install. Make sure Slurm is in your ICS shell environment:
```sh
module load slurm
```

## 3. Start the Ollama server

Both paths use [`scripts/ollama.sbatch`](../scripts/ollama.sbatch), which sets the environment variables Ollama reads and then runs `ollama serve`. Every variable and every `#SBATCH` flag in that file has a comment that explains it. Adjust the following before starting:
+ `OLLAMA_HOST`: the address and port the server listens on. `0.0.0.0:<port>` makes the server reachable from every machine that can reach the host, which is what the client needs. If you prefer not to expose the port, set `127.0.0.1:<port>` and reach the server through an SSH tunnel from the client, for example `ssh -L 48763:127.0.0.1:48763 <user>@<server>`.
+ `OLLAMA_MODELS`: the directory for model files. It needs 87 GiB for the three models, so point it at a volume without a small quota.
+ `OLLAMA_CONTEXT_LENGTH`: the default context window. We used 65536. A larger window needs more GPU memory per loaded model.
+ `OLLAMA_NUM_PARALLEL=1` and `OLLAMA_KEEP_ALIVE=-1`: keep these as they are. They make the server process one request at a time and keep every model loaded, which the evaluation scripts and the timing numbers in the tool READMEs assume.

### On any GPU server

Run the body of the script directly, in a `tmux` or `screen` session so that the server survives a closed terminal:
```sh
# On the server, from the root of the artifact
bash scripts/ollama.sbatch
```
The `#SBATCH` lines are shell comments outside Slurm, so the script runs as a plain bash script. The server prints its host name and then stays in the foreground.

### On the UCI OpenGPU cluster as a Slurm job

1. Adjust the `#SBATCH` flags in the script as needed, in particular `--time` (the job's lifetime, 7 days by default), `--mem`, `--gres` (number of GPUs), and `-w` (the node).
2. Submit the job from any node of the [OpenLab cluster](https://wiki.ics.uci.edu/doku.php/instructional_support:openlab):
   ```sh
   sbatch scripts/ollama.sbatch
   ```
3. Find the job state and the node it runs on:
   ```sh
   squeue -u $USER
   # JOBID    PARTITION  NAME    USER    ST  TIME          NODES  NODELIST(REASON)
   # <job_id> opengpu.p  ollama  <user>  R   <elapsed_time> 1     korn
   ```
   The job's standard output and error go to `ollama-<job_id>.log` in the directory where you ran `sbatch`.

> [!IMPORTANT]
> With `OLLAMA_HOST=0.0.0.0:<port>`, the server accepts requests from every device that can reach the node. If that is a concern, listen on `127.0.0.1:<port>` and use an SSH tunnel as described above.

## 4. Pull and preload the models

The evaluation uses three models: `qwen3:14b`, `qwen3-coder:30b`, and `gpt-oss:120b`. Pull them through the HTTP API from any machine that can reach the server. In the commands below, `<ollama_host>:<ollama_port>` is the address from `OLLAMA_HOST`, for example `korn.ics.uci.edu:48763` in our setup.

1. Pull the models one by one. The download is 87 GiB in total, so this takes a while:
   ```sh
   for model in 'qwen3:14b' 'qwen3-coder:30b' 'gpt-oss:120b'
   do
      curl -s http://<ollama_host>:<ollama_port>/api/pull -d "{\"model\": \"${model}\"}"
   done
   ```
2. Verify that all three models are present:
   ```sh
   curl -s http://<ollama_host>:<ollama_port>/api/tags | python3 -m json.tool
   ```
3. Load the models into GPU memory in advance, so the first benchmark request does not pay the load time. A generate request with an empty prompt loads the model and returns:
   ```sh
   for model in 'qwen3:14b' 'qwen3-coder:30b' 'gpt-oss:120b'
   do
      curl -s http://<ollama_host>:<ollama_port>/api/generate -d "{\"model\": \"${model}\"}"
   done
   ```
   With `OLLAMA_KEEP_ALIVE=-1` the models stay loaded until the server stops.

## 5. Verify the server from the client

1. Check the version and the loaded models from the client:
   ```sh
   curl -s http://<ollama_host>:<ollama_port>/api/version
   curl -s http://<ollama_host>:<ollama_port>/api/ps | python3 -m json.tool
   ```
2. In the `/api/ps` output, compare `size_vram` with `size` for each model. They must be equal. If `size_vram` is smaller, part of the model runs on the CPU and inference is far slower. Reduce `OLLAMA_CONTEXT_LENGTH` or add GPU memory, then restart the server.
3. Send one chat request to confirm that generation works end to end:
   ```sh
   curl -s http://<ollama_host>:<ollama_port>/api/chat -d '{"model": "qwen3:14b", "messages": [{"role": "user", "content": "Say hello."}], "stream": false}'
   ```

## 6. Set up a tool to evaluate

Each tool has its own virtual environment, its own way of pointing at the Ollama server, and its own source patches. Follow the "Installation" section of the tool's README:
+ [`agentdojo/README.md`](../agentdojo/README.md): `venv` and `pip`, server address in `OPENAI_COMPATIBLE_BASE_URL`, three patches.
+ [`agentharm/README.md`](../agentharm/README.md): `uv`, server address in `OLLAMA_BASE_URL`, one extra package.
+ [`asb/README.md`](../asb/README.md): `venv` and `pip`, server address in `OLLAMA_HOST` and `JUDGE_BASE_URL`, six patches.

The tool READMEs use the placeholder `<url_to_your_ollama_server>` where the server address goes. Replace it with `http://<ollama_host>:<ollama_port>`. The evaluation scripts in each tool directory read the same environment variables and fall back to our server address when they are unset, so set the variables before running a script against your own server.

## 7. Shut down the server

+ On a plain GPU server, stop the `ollama serve` process with `Ctrl+C` in its terminal, or `pkill ollama`.
+ On the cluster, cancel the Slurm job by ID or by name:
  ```sh
  scancel <job_id>
  scancel -u $USER -n ollama
  ```
  The job also ends by itself when its `--time` limit expires.

## References
+ Ollama releases: [github.com/ollama/ollama/releases](https://github.com/ollama/ollama/releases)
+ Ollama API reference: [docs.ollama.com/api](https://docs.ollama.com/api)
+ Slurm at UCI ICS: [Slurm@ICS [Support Wiki]](https://wiki.ics.uci.edu/doku.php/services:slurm)
+ UCI OpenGPU cluster: [wiki.ics.uci.edu/doku.php/hardware:cluster:opengpu](https://wiki.ics.uci.edu/doku.php/hardware:cluster:opengpu)
