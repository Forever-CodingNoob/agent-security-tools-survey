#!/usr/bin/env python3
"""Draw one bar chart per stage from the Summary table in report.md.

Reads the "#### Summary" table (rows: stage, columns: tools) and writes
docs/figures/stage-<stage>.png, one figure per row of the table.

Usage, from the artifact root (uv installs matplotlib on the fly):
    uv run scripts/plot_stage_scores.py
"""
import pathlib
import re

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

ROOT = pathlib.Path(__file__).resolve().parent.parent
REPORT = ROOT / "report.md"
OUT_DIR = ROOT / "docs" / "figures"

Y_MAX = 15
Y_TICKS = (0, 5, 10, 15)
# One fixed color per tool (Okabe-Ito hues, colorblind-safe), applied in this order
TOOL_COLORS = {"AgentDojo": "#0072B2", "ASB": "#E69F00", "AgentHarm": "#009E73"}
FALLBACK_FILL = "#4C78A8"
INK, INK_MUTED, GRID = "#222222", "#666666", "#DDDDDD"


def read_summary(path):
    """Return (tools, {stage: [score per tool]}) from the Summary table."""
    text = path.read_text()
    section = text.split("#### Summary", 1)[1]
    rows = [line for line in section.splitlines() if line.startswith("|")]
    header = [c.strip() for c in rows[0].strip("|").split("|")]
    tools = header[1:]
    scores = {}
    for row in rows[2:]:
        cells = [c.strip() for c in row.strip("|").split("|")]
        if not cells or not re.match(r"^\*{0,2}[A-Za-z]", cells[0]):
            continue
        stage = cells[0].strip("*")
        scores[stage] = [float(c.strip("*")) for c in cells[1:]]
    return tools, scores


def bar_chart(ylabel, tools, values, out):
    fig, ax = plt.subplots(figsize=(4.8, 3.2), dpi=200)
    colors = [TOOL_COLORS.get(t, FALLBACK_FILL) for t in tools]
    bars = ax.bar(tools, values, width=0.5, color=colors, zorder=3)
    ax.bar_label(bars, labels=[f"{v:.1f}" for v in values], padding=3, color=INK, fontsize=9)
    ax.set_xlabel("Tool", color=INK_MUTED)
    ax.set_ylabel(ylabel, color=INK_MUTED)
    ax.set_ylim(0, Y_MAX + 1.5)
    ax.set_yticks(Y_TICKS)
    ax.yaxis.grid(True, color=GRID, linewidth=0.8, zorder=0)
    ax.tick_params(colors=INK, labelsize=9)
    for side in ("top", "right"):
        ax.spines[side].set_visible(False)
    for side in ("left", "bottom"):
        ax.spines[side].set_color(INK_MUTED)
    fig.tight_layout()
    fig.savefig(out)
    plt.close(fig)


def main():
    tools, scores = read_summary(REPORT)
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    for stage, values in scores.items():
        out = OUT_DIR / f"stage-{stage.lower()}.png"
        bar_chart(f"{stage} score", tools, values, out)
        print(f"{out.relative_to(ROOT)}: {dict(zip(tools, values))}")


if __name__ == "__main__":
    main()
