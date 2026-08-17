#!/usr/bin/env bash
# Full AgentHarm run across 3 ollama agent models, fixed qwen3:14b judge, test_public split.
# Single GPU => models run sequentially to avoid VRAM thrash.
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/../../../agentharm/agentharm" || exit 1
export PATH="$HOME/.local/bin:$PATH"

JUDGE="ollama/qwen3:14b"
SPLIT="test_public"
MILE="logs/full/runner.log"
mkdir -p logs/full
echo "ALL_START $(date -Is)" | tee -a "$MILE"

run() {
  local model="$1" conn="$2" task="$3" tag="$4"
  local logd="logs/full/${tag}"
  mkdir -p "$logd"
  echo "RUN_START $(date -Is) tag=$tag model=$model task=$task conn=$conn" | tee -a "$MILE"
  uv run inspect eval "inspect_evals/${task}" \
    --model "ollama/${model}" \
    -T split="$SPLIT" \
    -T refusal_judge="$JUDGE" \
    -T semantic_judge="$JUDGE" \
    --max-connections "$conn" \
    --fail-on-error 0.5 \
    --log-dir "$logd" > "${logd}/run.stdout" 2>&1
  local rc=$?
  echo "RUN_END $(date -Is) tag=$tag rc=$rc" | tee -a "$MILE"
}

# Sequential per-model (single sharded accelerator). Raise per-model concurrency so
# same-model requests batch into shared forward passes. harmful then benign per model.
run qwen3-coder:30b 16 agentharm        coder_harmful
run qwen3-coder:30b 16 agentharm_benign coder_benign
run gpt-oss:120b    8  agentharm        gptoss_harmful
run gpt-oss:120b    8  agentharm_benign gptoss_benign
run qwen3:14b       16 agentharm        qwen14_harmful
run qwen3:14b       16 agentharm_benign qwen14_benign

echo "ALL_DONE $(date -Is)" | tee -a "$MILE"
