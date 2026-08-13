#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/agentdojo"
source .venv/bin/activate

export OPENAI_COMPATIBLE_BASE_URL=http://circinus-44.ics.uci.edu:48763/v1
export OPENAI_COMPATIBLE_API_KEY=ollama

MODELS=("qwen3:14b" "qwen3-coder:30b" "gpt-oss:120b")
ATTACK="important_instructions"

echo "=== AgentDojo full benchmark ==="
echo "Start: $(date)"

for model in "${MODELS[@]}"; do
    model_slug="${model//:/_}"
    logdir="./runs_${model_slug}"
    mkdir -p "$logdir"

    echo ""
    echo "===== Model: $model (logdir: $logdir) ====="

    echo "--- Phase 1: utility baseline (no attack) ---"
    echo "Start utility: $(date)"
    python -m agentdojo.scripts.benchmark \
        --model OPENAI_COMPATIBLE \
        --model-id "$model" \
        --logdir "$logdir" \
        --force-rerun \
        2>&1 | tee "${logdir}/console_utility.log"
    echo "End utility: $(date)"

    echo "--- Phase 2: $ATTACK attack ---"
    echo "Start attack: $(date)"
    python -m agentdojo.scripts.benchmark \
        --model OPENAI_COMPATIBLE \
        --model-id "$model" \
        --attack "$ATTACK" \
        --logdir "$logdir" \
        --force-rerun \
        2>&1 | tee "${logdir}/console_attack.log"
    echo "End attack: $(date)"

    echo "===== Done: $model at $(date) ====="
done

echo ""
echo "=== All done: $(date) ==="
