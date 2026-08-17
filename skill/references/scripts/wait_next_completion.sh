#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG="$SCRIPT_DIR/../../../agentharm/agentharm/logs/full/runner.log"
base=$(grep -c "RUN_END" "$LOG")
while true; do
  cur=$(grep -c "RUN_END" "$LOG")
  if [ "$cur" -gt "$base" ]; then
    grep -E "RUN_END|ALL_DONE" "$LOG" | tail -n $((cur - base))
    exit 0
  fi
  if grep -q "ALL_DONE" "$LOG"; then
    echo "ALL_DONE detected"
    exit 0
  fi
  sleep 30
done
