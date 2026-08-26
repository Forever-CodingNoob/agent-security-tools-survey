#!/usr/bin/env bash
# ASB partial evaluation: naive DPI attack, 100-tool subset, all 3 models.
# The subset (attack_tools_subset_100.jsonl, next to this script) holds 5 aggressive
# and 5 non-aggressive attacker tools per agent across all 10 agents.
# Each model runs sequentially (the FIFOScheduler serializes LLM requests).
# For the complete 400-tool experiment, use run_full_benchmark.sh instead.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/asb"
source .venv/bin/activate

export OLLAMA_HOST="${OLLAMA_HOST:-http://korn.ics.uci.edu:48763}"
export JUDGE_BASE_URL="${JUDGE_BASE_URL:-http://korn.ics.uci.edu:48763/v1}"
export JUDGE_API_KEY="${JUDGE_API_KEY:-ollama}"
export JUDGE_MODEL="${JUDGE_MODEL:-qwen3:14b}"
export OPENAI_API_KEY="${OPENAI_API_KEY:-ollama}"

# Space-separated list of models to run. Override to rerun a subset, for example:
#   MODELS="qwen3-coder:30b" ./run_partial_benchmark.sh
read -r -a MODELS <<< "${MODELS:-qwen3:14b qwen3-coder:30b gpt-oss:120b}"

mkdir -p ../your-results
rm -f ../your-results/timing_summary.csv

echo "=== ASB partial benchmark (naive DPI, 100 tasks per model) ==="
echo "Models: ${MODELS[*]}"
echo "Start: $(date)"

for model in "${MODELS[@]}"; do
    model_slug="${model//:/_}"
    model_slug="${model_slug//-/_}"
    res_file="../your-results/partial_${model_slug}_naive.csv"
    rm -f "$res_file"

    echo ""
    echo "=== Starting partial run: $model ==="
    echo "Start time: $(date)"
    START_SECS=$SECONDS

    python main_attacker.py \
      --llm_name "ollama/$model" \
      --use_backend ollama \
      --attack_type naive \
      --attacker_tools_path "$SCRIPT_DIR/attack_tools_subset_100.jsonl" \
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

echo "=== All partial runs complete at $(date) ==="
for f in ../your-results/partial_*.csv; do
    echo "$f: $(wc -l < "$f") rows"
done

echo ""
echo "=== Per-task timing summary ==="
python3 -c "
import csv, glob, os

rows = []
for f in sorted(glob.glob('../your-results/partial_*.csv')):
    model_tag = os.path.basename(f).replace('partial_', '').replace('_naive.csv', '')
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

    out = '../your-results/timing_summary.csv'
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
