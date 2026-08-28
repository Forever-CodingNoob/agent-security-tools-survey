--- name: agentic-tool-eval description: >- Evaluate an off-the-shelf agentic-LLM security tool, benchmark, fuzzer, or red-teaming suite for educational use. Use this when the user asks to assess, survey, smoke-test, or write a report on a tool such as AgentHarm, ASB, AgentDojo, InjecAgent, ToolEmu, or any similar agentic attack/defense benchmark. Produces one detailed per-tool report plus a row in the rollup report, scored on the BetterBench stages plus our Education stage (see criteria.md), and drives all tests through the shared ollama server.
---

# Agentic-tool evaluation workflow

This skill drives a repeatable evaluation of one agentic-LLM security tool at a time for our tool survey. Follow the phases in order. Produce the two report files at the end.

## Fixed context

- The goal is an education platform. It teaches attacks and defenses for agentic LLMs.
- The user evaluates many tools. Each tool gets one detailed report. All tools share one rollup report with a comparison table.
- Write every report in ASD-STE100 Simplified Technical English. See the memory file `report-language-ste100.md` for the rules. Code blocks and command output are exempt.
- Test every tool with the shared ollama server. Use these three models as the agent models under test:
  - `gpt-oss:120b` (large model)
  - `qwen3-coder:30b` (mid model)
  - `qwen3:14b` (small model)
- Default ollama server base URL: `http://korn.ics.uci.edu:48763`. Evaluation scripts use environment variables with this default, so anyone can override the endpoint by setting the variable before running the script. See Phase 5 for the pattern.
- If a tool cannot use an ollama endpoint, state this clearly in the report.

## Report format and writing style

These conventions apply to every tool report (`<tool>/README.md`) and the rollup report (`report.md`). They supplement the ASD-STE100 rules above. The AgentHarm and AgentDojo READMEs are the reference examples.

### Section order

Every tool report follows this section order:
1. Title (with parenthesized links to repo, paper, and dataset)
2. Table of Contents
3. Summary
4. File Hierarchy
5. Getting Started
6. Installation
7. Usage (including extension how-tos such as "Adding a jailbreak template")
8. Dataset (with subsections for splits/size, scoring, and evaluation trajectory)
9. Conducting Evaluation (scripts table, experimental settings, full and partial how-to)
10. Experimental Results (results tables, execution time, findings with analysis)
11. Criteria (stage summary table, then Design, Implementation, Documentation, Maintenance, Education. See Evaluation criteria and scoring below)
12. Attack vectors and security risks (covered vectors, covered risks, vectors and risks not covered)
13. References (collected links to paper, repo, dataset, framework, taxonomy)

### Table of Contents

List every heading and subheading. Use `+` list items with indentation for nesting. The reader must be able to jump to any subsection from the ToC.

### Title line and source links

The H1 title includes parenthesized links to the tool's repository, paper, and dataset (when applicable):
```markdown
# ToolName ([repo](URL)) ([paper](URL)) ([dataset](URL))
```

Link to primary sources inline at first mention throughout the report. When you refer to a framework, a dataset, a viewer, or any external project by name, make the name a markdown link to its primary URL. For example: `[Inspect AI framework](https://github.com/UKGovernmentBEIS/inspect_ai)`. Collect all such links again in the References section at the end.

### Term definitions

Define each domain-specific term before its first use. Use italics for the term and a colon or parenthetical for the definition:
```markdown
The paper also tests with *jailbreaks*: prompt wrappers that rephrase
the harmful request to bypass safety training.
```

If a term has a synonym at a different layer (for example, "behavior" in the JSON dataset vs "sample" in the Inspect runtime), state the 1:1 relationship explicitly at the point of definition, then use one term consistently after that. When the tool's own terminology is jargon that a student would not know (for example, "solver" in Inspect means "agent"), state the mapping once in a NOTE callout and use the clearer term in the report text.

### Sentence style

Join related facts with connectives (because, so, while, which) or adverbs (typically, however, instead) rather than writing isolated short sentences. Use subordinate clauses to explain cause or consequence inline.

Example of what to avoid:
```
A refusal scores 0. The grading function finds no correct tool calls.
```

Preferred form:
```
A refusal typically scores 0 because the grading function finds few or
no correct tool calls.
```

This does not conflict with STE100's sentence-length limits. The goal is to avoid a choppy sequence of sentence fragments that each lack context. Two short sentences that share a causal relationship read better as one sentence with "because" or "so."

### Lists over paragraphs

When a section covers multiple items (splits, task types, extension points, metrics), introduce them with a short sentence ending with a colon, then use a `+` or `-` list. Each list item names the value and gives a concise description. Do not flatten multiple items into a single paragraph.

### List-before-table

When a table has labeled rows or columns that need explanation, introduce each dimension with a short sentence followed by a list before the table. The table then serves as a numerical summary. For example, define the splits in a list, define the task types in a second list, then place the count table after both.

### Callouts

- `> [!NOTE]`: supporting evidence such as file paths, code locations, or implementation details.
- `> [!IMPORTANT]`: caveats that affect the evaluation (timing, cost, limitations, or required patches).
- `> [!TIP]`: practical shortcuts (for example, where result files are stored).

### Code examples

Each code block has a `#` comment on the first line that says what the command does. When showing before/after patches, use `# BEFORE:` and `# AFTER:` comments inside the block.

### Server URL in READMEs

READMEs use `<url_to_your_ollama_server>` as a placeholder in installation and usage examples. The actual server URL (`http://korn.ics.uci.edu:48763`) belongs only in evaluation scripts (as an environment variable default) and in `docs/install.md` as the example of our setup. A README must not expose the specific server address.

### Findings section

Structure findings as `+` list items. Start each item with a `**bold label**:` that names the pattern or insight, then explain with supporting data. When two effects interact, describe both in the same item so the reader sees the relationship.

## Evaluation criteria and scoring

The scoring scheme is defined in `docs/criteria.md`. Read it before scoring. In brief:

- Four stages are taken verbatim from BetterBench (betterbench.stanford.edu/methodology.html): Design (D1 to D14), Implementation (I1 to I10), Documentation (Do1 to Do20), Maintenance (M1 to M3). Score them from the developers' published material only: paper, website, repository, dataset host. Use the GitHub API for dated facts (last commit to the benchmark's own code, issue response times, CI status, releases).
- A fifth stage, Education (E1 to E8), is ours. Score it from our own run: measured times, result files, trajectories, fixes applied.
- Each criterion is scored 0 (neither acknowledged nor addressed), 5 (acknowledged but not addressed), 10 (partially addressed), 15 (fully addressed), or n/a (not relevant, excluded from averages). Use n/a only where `criteria.md` marks the criterion as usually inapplicable or the criterion says "(if applicable)" and the subject does not exist for the tool, and justify it.
- A stage score is the mean of its applicable criteria, one decimal. Usability is the mean over all applicable Implementation, Documentation, and Maintenance criteria (BetterBench's criterion-count-weighted definition). Education is reported separately and never folded into usability.
- Numbers only. Do not use verdict words.

### Criteria section format in a tool README

```markdown
## Criteria

<one paragraph: link to criteria.md, evidence rule per stage, "as of <date>">

| Stage | Score |
|-------|-------|
| Design | 12.3 |
| Implementation | 10.5 |
| Documentation | 13.3 |
| Maintenance | 11.7 |
| Education | 13.1 |
| Usability | 12.3 |

### Design

stage avg score: 12.3

| Criterion | Score | Justification |
|-----------|-------|---------------|
| (D1) Definition of tested capability or characteristic | 15 | One or two sentences ending in a checkable citation (paper section, README heading, file path, issue number, or a measured value). |
...
```

Rules for the tables:
- Five stage subsections in this order: Design, Implementation, Documentation, Maintenance, Education. Each starts with `stage avg score: N.N`.
- The Criterion cell is `(ID) short name`, with the ID from `criteria.md`.
- Every Justification cites something the reader can check. For Education criteria, cite the run (times, paths, fixes).
- Keep existing `[!NOTE]` and `[!IMPORTANT]` callouts, and place each under the stage whose criteria it supports.
- Verify by script that every stage mean equals the mean of its applicable scores and that the summary table matches.

### Rollup report updates

After writing the tool report, update two sections in the rollup `report.md`:

**Comparison Table.** Add or update the tool's row: Tool (markdown link to the README), the five stage scores, Usability, Content level (formulaic, concrete, or graphic, with categories present), Score granularity (binary, discrete, or continuous), Attack Vectors (V-codes with canonical names), Security Risks (R-codes with canonical names).

**Scores by criterion.** Add a column for the tool to each of the five stage tables (one row per criterion, a bold stage-score row last) and to the Summary table. Generate these tables from the README tables by script rather than retyping numbers.

The rollup report does not have per-tool notes. Tool-specific findings belong only in the tool's own README.

## Phase 1: Ground the tool

1. Read the repository README and the paper abstract. Use WebFetch for both.
2. Record: what it measures, the task or dataset size, the agent framework, the license.
3. Find how the tool selects the model provider. Check for ollama or an OpenAI-compatible base URL. This decides Implementation (I4, I5) and Education (E6), and whether the ollama server works.
4. Find how the dataset loads. Check for gating, a token, or a manual download.

## Phase 2: Set up an isolated environment

1. Create a directory for the tool at the project root: `<tool>/`.
2. Add the tool's repository as a git submodule at `<tool>/<tool>/`:
   ```bash
   git submodule add <repo_url> <tool>/<tool>
   ```
3. Create an isolated environment inside `<tool>/<tool>/`. Prefer `uv` when the repo uses it. Record the exact install command and any extra step.
4. Point the tool at the ollama server through environment variables. See `references/inspect-ollama-config.md` for the Inspect recipe, and adapt for other frameworks. Do not hardcode the server URL in scripts (see Phase 5 for the pattern).
5. Record every dependency problem and its fix. This feeds Documentation (Do1) and Education (E6).

## Phase 3: Validate on a small sample

1. Run one or two tasks first. Confirm the pipeline works end to end.
2. Confirm the dataset downloads. Confirm the model makes tool calls. Confirm the grader runs.
3. Read one full task trajectory. Confirm you can explain the score. This feeds the Education stage (E4).
4. Measure the time and tokens for one task. Use this to estimate the full run.

## Phase 4: Run the full test

1. Run the tool with each of the three ollama models as the agent model.
2. Hold the judge or grader model constant across runs for a fair comparison. Prefer a small judge model that co-resides with the agent models, to avoid VRAM thrash.
3. The ollama server has 4 GPUs. The model is sharded across all 4 GPUs, so every request flows through all 4 in sequence. Run the models sequentially, one model at a time.
   Different models contend for the same GPUs, so parallel model runs slow each other down.
   The server is configured with `OLLAMA_NUM_PARALLEL=1`, so it processes one request at a time, and additional requests queue. `OLLAMA_KEEP_ALIVE=-1` keeps models loaded indefinitely, so there is no reload overhead between requests. The context window is `OLLAMA_CONTEXT_LENGTH=65536`. Check `GET /api/ps`: if `size_vram` is less than `size`, the model spills to CPU and inference slows down.
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

1. Write `<tool>/README.md` from `templates/tool-report-template.md`. Each tool has its own directory at the project root: `<tool>/README.md` (the detailed report), `<tool>/<tool>/` (the source code submodule), and `<tool>/*.sh` or `<tool>/*.py`
   (evaluation scripts). Add an "Evaluation scripts" table in the report that lists each script, its purpose, and the result files it produces. This lets a reader link a reported number to the command that produced it.
2. In the Installation section, document every source patch applied to the submodule.
   State the file, the change, and the reason.
3. In the Installation or Usage section, tell the user which environment variables to set and state that the evaluation scripts fall back to the default server URL if unset.
4. Update the rollup `report.md` as described in "Rollup report updates" above (Comparison Table row, Scores by criterion columns).
5. Use ASD-STE100 English. Quote real commands and real output in the Test Result section.
6. For a harmful benchmark, quote sensitive prompt text only as much as the report needs.
7. Read `docs/attack-risk-coverage.md` (read-only data source). Find the tool's row in the coverage table. Use it to fill two parts of the reports:
   - In the rollup comparison table (`report.md`), fill the "Attack Vectors" cell with the V codes and canonical names (for example, "V1 (Indirect prompt injection)") and the "Security Risks" cell with the R codes and canonical names.
   - In the detailed report (`<tool>/README.md`), write the "Attack vectors and security risks" section. List each covered V and R code with a one-sentence explanation from the coverage table. End with a paragraph that lists the vectors and risks not covered.

## Notes learned from prior tools

- Inspect (`inspect_ai`) evals (AgentHarm and others) support ollama through the `OLLAMA_BASE_URL` variable and the `ollama/<model>` prefix. The tool's own README may not mention this, but the framework does.
- The Inspect ollama provider needs the `openai` package. `uv sync` does not install it by default. Run `uv pip install openai` after sync.
- `.eval` log files use zstd compression. Do not open them with the Python stdlib `zipfile`.
  Use `inspect_ai.log.read_eval_log` or `uv run inspect log dump`.
