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

# This script runs only qwen3-coder:30b and gpt-oss:120b (100-task subset each).
# It assumes qwen3:14b has already finished. For a single script that runs all
# 3 models on all 400 tasks, use run_full.sh instead.

# Run qwen3-coder:30b (100 tasks)
echo ""
echo "=== Starting subset run: qwen3-coder:30b (100 tasks) ==="
echo "Start time: $(date)"
START_SECS=$SECONDS
python main_attacker.py \
  --llm_name ollama/qwen3-coder:30b \
  --use_backend ollama \
  --attack_type naive \
  --attacker_tools_path data/attack_tools_subset_100.jsonl \
  --tasks_path data/agent_task.jsonl \
  --res_file logs/dpi/full_qwen3_coder_30b_naive.csv \
  --direct_prompt_injection \
  --task_num 1 \
  --max_new_tokens 512 \
  --database /tmp/nonexistent_db \
  2>&1 | grep -E "Attack|Original|Refuse|Total|success|duration|started|ended"
ELAPSED=$(( SECONDS - START_SECS ))
echo "qwen3-coder:30b elapsed: ${ELAPSED}s ($(( ELAPSED / 60 ))m $(( ELAPSED % 60 ))s)"
echo "qwen3-coder:30b CSV rows: $(wc -l < logs/dpi/full_qwen3_coder_30b_naive.csv)"

# Run gpt-oss:120b (100 tasks)
echo ""
echo "=== Starting subset run: gpt-oss:120b (100 tasks) ==="
echo "Start time: $(date)"
START_SECS=$SECONDS
python main_attacker.py \
  --llm_name ollama/gpt-oss:120b \
  --use_backend ollama \
  --attack_type naive \
  --attacker_tools_path data/attack_tools_subset_100.jsonl \
  --tasks_path data/agent_task.jsonl \
  --res_file logs/dpi/full_gpt_oss_120b_naive.csv \
  --direct_prompt_injection \
  --task_num 1 \
  --max_new_tokens 512 \
  --database /tmp/nonexistent_db \
  2>&1 | grep -E "Attack|Original|Refuse|Total|success|duration|started|ended"
ELAPSED=$(( SECONDS - START_SECS ))
echo "gpt-oss:120b elapsed: ${ELAPSED}s ($(( ELAPSED / 60 ))m $(( ELAPSED % 60 ))s)"
echo "gpt-oss:120b CSV rows: $(wc -l < logs/dpi/full_gpt_oss_120b_naive.csv)"

echo ""
echo "=== All runs complete at $(date) ==="
for f in logs/dpi/full_*.csv; do
  echo "$f: $(wc -l < $f) rows"
done
