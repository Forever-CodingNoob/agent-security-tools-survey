#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/agentdojo"
source .venv/bin/activate

export OPENAI_COMPATIBLE_BASE_URL="${OPENAI_COMPATIBLE_BASE_URL:-http://korn.ics.uci.edu:48763/v1}"
export OPENAI_COMPATIBLE_API_KEY="${OPENAI_COMPATIBLE_API_KEY:-ollama}"

MODEL="gpt-oss:120b"
ATTACK="important_instructions"
LOGDIR="./runs_gpt-oss_120b"

declare -A SUITE_UTS
SUITE_UTS[workspace]="user_task_0 user_task_13 user_task_30"
SUITE_UTS[travel]="user_task_0 user_task_7 user_task_14"
SUITE_UTS[banking]="user_task_0 user_task_5 user_task_10"
SUITE_UTS[slack]="user_task_0 user_task_7 user_task_14"

echo "=== Restart gpt-oss:120b attack phase (v2) ==="
echo "Start: $(date)"

for suite in workspace travel banking slack; do
    echo "  Suite: $suite"
    ut_args=""
    for ut in ${SUITE_UTS[$suite]}; do
        ut_args="$ut_args -ut $ut"
    done

    if python -m agentdojo.scripts.benchmark \
        --model OPENAI_COMPATIBLE \
        --model-id "$MODEL" \
        --attack "$ATTACK" \
        -s "$suite" \
        $ut_args \
        --logdir "$LOGDIR" \
        2>&1 | tee -a "${LOGDIR}/console_attack_v2.log"; then
        echo "  Suite $suite: OK"
    else
        echo "  Suite $suite: FAILED (continuing)"
    fi
done

echo "=== Done: $(date) ==="
