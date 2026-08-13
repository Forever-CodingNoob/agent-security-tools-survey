#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/agentdojo"
source .venv/bin/activate

export OPENAI_COMPATIBLE_BASE_URL=http://circinus-44.ics.uci.edu:48763/v1
export OPENAI_COMPATIBLE_API_KEY=ollama

MODEL="gpt-oss:120b"
ATTACK="important_instructions"
LOGDIR="./runs_gpt-oss_120b"

WORKSPACE_UTS=("user_task_0" "user_task_13" "user_task_26")
TRAVEL_UTS=("user_task_0" "user_task_7" "user_task_14")
BANKING_UTS=("user_task_0" "user_task_5" "user_task_10")
SLACK_UTS=("user_task_0" "user_task_7" "user_task_14")

echo "=== Restart gpt-oss:120b attack phase ==="
echo "Start: $(date)"

for suite in workspace travel banking slack; do
    echo "  Suite: $suite"
    case "$suite" in
        workspace) uts=("${WORKSPACE_UTS[@]}") ;;
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
        --model-id "$MODEL" \
        --attack "$ATTACK" \
        -s "$suite" \
        $ut_args \
        --logdir "$LOGDIR" \
        2>&1 | tee -a "${LOGDIR}/console_attack_restart.log"
done

echo "=== Done: $(date) ==="
