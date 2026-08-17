# <Tool name> ([repo](<repo_link>)) ([paper](<paper_link>))

> Write this report in ASD-STE100 Simplified Technical English. Keep sentences short.
> Use the active voice. Code blocks and command output are exempt from the language rules.

## Summary

State in two or three sentences what the tool does and what it measures.

## Installation

Give the exact commands. Record the environment tool (for example `uv` or `pip`).
Record every extra step and every dependency fix.

## Usage

Give the exact commands to run one task and a full run. Show how to select the model.
Show how to point the tool at the ollama server.

## Dataset

Name the dataset or benchmark. State the size and the splits. State where the data is
stored on disk. State if the data is gated or needs a token.

## Test Result

Show each command that you ran. Show the real output. Include a small results table with
one row per model (`gpt-oss:120b`, `qwen3-coder:30b`, `qwen3:14b`). Include time and tokens.
Include one example task trajectory, so the reader can see how a score is produced.

## Criteria

### Deployability

### Extensibility

### Educational Viability

### Maintenance & Support

### Classroom Safety

## Attack vectors and security risks

Read `attack-risk-coverage.md` to find the tool's row in the coverage
table. That file maps each tool to the taxonomy in Xie et al. (arXiv:2603.11088). Copy the
covered attack vectors and security risks from that row.

### Covered attack vectors

List each V code with its canonical name and a one-sentence explanation of how this tool
exercises it. Use the description from the coverage table.

### Covered security risks

List each R code with its canonical name and a one-sentence explanation of how this tool
exercises it. Use the description from the coverage table.

### Vectors and risks not covered

List the V and R codes that this tool does not cover. State this in one paragraph.

## Quick-start documentation

Give a short, numbered "how to use this tool" list. A new student must be able to follow it.
