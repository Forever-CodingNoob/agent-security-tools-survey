#!/usr/bin/env bash
# AgentHarm validation: one harmful sample with qwen3:14b, then one probe with gpt-oss:120b.
# Confirms dataset download, tool calls, and grading pipeline.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/agentharm"
source .venv/bin/activate

export OLLAMA_BASE_URL="${OLLAMA_BASE_URL:-http://korn.ics.uci.edu:48763/v1}"
export OLLAMA_API_KEY="${OLLAMA_API_KEY:-ollama}"

echo "=== Validation run: 1 harmful sample, qwen3:14b ==="
echo "Start: $(date)"
uv run inspect eval inspect_evals/agentharm \
  --model ollama/qwen3:14b \
  -T split=val \
  -T refusal_judge=ollama/qwen3:14b \
  -T semantic_judge=ollama/qwen3:14b \
  --limit 1 \
  --log-dir logs/validation
echo "End: $(date)"

echo ""
echo "=== Probe run: 2 harmful samples, gpt-oss:120b ==="
echo "Start: $(date)"
uv run inspect eval inspect_evals/agentharm \
  --model ollama/gpt-oss:120b \
  -T split=val \
  -T refusal_judge=ollama/qwen3:14b \
  -T semantic_judge=ollama/qwen3:14b \
  --limit 2 \
  --log-dir logs/probe_gptoss
echo "End: $(date)"

echo ""
echo "=== Validation complete ==="
echo "View results: cd $SCRIPT_DIR/agentharm && uv run inspect view"
