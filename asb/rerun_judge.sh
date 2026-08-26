#!/usr/bin/env bash
# Re-run the refusal judge on completed ASB evaluation results.
# Fixes rows where the original judge call failed (connection errors).
# The agent task results (ASR, Original Task Success) are unchanged.
#
# Usage:
#   ./rerun_judge.sh                  # all CSVs in your-results/
#   ./rerun_judge.sh path/to/file.csv # one specific file
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/asb"
source .venv/bin/activate

export OLLAMA_HOST="${OLLAMA_HOST:-http://korn.ics.uci.edu:48763}"
export JUDGE_BASE_URL="${JUDGE_BASE_URL:-http://korn.ics.uci.edu:48764/v1}"
export JUDGE_API_KEY="${JUDGE_API_KEY:-ollama}"
export JUDGE_MODEL="${JUDGE_MODEL:-qwen3:14b}"
export OPENAI_API_KEY="${OPENAI_API_KEY:-ollama}"

if [ $# -ge 1 ]; then
    FILES=("$1")
else
    FILES=(../your-results/full_*_naive.csv)
fi

echo "=== Re-running refusal judge ==="
echo "Judge model: $JUDGE_MODEL"
echo "Judge endpoint: $JUDGE_BASE_URL"
echo "Files: ${FILES[*]}"
echo "Start: $(date)"

for csv_file in "${FILES[@]}"; do
    if [ ! -f "$csv_file" ]; then
        echo "File not found: $csv_file, skipping"
        continue
    fi

    echo ""
    echo "=== Processing: $csv_file ==="
    export CSV="$csv_file"

    python3 << 'PYEOF'
import ast, csv, os

from openai import OpenAI

with open('main_attacker.py') as _f:
    _source = _f.read()
_tree = ast.parse(_source)
for _node in ast.iter_child_nodes(_tree):
    if isinstance(_node, ast.FunctionDef) and _node.name == 'judge_response':
        _func_source = '\n'.join(_source.split('\n')[_node.lineno - 1 : _node.end_lineno])
        exec(_func_source, globals())
        break
else:
    raise RuntimeError("judge_response not found in main_attacker.py")

csv_path = os.environ["CSV"]

with open(csv_path, newline="") as f:
    reader = csv.reader(f)
    header = next(reader)
    rows = list(reader)

refuse_col = header.index("Refuse Result")
messages_col = header.index("messages")
total = len(rows)

print(f"Loaded {total} tasks from {csv_path}")

changed = 0
judged = 0
errors = 0

for i, row in enumerate(rows):
    agent = row[0]
    tool = row[1]

    try:
        messages = ast.literal_eval(row[messages_col])
    except Exception:
        print(f"[{i+1}/{total}] {agent}/{tool}: cannot parse messages, keeping original")
        errors += 1
        continue

    filtered = [msg for msg in messages if "[Thinking]" in str(msg) or "'thinking'" in str(msg)]
    refuse_res = judge_response(str(filtered))
    judged += 1

    if refuse_res == "0":
        print(f"[{i+1}/{total}] {agent}/{tool}: doesn't comply")
    elif refuse_res == "1":
        print(f"[{i+1}/{total}] {agent}/{tool}: complies")
    else:
        print(f"[{i+1}/{total}] {agent}/{tool}: judge error: {refuse_res}")
        errors += 1

    new_refuse = 1 if refuse_res == '0' else 0
    old_refuse = int(row[refuse_col])
    if old_refuse != new_refuse:
        changed += 1
        print(f"[{i+1}/{total}] {agent}/{tool}: {old_refuse} -> {new_refuse}")

    row[refuse_col] = str(new_refuse)

    if (i + 1) % 50 == 0:
        print(f"[{i+1}/{total}] progress: {judged} judged, {changed} changed, {errors} errors")

with open(csv_path, "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerows(rows)

print(f"\nDone. {judged} judged, {changed} changed, {errors} errors.")
print(f"Written to {csv_path}")

refuse_total = sum(1 for r in rows if r[refuse_col] == "1")
print(f"Refusal rate: {refuse_total}/{total} ({100*refuse_total/total:.1f}%)")
PYEOF
done

echo ""
echo "=== All judge re-runs complete at $(date) ==="
