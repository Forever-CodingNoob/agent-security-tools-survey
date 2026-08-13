#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/agentdojo"
source .venv/bin/activate

export OPENAI_COMPATIBLE_BASE_URL=http://circinus-44.ics.uci.edu:48763/v1
export OPENAI_COMPATIBLE_API_KEY=ollama

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
