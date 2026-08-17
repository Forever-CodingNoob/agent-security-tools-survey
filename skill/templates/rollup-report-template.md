# CodeSafe tool survey: rollup report

> Write this report in ASD-STE100 Simplified Technical English.
> This file collects all evaluated tools. Add one row per tool to the table.
> Each tool also has a detailed report in `<tool>/report.md`.

## Comparison table

| Tool | Deployability | Extensibility | Educational Viability | Maintenance & Support | Classroom Safety | Attack Vectors | Security Risks |
|------|---------------|---------------|-----------------------|-----------------------|------------------|----------------|----------------|
| <Tool name> | <short verdict> | <short verdict> | <short verdict> | <short verdict> | <short verdict> | <V codes from coverage table> | <R codes from coverage table> |

## Score legend

State how you rate each cell (for example: Good, Fair, Poor). Keep the words consistent for
all tools.

## Per-tool notes

For each tool, give a two or three sentence summary. Link to the detailed report.

- **<Tool name>**: <summary>. See `<tool>/report.md`.

## Test harness

State the shared test setup. All tools use the ollama server at
`http://korn.ics.uci.edu:48763` with the models `gpt-oss:120b`, `qwen3-coder:30b`,
and `qwen3:14b`. Each tool's evaluation scripts accept environment variables for the server
URL and fall back to this default if unset.
