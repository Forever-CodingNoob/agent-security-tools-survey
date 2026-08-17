#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/agentdojo"
source .venv/bin/activate

export OPENAI_COMPATIBLE_BASE_URL="${OPENAI_COMPATIBLE_BASE_URL:-http://korn.ics.uci.edu:48763/v1}"
export OPENAI_COMPATIBLE_API_KEY="${OPENAI_COMPATIBLE_API_KEY:-ollama}"

MODELS=("qwen3:14b" "qwen3-coder:30b" "gpt-oss:120b")
ATTACK="important_instructions"

# 3 evenly spaced user tasks per suite.
# gpt-oss:120b generates malformed JSON on workspace user_task_26 (and user_task_30),
# causing ollama server 500 errors. For that model, workspace uses user_task_20 instead.
WORKSPACE_UTS_DEFAULT=("user_task_0" "user_task_13" "user_task_26")
WORKSPACE_UTS_GPTOSS=("user_task_0" "user_task_13" "user_task_20")
TRAVEL_UTS=("user_task_0" "user_task_7" "user_task_14")
BANKING_UTS=("user_task_0" "user_task_5" "user_task_10")
SLACK_UTS=("user_task_0" "user_task_7" "user_task_14")

echo "=== AgentDojo reduced benchmark ==="
echo "Start: $(date)"

for model in "${MODELS[@]}"; do
    model_slug="${model//:/_}"
    logdir="./runs_${model_slug}"
    mkdir -p "$logdir"

    echo ""
    echo "===== Model: $model (logdir: $logdir) ====="

    echo "--- Phase 1: utility baseline (no attack, all 97 tasks) ---"
    echo "Start utility: $(date)"
    python -m agentdojo.scripts.benchmark \
        --model OPENAI_COMPATIBLE \
        --model-id "$model" \
        --logdir "$logdir" \
        2>&1 | tee "${logdir}/console_utility.log"
    echo "End utility: $(date)"

    echo "--- Phase 2: $ATTACK attack (3 user tasks per suite) ---"
    echo "Start attack: $(date)"

    for suite in workspace travel banking slack; do
        echo "  Suite: $suite"
        case "$suite" in
            workspace)
                if [[ "$model" == "gpt-oss:120b" ]]; then
                    uts=("${WORKSPACE_UTS_GPTOSS[@]}")
                else
                    uts=("${WORKSPACE_UTS_DEFAULT[@]}")
                fi
                ;;
            travel)    uts=("${TRAVEL_UTS[@]}") ;;
            banking)   uts=("${BANKING_UTS[@]}") ;;
            slack)     uts=("${SLACK_UTS[@]}") ;;
        esac

        ut_args=""
        for ut in "${uts[@]}"; do
            ut_args="$ut_args -ut $ut"
        done

        python -m agentdojo.scripts.benchmark \
            --model OPENAI_COMPATIBLE \
            --model-id "$model" \
            --attack "$ATTACK" \
            -s "$suite" \
            $ut_args \
            --logdir "$logdir" \
            2>&1 | tee -a "${logdir}/console_attack.log"
    done

    echo "End attack: $(date)"
    echo "===== Done: $model at $(date) ====="
done

echo ""
echo "=== All done: $(date) ==="

echo ""
echo "=== Per-task timing summary ==="
python3 -c "
import json, glob, csv, os

rows = []
for f in sorted(glob.glob('./runs_*/openai-compatible/**/*.json', recursive=True)):
    d = json.load(open(f))
    rows.append({
        'model': [p for p in f.split('/') if p.startswith('runs_')][0].replace('runs_', ''),
        'suite': d.get('suite_name', ''),
        'user_task': d.get('user_task_id', ''),
        'injection_task': d.get('injection_task_id') or '',
        'attack': d.get('attack_type') or 'none',
        'duration_s': d.get('duration') or 0,
        'utility': d.get('utility') or '',
        'security': d.get('security') or '',
    })

rows.sort(key=lambda r: r['duration_s'], reverse=True)

out = '../timing_summary.csv'
with open(out, 'w', newline='') as f:
    w = csv.DictWriter(f, fieldnames=['model','suite','user_task','injection_task','attack','duration_s','utility','security'])
    w.writeheader()
    w.writerows(rows)

print(f'Wrote {len(rows)} rows to {out}')
print(f'Top 10 by duration:')
print(f'{\"model\":>20} {\"suite\":>12} {\"user_task\":>14} {\"attack\":>8} {\"duration_s\":>10}')
for r in rows[:10]:
    print(f'{r[\"model\"]:>20} {r[\"suite\"]:>12} {r[\"user_task\"]:>14} {r[\"attack\"]:>8} {r[\"duration_s\"]:>10.1f}')
"
