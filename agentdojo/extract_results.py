#!/usr/bin/env python3
"""Extract AgentDojo benchmark results from JSON log files."""
import json
import sys
from pathlib import Path
from collections import defaultdict

def extract(logdir: str, model_dir: str):
    base = Path(logdir) / model_dir
    if not base.exists():
        print(f"Directory not found: {base}")
        return

    results = defaultdict(lambda: {"utility": [], "security": [], "duration": []})

    for jsonfile in sorted(base.rglob("*.json")):
        with open(jsonfile) as f:
            data = json.load(f)

        suite = data.get("suite_name", "unknown")
        attack = data.get("attack_type", "none")
        user_task = data.get("user_task_id")
        inj_task = data.get("injection_task_id")

        if user_task and attack != "none":
            key = f"{suite}/{attack}"
            results[key]["utility"].append(data.get("utility", False))
            results[key]["security"].append(data.get("security", False))
            results[key]["duration"].append(data.get("duration", 0))
        elif user_task and attack == "none":
            key = f"{suite}/baseline"
            results[key]["utility"].append(data.get("utility", False))
            results[key]["duration"].append(data.get("duration", 0))

    print(f"Model: {model_dir}")
    print(f"{'Suite/Mode':<40} {'Utility':>10} {'Security':>10} {'Count':>7} {'Avg sec':>8}")
    print("-" * 80)

    for key in sorted(results.keys()):
        r = results[key]
        util_vals = r["utility"]
        sec_vals = r["security"]
        dur_vals = r["duration"]
        n = len(util_vals)
        avg_util = sum(util_vals) / n if n else 0
        avg_dur = sum(dur_vals) / n if n else 0
        if sec_vals:
            avg_sec = sum(sec_vals) / len(sec_vals)
            print(f"{key:<40} {avg_util*100:>9.1f}% {avg_sec*100:>9.1f}% {n:>7} {avg_dur:>7.1f}")
        else:
            print(f"{key:<40} {avg_util*100:>9.1f}% {'N/A':>10} {n:>7} {avg_dur:>7.1f}")

    total_dur = sum(d for r in results.values() for d in r["duration"])
    print(f"\nTotal wall-clock: {total_dur/3600:.1f} hours")


if __name__ == "__main__":
    logdir = sys.argv[1] if len(sys.argv) > 1 else "./runs"
    model = sys.argv[2] if len(sys.argv) > 2 else "openai-compatible"
    extract(logdir, model)
