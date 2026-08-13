#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/asb"
source .venv/bin/activate
export OLLAMA_HOST=http://circinus-44.ics.uci.edu:48763
export JUDGE_BASE_URL=http://circinus-44.ics.uci.edu:48763/v1
export JUDGE_API_KEY=ollama
export JUDGE_MODEL=qwen3:14b
export OPENAI_API_KEY=ollama

# This script runs only qwen3-coder:30b and gpt-oss:120b (all 400 tasks each).
# It assumes qwen3:14b has already finished. For a single script that runs all
# 3 models, use run_full.sh instead.

# Run qwen3-coder:30b
echo "=== Starting full run: qwen3-coder:30b ==="
time python main_attacker.py \
  --llm_name ollama/qwen3-coder:30b \
  --use_backend ollama \
  --attack_type naive \
  --attacker_tools_path data/all_attack_tools.jsonl \
  --tasks_path data/agent_task.jsonl \
  --res_file logs/dpi/full_qwen3_coder_30b_naive.csv \
  --direct_prompt_injection \
  --task_num 1 \
  --max_new_tokens 512 \
  --database /tmp/nonexistent_db \
  2>&1 | tail -20
echo "qwen3-coder:30b run finished."

# Run gpt-oss:120b
echo "=== Starting full run: gpt-oss:120b ==="
time python main_attacker.py \
  --llm_name ollama/gpt-oss:120b \
  --use_backend ollama \
  --attack_type naive \
  --attacker_tools_path data/all_attack_tools.jsonl \
  --tasks_path data/agent_task.jsonl \
  --res_file logs/dpi/full_gpt_oss_120b_naive.csv \
  --direct_prompt_injection \
  --task_num 1 \
  --max_new_tokens 512 \
  --database /tmp/nonexistent_db \
  2>&1 | tail -20
echo "gpt-oss:120b run finished."

echo "=== All full runs complete ==="
for f in logs/dpi/full_*.csv; do
  echo "$f: $(wc -l < $f) rows"
done
