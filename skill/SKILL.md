--- name: agentic-tool-eval description: >- Evaluate an off-the-shelf agentic-LLM security tool, benchmark, fuzzer, or red-teaming suite for the CodeSafe education project. Use this when the user asks to assess, survey, smoke-test, or write a report on a tool such as AgentHarm, ASB, AgentDojo, InjecAgent, ToolEmu, or any similar agentic attack/defense benchmark. Produces one detailed per-tool report plus a row in the rollup report, scored on 5 fixed criteria, and drives all tests through the shared ollama server.
---

# Agentic-tool evaluation workflow

This skill drives a repeatable evaluation of one agentic-LLM security tool at a time for the CodeSafe project. Follow the phases in order. Produce the two report files at the end.

## Fixed context for CodeSafe

- The goal is an education platform. It teaches attacks and defenses for agentic LLMs.
- The user evaluates many tools. Each tool gets one detailed report. All tools share one rollup report with a comparison table.
- Write every report in ASD-STE100 Simplified Technical English. See the memory file `report-language-ste100.md` for the rules. Code blocks and command output are exempt.
- Test every tool with the shared ollama server. Use these three models as the agent models under test:
  - `gpt-oss:120b` (large model)
  - `qwen3-coder:30b` (mid model)
  - `qwen3:14b` (small model)
- Default ollama server base URL: `http://korn.ics.uci.edu:48763`. Evaluation scripts use environment variables with this default, so anyone can override the endpoint by setting the variable before running the script. See Phase 5 for the pattern.
- If a tool cannot use an ollama endpoint, state this clearly in the report.

## Evaluation criteria

Score each tool on these seven criteria. Answer the concrete questions for each one.

1. **Deployability**: How costly is it to set up and run the tool? Consider: hardware requirements (GPUs, RAM), software dependencies (Docker, VM, web server), API credits, gated dataset access (tokens, applications, approval wait), and time to complete a full evaluation. Give real numbers from test runs.
2. **Extensibility**: How easily can a user add new benchmark content (tasks, attacks, tools, scoring functions) to the framework? Consider: whether extension requires modifying core framework code, whether extension points are documented, and whether changes are scoped to one module or spread across the codebase.
3. **Maintenance & Support**: How actively is the tool maintained and supported? Consider:
   date and frequency of commits, whether maintainers respond to issues, and whether dependencies install without fixes. Record exact dependency problems and their solutions.
4. **Execution isolation**: How well are the tool's actions isolated from real systems?
   Consider: whether tools operate on in-memory objects, stubbed API responses, sandboxed containers, or real external services. State what safeguards exist if any actions reach real systems.
5. **Content sensitivity**: To what extent does the dataset contain content that is harmful or offensive to read? Check for: hate speech, sexual content, harassment, graphic violence, and explicit attack instructions. State which categories are present, how explicit the content is, and whether the tool provides a way to filter or subset the data.
6. **Observability**: How well can a student trace what happened in a task run and why it scored the way it did? Consider: whether the output shows the full message sequence (user prompt, model responses, tool calls, tool results), whether the scoring breakdown explains why a task passed or failed, whether there is a trajectory viewer or only raw output, and whether the score is granular (0.0 to 1.0) or binary.
7. **Experimentability**: To what extent can a student build and test their own agent defenses? Consider: whether the tool exposes an API for custom agent pipelines or defense logic, whether the student can run the benchmark against their own agent, and whether the tool only allows swapping the model.

## Phase 1: Ground the tool

1. Read the repository README and the paper abstract. Use WebFetch for both.
2. Record: what it measures, the task or dataset size, the agent framework, the license.
3. Find how the tool selects the model provider. Check for ollama or an OpenAI-compatible base URL. This decides Deployability and whether the ollama server works.
4. Find how the dataset loads. Check for gating, a token, or a manual download.

## Phase 2: Set up an isolated environment

1. Create a directory for the tool at the project root: `<tool>/`.
2. Add the tool's repository as a git submodule at `<tool>/<tool>/`:
   ```bash
   git submodule add <repo_url> <tool>/<tool>
   ```
3. Create an isolated environment inside `<tool>/<tool>/`. Prefer `uv` when the repo uses it. Record the exact install command and any extra step.
4. Point the tool at the ollama server through environment variables. See `references/inspect-ollama-config.md` for the Inspect recipe, and adapt for other frameworks. Do not hardcode the server URL in scripts (see Phase 5 for the pattern).
5. Record every dependency problem and its fix. This feeds Maintenance & Support.

## Phase 3: Validate on a small sample

1. Run one or two tasks first. Confirm the pipeline works end to end.
2. Confirm the dataset downloads. Confirm the model makes tool calls. Confirm the grader runs.
3. Read one full task trajectory. Confirm you can explain the score. This feeds Educational Viability.
4. Measure the time and tokens for one task. Use this to estimate the full run.

## Phase 4: Run the full test

1. Run the tool with each of the three ollama models as the agent model.
2. Hold the judge or grader model constant across runs for a fair comparison. Prefer a small judge model that co-resides with the agent models, to avoid VRAM thrash.
3. The ollama server has 4 GPUs. The model is sharded across all 4 GPUs, so every request flows through all 4 in sequence. Run the models sequentially, one model at a time.
   Different models contend for the same GPUs, so parallel model runs slow each other down.
   The server is configured with `OLLAMA_NUM_PARALLEL=1`, so it processes one request at a time; additional requests queue. `OLLAMA_KEEP_ALIVE=-1` keeps models loaded indefinitely, so there is no reload overhead between requests. The context window is `OLLAMA_CONTEXT_LENGTH=65536`. Check `GET /api/ps`: if `size_vram` is less than `size`, the model spills to CPU and inference slows down.
4. Capture logs, scores, refusals, and errors for each run.

## Phase 5: Write evaluation scripts

Place all evaluation scripts in `<tool>/` (next to `report.md`). Each script must be self-contained and re-runnable. Follow these conventions:

1. **Environment variables with defaults.** Do not hardcode the server URL. Use the bash fallback pattern so a user can override any variable before running:
   ```bash
   export OLLAMA_HOST="${OLLAMA_HOST:-http://korn.ics.uci.edu:48763}"
   ```
   Apply the same pattern to API keys, judge models, and any other configurable value.

2. **Script types.** Create at minimum:
   - `run_validation.sh`: a quick smoke test (one or two tasks, all models). Confirms the pipeline works end to end.
   - `run_full.sh`: the complete evaluation (all tasks, all models). This is what someone runs to reproduce the reported results.

3. **Timing summary.** Append an inline block at the end of `run_full.sh` (and any other full-evaluation script) that reads the result files produced by that run, extracts per-task wall-clock duration, prints a top-10 table to stdout, and writes a `timing_summary.csv` in the tool directory. This identifies which tasks are practical for classroom exercises. The timing data source differs per tool:
   - AgentDojo: `duration` field in JSON result files.
   - AgentHarm/Inspect: `total_time` on each sample in `.eval` logs (use `inspect_ai.log.read_eval_log`).
   - ASB: `Duration` column in CSV output (requires the source patch documented in the installation section).
   - For a new tool: find where wall-clock time is recorded. If the tool does not record it, add a small source patch and document the patch in the installation section of the report.

4. **Relative paths.** Resolve the source directory relative to the script's own location:
   ```bash
   SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
   cd "$SCRIPT_DIR/<tool>"
   ```

## Phase 6: Write the reports

1. Write `<tool>/report.md` from `templates/tool-report-template.md`. Each tool has its own directory at the project root: `<tool>/report.md` (the detailed report), `<tool>/<tool>/` (the source code submodule), and `<tool>/*.sh` or `<tool>/*.py`
   (evaluation scripts). Add an "Evaluation scripts" table in the report that lists each script, its purpose, and the result files it produces. This lets a reader link a reported number to the command that produced it.
2. In the Installation section, document every source patch applied to the submodule.
   State the file, the change, and the reason.
3. In the Installation or Usage section, tell the user which environment variables to set and state that the evaluation scripts fall back to the default server URL if unset.
4. Add or update the tool's row in `report.md` from `templates/rollup-report-template.md`.
5. Use ASD-STE100 English. Quote real commands and real output in the Test Result section.
6. For a harmful benchmark, quote sensitive prompt text only as much as the report needs.
7. Read `attack-risk-coverage.md` (read-only data source). Find the tool's row in the coverage table. Use it to fill two parts of the reports:
   - In the rollup comparison table (`report.md`), fill the "Attack Vectors" cell with the V codes and canonical names (for example, "V1 (Indirect prompt injection)") and the "Security Risks" cell with the R codes and canonical names.
   - In the detailed report (`<tool>/report.md`), write the "Attack vectors and security risks" section. List each covered V and R code with a one-sentence explanation from the coverage table. End with a paragraph that lists the vectors and risks not covered.

## Notes learned from prior tools

- Inspect (`inspect_ai`) evals (AgentHarm and others) support ollama through the `OLLAMA_BASE_URL` variable and the `ollama/<model>` prefix. The tool's own README may not mention this, but the framework does.
- The Inspect ollama provider needs the `openai` package. `uv sync` does not install it by default. Run `uv pip install openai` after sync.
- `.eval` log files use zstd compression. Do not open them with the Python stdlib `zipfile`.
  Use `inspect_ai.log.read_eval_log` or `uv run inspect log dump`.
