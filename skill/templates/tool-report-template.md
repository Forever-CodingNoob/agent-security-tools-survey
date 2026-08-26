# <Tool name> ([repo](<repo_url>)) ([paper](<paper_url>)) ([dataset](<dataset_url>))

> Write this report in ASD-STE100 Simplified Technical English.
> Follow the format and writing style conventions in SKILL.md.
> The AgentHarm and AgentDojo READMEs are the reference examples.

## Table of Contents
+ [Summary](#summary)
+ [File Hierarchy](#file-hierarchy)
+ [Getting Started](#getting-started)
+ [Installation](#installation)
+ [Usage](#usage)
+ [Dataset](#dataset)
    + [<Subsection: splits, categories, or equivalent>](#...)
    + [Scoring](#scoring)
    + [Evaluation Trajectory](#evaluation-trajectory)
+ [Conducting Evaluation](#conducting-evaluation)
    + [Evaluation scripts](#evaluation-scripts)
    + [Experimental Settings](#experimental-settings)
    + [Performing a Full Evaluation](#performing-a-full-evaluation)
    + [Performing a Partial Evaluation](#performing-a-partial-evaluation)
+ [Experimental Results](#experimental-results)
    + [Our Results](#our-results)
    + [Execution Time](#execution-time)
    + [Our Findings](#our-findings)
+ [Criteria](#criteria)
    + [Deployability](#deployability)
    + [Extensibility](#extensibility)
    + [Maintenance & Support](#maintenance--support)
    + [Execution isolation](#execution-isolation)
    + [Content sensitivity](#content-sensitivity)
    + [Observability](#observability)
    + [Experimentability](#experimentability)
+ [Attack vectors and security risks](#attack-vectors-and-security-risks)
    + [Covered attack vectors](#covered-attack-vectors)
    + [Covered security risks](#covered-security-risks)
    + [Vectors and risks not covered](#vectors-and-risks-not-covered)
+ [References](#references)


## Summary

State in two to three sentences what the tool does, what it measures, and what framework it uses. Define any domain-specific term that the rest of the report depends on (for example, *jailbreak*, *injection task*, *attack pair*). Link to the framework and the paper inline.

License: <license>. Version tested: <version>. Package: <package>.


## File Hierarchy

This subartifact contains the following:
+ [`README.md`](README.md): this documentation
+ [`<tool>/`](<tool>/): the <tool> source code ([<org>/<repo>](<repo_url>), added as a git submodule)
+ [`run_full_benchmark.sh`](run_full_benchmark.sh): full evaluation script (<describe scope>)
+ [`run_smoke_benchmark.sh`](run_smoke_benchmark.sh): smoke test script (<describe scope>)
+ [`results/`](results/): evaluation results
    + [`<model_dir>/`](results/<model_dir>/): result files for `<model>`
+ [`your-results/`](your-results/): output directory for new evaluation runs (created by the scripts; initially empty)

## Getting Started

A numbered quick-start for a new student. Five to seven steps that go from clone to viewing one result:
1. Clone the repository. Install dependencies.
2. Set the environment variables for the ollama server (link to Installation).
3. Apply any patches.
4. Run one small task with one model.
5. Open the result (with a viewer or by reading the output file).
6. Read one trajectory. Find the tool calls and the score.
7. Change the model to compare two models.


## Installation

Give the exact commands. Record the environment tool (for example `uv` or `pip`).
Document every source patch in a lettered sub-step:
    a. **Fix: <short name>**
        Explain what fails and why. Show the before and after code.

> [!NOTE]
> State what the install does and does not require (for example, whether it needs Docker or a web server).

## Usage

Give the exact commands to run one task, a specific subset, and a full run. Show how to select the model. Show how to point the tool at the ollama server.

```bash
# <comment explaining what this command does>
<exact command>
```

Key arguments:
- `--<arg>`: <description>.

> [!TIP]
> State where the result files are stored.

If the tool supports adding custom attacks, defenses, or templates, add a subsection:

### Adding a <extension type>

Numbered steps with code examples. Each step shows what file to edit, what code to add, and how to run the evaluation with the new extension.


## Dataset

State the dataset source. Link to the dataset URL inline. State whether the data is gated or needs a token.

### <Splits, categories, or equivalent structure>

Define each partitioning dimension with a short sentence followed by a list. Use italics for new terms. Place the count table after the lists.

The dataset is partitioned into <N> *splits*:
+ `split_a`: <description>
+ `split_b`: <description>

Each split contains <N> *task types*:
+ Type A: <description>
+ Type B: <description>

| Split | Type A | Type B | ... |
|-------|--------|--------|-----|
| split_a | N | N | ... |

### Scoring

Define each metric with a `-` list. Explain what a perfect score and a zero score mean. State whether scoring is binary or graded (0.0 to 1.0).

- `metric_name`: <definition>. <How it is computed in one sentence.>

> [!NOTE]
> Cite the source file or class that implements the scoring logic.

### Evaluation Trajectory

A numbered trace of one concrete task from start to score. Show:
1. What the task asks the agent to do.
2. What tool calls the agent makes.
3. What the grading function checks.
4. What score the agent receives and why.


## Conducting Evaluation

### Evaluation scripts

| Script | Purpose | Linked results |
|--------|---------|----------------|
| `run_full_benchmark.sh` | <scope, estimated time> | `results/` |
| `run_smoke_benchmark.sh` | <scope> | (smoke test) |

### Experimental Settings

+ Ollama server (see [the rollup report](../report.md)):
    + 4 GPUs
    + `OLLAMA_NUM_PARALLEL=1`
+ Agent models:
    + `qwen3:14b` (small)
    + `qwen3-coder:30b` (mid)
    + `gpt-oss:120b` (large)
+ <Tool> version: <version>
+ Patches applied:
    1. <patch description>
+ <Any fixed experimental parameters (temperature, seed, attack name, etc.)>

### Performing a Full Evaluation

Numbered steps:
1. Run the script. Show the command. Explain what it does and where it writes results.
2. View or parse the results. Show the command.
3. Inspect an individual result. Show the command and what fields to look at.

### Performing a Partial Evaluation

Numbered steps (same structure as full, with `--limit` or subset flags).


## Experimental Results

### Our Results

State that the overall metrics are averages across all samples/pairs. Describe the table columns with a `+` list before the table.

| Model | Task Type | <metric_1> | <metric_2> | ... | Time | Tokens |
|-------|-----------|------------|------------|-----|------|--------|
| ... | ... | ... | ... | ... | ... | ... |

#### Execution Time

| Model | <phase_1> | <phase_2> | Total | Per-unit |
|-------|-----------|-----------|-------|----------|
| ... | ... | ... | ... | ... |

> [!IMPORTANT]
> Note any model that is much slower and explain why.

### Our Findings

#### <Finding group 1>

Introduce the finding with a sentence, then list the data:
+ **<Bold label>**: <explanation with numbers>.
+ **<Bold label>**: <explanation with numbers>.

#### <Finding group 2>

Same pattern.


## Criteria

For each criterion, follow this order:

### <Criterion name>

Verdict: <word> (<average>/3).

| Factor | Rating | Evidence |
|--------|--------|----------|
| <factor> | N/3 | <one sentence citing a verifiable fact> |

Reasons:
+ <rationale with evidence>.

> [!NOTE]
> <Supporting detail or file path>.

(Repeat for all seven criteria in fixed order: Deployability, Extensibility, Maintenance & Support, Execution isolation, Content sensitivity, Observability, Experimentability.)


## Attack vectors and security risks

> Taxonomy is adapted from Xie et al., "The Attack and Defense Landscape of Agentic AI"

### Covered attack vectors

- **V<N> <Canonical name>**: <one sentence explaining how this tool exercises it>.

### Covered security risks

- **R<N> <Canonical name>**: <one sentence explaining how this tool exercises it>.

### Vectors and risks not covered

Uncovered vectors:
+ <V codes with names>

Uncovered risks:
+ <R codes with names>


## References
+ Paper: [<title>](<paper_url>)
+ Original repository: [<repo_path>](<repo_url>)
+ Dataset: [<dataset_name>](<dataset_url>)
+ Framework: [<framework_name>](<framework_url>)
+ Taxonomy adapted from: [The Attack and Defense Landscape of Agentic AI: A Comprehensive Survey](https://arxiv.org/abs/2603.11088)
