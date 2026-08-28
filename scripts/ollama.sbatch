#!/usr/bin/env bash
#SBATCH --job-name=ollama # name shown by squeue and used for %x in --output (the default is the script file name)
#SBATCH --partition=opengpu.p # request this partition (queue) instead of the cluster default
#SBATCH -w korn # short for --nodelist: run on this specific node and wait for it if it is busy
#SBATCH --gres=gpu:4 # generic resource request in the form name:count, here 4 GPUs on the node
#SBATCH --cpus-per-task=8 # CPUs for the single task (ollama serve), since sbatch runs one task per node by default
#SBATCH --mem=32G # host RAM per node, not VRAM. The default unit is MiB, so the G suffix is required
#SBATCH --time=7-00:00:00 # run-time limit in days-hours:minutes:seconds. Slurm kills the job when it expires
#SBATCH --output=%x-%j.log # file for stdout and stderr (no --error is given). %x is the job name and %j is the job ID

export OLLAMA_HOST=0.0.0.0:48763 # bind address and port of the server (default 127.0.0.1:11434). 0.0.0.0 accepts connections from other hosts
export OLLAMA_MODELS=/scratch/$USER/ollama-models # directory for model blobs and manifests (default $HOME/.ollama/models)
mkdir -p $OLLAMA_MODELS
export OLLAMA_CONTEXT_LENGTH=65536 # default context window in tokens for every loaded model unless the request sets num_ctx
export OLLAMA_NUM_PARALLEL=1 # process one LLM request at a time, with additional requests queued
export OLLAMA_KEEP_ALIVE=-1 # same as the keep_alive param in API. "-1" keeps all model loaded in memory by default

echo "Ollama on node: $(hostname -f)"
ollama serve
