#!/usr/bin/env bash
# ASB quick validation: 1 agent (system_admin), 1 attacker tool, 3 DPI attack types,
# 3 models. Confirms the pipeline works end to end.
# Expected time: ~2 to 5 minutes per model.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/asb"
source .venv/bin/activate

export OLLAMA_HOST="${OLLAMA_HOST:-http://korn.ics.uci.edu:48763}"
export JUDGE_BASE_URL="${JUDGE_BASE_URL:-http://korn.ics.uci.edu:48763/v1}"
export JUDGE_API_KEY="${JUDGE_API_KEY:-ollama}"
export JUDGE_MODEL="${JUDGE_MODEL:-qwen3:14b}"
export OPENAI_API_KEY="${OPENAI_API_KEY:-ollama}"

MODELS=("qwen3:14b" "qwen3-coder:30b" "gpt-oss:120b")
ATTACK_TYPES=("naive" "fake_completion" "escape_characters")

mkdir -p logs

echo "=== ASB quick validation ==="
echo "Start: $(date)"

for model in "${MODELS[@]}"; do
    model_slug="${model//:/_}"
    for attack_type in "${ATTACK_TYPES[@]}"; do
        res_file="logs/test_${model_slug}_${attack_type}.csv"

        echo ""
        echo "=== $model / $attack_type ==="
        python main_attacker.py \
          --llm_name "ollama/$model" \
          --use_backend ollama \
          --attack_type "$attack_type" \
          --attacker_tools_path data/attack_tools_test.jsonl \
          --tasks_path data/agent_task_test.jsonl \
          --res_file "$res_file" \
          --direct_prompt_injection \
          --task_num 1 \
          --max_new_tokens 512 \
          --database /tmp/nonexistent_db
    done
    echo "=== Done: $model ==="
done

echo ""
echo "=== Validation complete at $(date) ==="
