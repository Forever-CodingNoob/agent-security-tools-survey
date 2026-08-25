# A Survey of Secuirty Benchmarks for Agentic LLMs

This artifact consists of the assessment results for several satte-of-the-art frameworks/benchmarks targeting the security of agentic LLMs, as well as scripts and instructions to carry out (hopefully) replicable experiments.  The assessments evaluate each tool's applicability in a cyber-educational scenario, with an eye to integrating them into a CTF or juice-shop-style educational platform.

## Table of Contents
+ [Setup and Installation](#Setup_and_Installation)
+ [Evaluation Environment](#Evaluation_Environment)
+ [Evaluation Workflow](#Evaluation_Workflow)
+ [Evaluation Results](#Evaluation_Results)

## Setup and Installation

Please refer to [`doc/install.md`](doc/install.md).

## Evaluation Environment

In a nutshell, we ran our experiments on [SORA-WS2](https://jgarcia.ics.uci.edu/), and LLMs used in the experiments were hosted locally by an Ollama server running on korn (korn.ics.uci.edu), a node of [UCI's OpenGPU cluster](https://wiki.ics.uci.edu/doku.php/hardware:cluster:opengpu).

Detailed specs:
+ [SORA-WS2](https://jgarcia.ics.uci.edu/): 12th Gen Intel(R) Core(TM) i7-12700KF CPU (with 24 logical cores) + ~31GiB RAM 
+ Ollama: version 0.23.1
+ [korn](https://wiki.ics.uci.edu/doku.php/hardware:cluster:opengpu): AMD EPYC 9124 CPU @3Ghz (with 32 logical cores) + 4 x NVIDIA RTX 4000 Ada Generation 20GB GDDR6 GPU + 752 GB RAM

The Ollama server runs as a Slurm job on the `opengpu.p` partition with 4 GPUs. Key settings: `OLLAMA_NUM_PARALLEL=1` (one request at a time; additional requests queue), `OLLAMA_KEEP_ALIVE=-1` (models stay loaded indefinitely), `OLLAMA_CONTEXT_LENGTH=65536`.

## Evaluation Workflow

(TBA)

## Evaluation Results

For the time being, all reports are written by Claude Opus 4.6 and 4.8 without comprehensive human fact-checking.
On the other hand, having agents carry out the evaluations does reduce the hassle of doing repetivite work, surely an efficient workflow we'll stick to for the next few days. 
In addition, the reports are susceptible to change as the current evaluation criteria, as listed in the comparison table, are to be refined and finalized.

Anyway, the results are compiled and organized in the following files:
+ a rollup report for ALL tools: [`report.md`](report.md)
+ individual report for each tool: `<tool_name>/report.md`

Besides, under each `<tool_name>/` directory are also scripts that the agent used to perform full/partial evaluations.
If you are to replicate our experiments, please kindly reuse these scripts and perhaps report any issue where possible.
