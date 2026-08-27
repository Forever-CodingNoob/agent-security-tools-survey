# A Survey of Security Benchmarks for Agentic LLMs

This artifact consists of the assessment results for several state-of-the-art frameworks/benchmarks targeting the security of agentic LLMs, as well as scripts and instructions to carry out (hopefully) replicable experiments.  The assessments evaluate each tool's applicability in a cyber-educational scenario, with an eye to integrating them into a CTF or juice-shop-style educational platform.

## Table of Contents
+ [Setup and Installation](#Setup_and_Installation)
+ [Evaluation Environment](#Evaluation_Environment)
+ [Evaluation Workflow](#Evaluation_Workflow)
+ [Evaluation Results](#Evaluation_Results)

## Setup and Installation

Please refer to [`docs/install.md`](docs/install.md).

## Evaluation Environment

In a nutshell, we ran our experiments on [SORA-WS2](https://jgarcia.ics.uci.edu/), and LLMs used in the experiments were hosted locally by an Ollama server running on [korn](https://wiki.ics.uci.edu/doku.php/hardware:cluster:opengpu) (korn.ics.uci.edu), a node of [UCI's OpenGPU cluster](https://wiki.ics.uci.edu/doku.php/hardware:cluster:opengpu).

Detailed specs:
+ [SORA-WS2](https://jgarcia.ics.uci.edu/): 12th Gen Intel(R) Core(TM) i7-12700KF CPU (with 24 logical cores) + ~31GiB RAM 
+ Ollama: version 0.23.1, started as a Slurm job on [korn](https://wiki.ics.uci.edu/doku.php/hardware:cluster:opengpu) via the Slurm script file [`ollama.sbatch`](scripts/ollama.sbatch).
+ [korn](https://wiki.ics.uci.edu/doku.php/hardware:cluster:opengpu): AMD EPYC 9124 CPU @3Ghz (with 32 logical cores) + 4 x NVIDIA RTX 4000 Ada Generation 20GB GDDR6 GPU + 752 GB RAM

## Evaluation Workflow

(TBA)

## Evaluation Results

The results are compiled and organized to the following files:
+ a summary report for ALL tools: [`report.md`](report.md)
+ individual report for each tool: `<tool_name>/README.md`

Besides, under each `<tool_name>/` directory are also scripts that the agent used to perform full/partial evaluations.
If you are to replicate our experiments, please kindly reuse these scripts and perhaps report any issue where possible.

As a side note, all reports are written either by hand or by Claude Opus 4.6/4.8 with comprehensive human fact-checking.
