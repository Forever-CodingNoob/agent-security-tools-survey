#!/usr/bin/env bash
# AgentHarm full run: both tasks (harmful + benign), all 3 models, test_public split.
# Total: 1056 samples (176 per model per task). Estimated time: ~14.5 hours sequential.
#
# Log directories use the pattern your-results/<shortname>_<task>, for example your-results/gptoss_harmful.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/agentharm"
source .venv/bin/activate

export OLLAMA_BASE_URL="${OLLAMA_BASE_URL:-http://korn.ics.uci.edu:48763/v1}"
export OLLAMA_API_KEY="${OLLAMA_API_KEY:-ollama}"

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
        log_subdir="../your-results/${short}_${label}"

        echo ""
        echo "=== $model / $task -> $log_subdir ==="
        echo "Start: $(date)"

        uv run inspect eval "inspect_evals/$task" \
          --model "ollama/$model" \
          -T split=test_public \
          -T refusal_judge="$JUDGE_MODEL" \
          -T semantic_judge="$JUDGE_MODEL" \
          --max-connections 1 \
          --log-dir "$log_subdir"

        echo "End: $(date)"
    done
    echo "===== Done: $model at $(date) ====="
done

echo ""
echo "=== All done: $(date) ==="
echo "View results: cd $SCRIPT_DIR/agentharm && uv run inspect view"

echo ""
echo "=== Per-task timing summary ==="
"$SCRIPT_DIR/agentharm/.venv/bin/python3" -c "
import csv, glob, os

from inspect_ai.log import read_eval_log

rows = []
for f in sorted(glob.glob('../your-results/*/*.eval')):
    subdir = os.path.basename(os.path.dirname(f))
    log = read_eval_log(f)
    model = str(log.eval.model) if log.eval else ''
    task = str(log.eval.task) if log.eval else ''
    for s in (log.samples or []):
        rows.append({
            'subdir': subdir,
            'model': model,
            'task': task,
            'sample_id': str(s.id),
            'total_time_s': getattr(s, 'total_time', 0) or 0,
            'working_time_s': getattr(s, 'working_time', 0) or 0,
        })

rows.sort(key=lambda r: r['total_time_s'], reverse=True)

out = '../your-results/timing_summary.csv'
with open(out, 'w', newline='') as f:
    w = csv.DictWriter(f, fieldnames=['subdir','model','task','sample_id','total_time_s','working_time_s'])
    w.writeheader()
    w.writerows(rows)

print(f'Wrote {len(rows)} rows to {out}')
print(f'Top 10 by total_time:')
print(f'{\"subdir\":>20} {\"sample_id\":>12} {\"total_time_s\":>12} {\"working_time_s\":>14}')
for r in rows[:10]:
    print(f'{r[\"subdir\"]:>20} {r[\"sample_id\"]:>12} {r[\"total_time_s\"]:>12.1f} {r[\"working_time_s\"]:>14.1f}')
"
