# Evaluating Agentic LLM Security Benchmarks for Cybersecurity Education: A Reproducible Study

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.22140262.svg)](https://doi.org/10.5281/zenodo.22140262)

This artifact consists of the assessment results for several state-of-the-art frameworks/benchmarks targeting the security of agentic LLMs, as well as scripts and instructions to carry out (hopefully) replicable experiments. The assessments evaluate each tool's applicability in a cyber-educational scenario, with an eye to integrating them into a CTF or juice-shop-style educational platform.

## Table of Contents
+ [File Hierarchy](#file-hierarchy)
+ [Setting Up Evaluation Environment](#setting-up-evaluation-environment)
    + [System Requirements](#system-requirements)
    + [Installation Guide](#installation-guide)
+ [Evaluation](#evaluation)
    + [Experimental Settings](#experimental-settings)
    + [Evaluation Workflow](#evaluation-workflow)
    + [Evaluation Results](#evaluation-results)
+ [License](#license)

## File Hierarchy

This artifact contains the following:
+ [`README.{md|html}`](README.html): this documentation
+ [`report.{md|html}`](report.html): the summary report that compares all evaluated tools, with per-criterion scores and cross-tool notes
+ [`docs/`](docs/): supporting documents
    + [`requirements.{md|html}`](docs/requirements.html): hardware and software requirements for the Ollama server and the client
    + [`install.{md|html}`](docs/install.html): step-by-step installation of the Ollama server, the models, and the tools
    + [`criteria.{md|html}`](docs/criteria.html): the scoring scheme, which adopts the BetterBench criteria and adds our Education stage
    + [`attack-risk-coverage.{md|html}`](docs/attack-risk-coverage.html): the attack-vector and security-risk taxonomy and the coverage of 16 tools
    + [`faq.{md|html}`](docs/faq.html): answers to questions about our choices
    + [`figures/`](docs/figures/): the per-stage bar charts embedded in the summary report
+ [`scripts/`](scripts/): helper scripts
    + [`ollama.sbatch`](scripts/ollama.sbatch): the Slurm script that starts the Ollama server with the settings we used
    + [`plot_stage_scores.py`](scripts/plot_stage_scores.py): draws the per-stage bar charts in `docs/figures/` from the Summary table of the summary report
+ [`agentdojo/`](agentdojo/), [`agentharm/`](agentharm/), [`asb/`](asb/): one directory per evaluated tool, each containing
    + `README.md`: the detailed report for the tool
    + `<tool>/`: the tool's source code, added as a git submodule and pinned to the commit we evaluated
    + `run_*.sh`: the evaluation scripts (full, partial, or smoke), plus tool-specific helpers such as `extract_results.py` (AgentDojo) and `rerun_judge.sh` (ASB)
    + `results/`: the result files of our evaluation
    + `your-results/`: the output directory for new runs, created by the scripts
+ [`skill/`](skill/): the agent skill (instructions and templates) used to evaluate a tool and write its report in this format, enabling agnets to add and evaluate a new tool in the same way
+ [`LICENSE`](LICENSE): the CC-BY-4.0 license of this artifact

## Setting Up Evaluation Environment

### System Requirements

Please refer to [`docs/requirements.{md|html}`](docs/requirements.html).

### Installation Guide

Please refer to [`docs/install.{md|html}`](docs/install.html).

## Evaluation

### Experimental Settings

In a nutshell, we ran our experiments on [SORA-WS2](https://jgarcia.ics.uci.edu/), and the LLMs used in the experiments were hosted locally by an Ollama server running on [korn](https://wiki.ics.uci.edu/doku.php/hardware:cluster:opengpu) (korn.ics.uci.edu), a node of [UCI's OpenGPU cluster](https://wiki.ics.uci.edu/doku.php/hardware:cluster:opengpu). The specifications of both machines are in [`docs/requirements.{md|html}`](docs/requirements.html#tested-environment).

The settings shared by all tools are:
+ Ollama server: version 0.23.1, started as a Slurm job by [`scripts/ollama.sbatch`](scripts/ollama.sbatch) with 4 GPUs, `OLLAMA_NUM_PARALLEL=1` (one request at a time, others queue), `OLLAMA_KEEP_ALIVE=-1` (models stay loaded), and `OLLAMA_CONTEXT_LENGTH=65536`.
+ Agent models under test: `qwen3:14b` (small), `qwen3-coder:30b` (mid), and `gpt-oss:120b` (large). The models were run one at a time, because they share the same GPUs.
+ Judge model: `qwen3:14b` on the same server, for the tools that use an LLM judge (AgentHarm's refusal and semantic judges, and ASB's refusal judge). It is the same for all three agent models so that the agent-model comparison is fair.
+ Tool versions, patches, and tool-specific parameters (attack, split, task subset, token limits): see the "Experimental Settings" section of each tool README.

### Evaluation Workflow

To reproduce our evaluation, or to evaluate a new model, follow these steps:
1. Check [`docs/requirements.{md|html}`](docs/requirements.html) and set up the Ollama server, pull and preload the three models, and verify the server from the client, as described in [`docs/install.{md|html}`](docs/install.html).
2. Pick a tool and install it by the "Installation" section of its README, including the source patches listed there.
3. Point the tool at your server by setting the environment variables named in the tool README (the evaluation scripts read the same variables).
4. Run the smoke test where one exists (`run_smoke_benchmark.sh` for AgentHarm and ASB) or one task by the "Getting Started" section, to confirm that the pipeline works end to end.
5. Run `run_full_benchmark.sh` for the full evaluation, or `run_partial_benchmark.sh` for a shorter one. The "Conducting Evaluation" section of each README states what each script covers and how long it took us.
6. Read the results in `<tool>/your-results/` with the method given in the "Performing a Full Evaluation" section of the README, and compare them with ours in `<tool>/results/` and the "Experimental Results" section.
7. To evaluate a new tool, ask your agent to follow the workflow in [`skill/SKILL.md`](skill/SKILL.md) and score the tool with [`docs/criteria.md|html}`](docs/criteria.html), then add its row to [`report.md`](report.md).

### Evaluation Results

The results are compiled and organized into the following files:
+ a summary report for ALL tools: [`report.{md|html}`](report.html)
+ an individual report for each tool: `<tool_name>/README.md`

Besides, under each `<tool_name>/` directory are also the scripts used to perform full and partial evaluations. If you are to replicate our experiments, please kindly reuse these scripts and report any issue where possible.

As a side note, all reports are written either by hand or by Claude Opus 4.6/4.8 with comprehensive human fact-checking.

## License
The artifact is licensed under CC-BY-4.0. See [LICENSE](./LICENSE).
