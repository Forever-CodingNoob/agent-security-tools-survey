#!/usr/bin/env bash
# AgentHarm full run: both tasks (harmful + benign), all 3 models, test_public split.
# Total: 1056 samples (176 per model per task). Estimated time: ~14.5 hours sequential.
#
# Log directories use the pattern logs/full/<shortname>_<task>, for example
# logs/full/gptoss_harmful. This matches the directory names from the original
# evaluation run.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/agentharm"
source .venv/bin/activate

export OLLAMA_BASE_URL=http://circinus-44.ics.uci.edu:48763/v1
export OLLAMA_API_KEY=ollama

JUDGE_MODEL="ollama/qwen3:14b"

# Model tag -> short name used in log directory names
declare -A MODEL_SHORT
MODEL_SHORT["gpt-oss:120b"]="gptoss"
MODEL_SHORT["qwen3-coder:30b"]="coder"
MODEL_SHORT["qwen3:14b"]="qwen14"

# Eval name -> task label used in log directory names
declare -A TASK_LABEL
TASK_LABEL["agentharm"]="harmful"
TASK_LABEL["agentharm_benign"]="benign"

MODELS=("gpt-oss:120b" "qwen3-coder:30b" "qwen3:14b")
TASKS=("agentharm" "agentharm_benign")

echo "=== AgentHarm full benchmark ==="
echo "Start: $(date)"

for model in "${MODELS[@]}"; do
    short="${MODEL_SHORT[$model]}"
    for task in "${TASKS[@]}"; do
        label="${TASK_LABEL[$task]}"
        log_subdir="logs/full/${short}_${label}"

        echo ""
        echo "=== $model / $task -> $log_subdir ==="
        echo "Start: $(date)"

        uv run inspect eval "inspect_evals/$task" \
          --model "ollama/$model" \
          -T split=test_public \
          -T refusal_judge="$JUDGE_MODEL" \
          -T semantic_judge="$JUDGE_MODEL" \
          --max-connections 16 \
          --log-dir "$log_subdir"

        echo "End: $(date)"
    done
    echo "===== Done: $model at $(date) ====="
done

echo ""
echo "=== All done: $(date) ==="
echo "View results: cd $SCRIPT_DIR/agentharm && uv run inspect view"
