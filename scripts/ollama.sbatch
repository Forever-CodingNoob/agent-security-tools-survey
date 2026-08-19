#!/usr/bin/env bash
#SBATCH --job-name=ollama
#SBATCH --partition=opengpu.p
#SBATCH -w korn
#SBATCH --gres=gpu:4
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=7-00:00:00
#SBATCH --output=%x-%j.log

export OLLAMA_HOST=0.0.0.0:48763
export OLLAMA_MODELS=/scratch/$USER/ollama-models
mkdir -p $OLLAMA_MODELS
export OLLAMA_CONTEXT_LENGTH=65536
export OLLAMA_NUM_PARALLEL=1 # process one LLM request at a time
export OLLAMA_KEEP_ALIVE=-1 # same as the keep_alive param in API. "-1" keeps all model loaded in memory by default

echo "Ollama on node: $(hostname -f)"
ollama serve
