#!/usr/bin/env bash
# ASB full evaluation: naive DPI attack, all 400 attacker tools, all 3 models.
# Each model runs sequentially (the FIFOScheduler serializes LLM requests).
# Estimated time: qwen3:14b ~8.5 h, qwen3-coder:30b ~5 h, gpt-oss:120b ~4 h.
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

echo ""
echo "=== Per-task timing summary ==="
python3 -c "
import csv, glob, os

rows = []
for f in sorted(glob.glob('logs/dpi/full_*.csv')):
    model_tag = os.path.basename(f).replace('full_', '').replace('_naive.csv', '')
    with open(f, newline='') as fh:
        reader = csv.DictReader(fh)
        if 'Duration' not in (reader.fieldnames or []):
            print(f'{f}: Duration column absent (run predates the timing patch)')
            continue
        for row in reader:
            rows.append({
                'model': model_tag,
                'agent': row.get('Agent Name', ''),
                'attack_tool': row.get('Attack Tool', ''),
                'attack_ok': row.get('Attack Successful', ''),
                'duration_s': float(row.get('Duration', 0)),
            })

if rows:
    rows.sort(key=lambda r: r['duration_s'], reverse=True)

    out = '../timing_summary.csv'
    with open(out, 'w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['model','agent','attack_tool','attack_ok','duration_s'])
        w.writeheader()
        w.writerows(rows)

    print(f'Wrote {len(rows)} rows to {out}')
    print(f'Top 10 by duration:')
    print(f'{\"model\":>25} {\"agent\":>30} {\"duration_s\":>10}')
    for r in rows[:10]:
        print(f'{r[\"model\"]:>25} {r[\"agent\"]:>30} {r[\"duration_s\"]:>10.1f}')
else:
    print('No rows with Duration data found.')
"
