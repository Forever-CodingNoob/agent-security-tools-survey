#!/usr/bin/env bash
# ASB full evaluation: naive DPI attack, all 400 attacker tools, all 3 models.
# Each model runs sequentially (the FIFOScheduler serializes LLM requests).
# Estimated time: qwen3:14b ~8.5 h, qwen3-coder:30b ~5 h, gpt-oss:120b ~4 h.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/asb"
source .venv/bin/activate

export OLLAMA_HOST=http://circinus-44.ics.uci.edu:48763
export JUDGE_BASE_URL=http://circinus-44.ics.uci.edu:48763/v1
export JUDGE_API_KEY=ollama
export JUDGE_MODEL=qwen3:14b
export OPENAI_API_KEY=ollama

MODELS=("qwen3:14b" "qwen3-coder:30b" "gpt-oss:120b")

mkdir -p logs/dpi

echo "=== ASB full benchmark (naive DPI, 400 tasks per model) ==="
echo "Start: $(date)"

for model in "${MODELS[@]}"; do
    model_slug="${model//:/_}"
    model_slug="${model_slug//-/_}"
    res_file="logs/dpi/full_${model_slug}_naive.csv"

    echo ""
    echo "=== Starting full run: $model ==="
    echo "Start time: $(date)"
    START_SECS=$SECONDS

    python main_attacker.py \
      --llm_name "ollama/$model" \
      --use_backend ollama \
      --attack_type naive \
      --attacker_tools_path data/all_attack_tools.jsonl \
      --tasks_path data/agent_task.jsonl \
      --res_file "$res_file" \
      --direct_prompt_injection \
      --task_num 1 \
      --max_new_tokens 512 \
      --database /tmp/nonexistent_db

    ELAPSED=$(( SECONDS - START_SECS ))
    echo "$model elapsed: ${ELAPSED}s ($(( ELAPSED / 60 ))m $(( ELAPSED % 60 ))s)"
    echo "$model CSV rows: $(wc -l < "$res_file")"
    echo ""
done

echo "=== All full runs complete at $(date) ==="
for f in logs/dpi/full_*.csv; do
    echo "$f: $(wc -l < "$f") rows"
done
