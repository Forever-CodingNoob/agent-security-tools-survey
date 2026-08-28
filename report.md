# Summary Report

> Each tool also has a detailed report in `<tool>/README.md`.

## Table of Contents
+ [Comparison Table](#comparison-table)
+ [Evaluation Criteria](#evaluation-criteria)
    + [Scores by criterion](#scores-by-criterion)
        + [Design](#design)
        + [Implementation](#implementation)
        + [Documentation](#documentation)
        + [Maintenance](#maintenance)
        + [Education](#education)
        + [Summary](#summary)
+ [Appendix](#appendix)
    + [Model benchmarks vs Agent security testing](#model-benchmarks-vs-agent-security-testing)
    + [Tool calling and output parsing](#tool-calling-and-output-parsing)

## Comparison Table

Stage scores and usability follow [`criteria.md`](docs/criteria.md) (0 to 15). Content level and score granularity are descriptive labels, not scores.

The columns are:
+ Design, Implementation, Documentation, Maintenance, Education: the five stage scores, each the mean of the applicable criteria in that stage.
+ Usability: the mean over all applicable Implementation, Documentation, and Maintenance criteria, as BetterBench defines it.
+ Content level: how explicit the harmful content in the dataset is (formulaic, concrete, or graphic).
+ Score granularity: whether a task score is binary, discrete, or continuous.
+ Attack Vectors and Security Risks: the V and R codes the tool exercises, taken from [`attack-risk-coverage.md`](docs/attack-risk-coverage.md).

| Tool | Design | Implementation | Documentation | Maintenance | Education | Usability | Content level | Score granularity | Attack Vectors | Security Risks |
|------|--------|----------------|---------------|-------------|-----------|-----------|---------------|-------------------|----------------|----------------|
| [AgentDojo](agentdojo/README.md) | 12.3 | 10.5 | 13.3 | 11.7 | 13.1 | 12.3 | formulaic | binary | V1 (Indirect prompt injection) | R1 (Heterogeneous untrusted interfaces), R2 (Wrong instruction following), R3 (Unconstrained/unsafe data flow), R5 (Private data leakage), R6 (Unintended/unauthorized actions), R7 (Denial-of-service) |
| [ASB](asb/README.md) | 10.4 | 7.0 | 6.9 | 11.7 | 10.6 | 7.4 | concrete (crypto mining, credential theft, privilege escalation) | binary | V1 (Indirect prompt injection), V4 (Direct prompt injection), V6 (Memory poisoning) | R1 (Heterogeneous untrusted interfaces), R2 (Wrong instruction following), R3 (Unconstrained/unsafe data flow), R5 (Private data leakage), R6 (Unintended/unauthorized actions) |
| [AgentHarm](agentharm/README.md) | 13.1 | 12.5 | 10.8 | 15.0 | 14.4 | 11.8 | graphic (8 categories, including Hate, Sexual, Harassment) | continuous | V4 (Direct prompt injection) | R2 (Wrong instruction following), R5 (Private data leakage), R6 (Unintended/unauthorized actions) |

## Evaluation Criteria

The scoring scheme, including a detailed rubric, is defined in [`criteria.md`](docs/criteria.md). 


### Scores by criterion

Each table below covers one stage and lists the score of every criterion per tool. The last row of each table is the stage score, and the [Summary](#summary) table collects the stage scores and usability per tool. The justification for each score is in the Criteria section of the tool's README.

#### Design

| Criterion | AgentDojo | ASB | AgentHarm |
|-----------|-----------|-----|-----------|
| (D1) Definition of tested capability or characteristic | 15 | 15 | 15 |
| (D2) Description of how tested capability translates to benchmark task | 15 | 15 | 15 |
| (D3) Description of how knowing about the tested concept is helpful in the real world | 15 | 15 | 15 |
| (D4) Description of use cases and user personas | 10 | 10 | 10 |
| (D5) Involvement of domain experts | 15 | 0 | 15 |
| (D6) Integration of domain literature | 15 | 15 | 15 |
| (D7) Description of how the score should or shouldn't be interpreted | 15 | 10 | 15 |
| (D8) Informed choice of performance metric(s) | 15 | 15 | 15 |
| (D9) Includes floors and ceilings for metric | 5 | 0 | 10 |
| (D10) Includes human performance level | n/a | n/a | n/a |
| (D11) Includes random performance level | 0 | 0 | 0 |
| (D12) Addresses input sensitivity | 10 | 15 | 15 |
| (D13) Validated automatic evaluation available | 15 | 10 | 15 |
| (D14) Explanation of differences to related benchmarks | 15 | 15 | 15 |
| **Design score** | **12.3** | **10.4** | **13.1** |

#### Implementation

| Criterion | AgentDojo | ASB | AgentHarm |
|-----------|-----------|-----|-----------|
| (I1) Availability of evaluation code | 15 | 15 | 15 |
| (I2) Script to replicate results is explicitly included | 10 | 10 | 10 |
| (I3) Accessibility of evaluation data, prompts, or dynamic environment | 15 | 15 | 15 |
| (I4) Supports evaluation of models via API calls | 15 | 15 | 15 |
| (I5) Supports evaluation of local models | 15 | 10 | 15 |
| (I6) Inclusion of a globally unique identifier or encryption of evaluation instances | 0 | 0 | 10 |
| (I7) Inclusion of 'training_on_test_set' task | 0 | 0 | 5 |
| (I8) Assess need for warnings for sensitive/harmful content | 10 | 5 | 15 |
| (I9) Release requirements specified | 10 | 0 | 15 |
| (I10) Includes build status or equivalent | 15 | 0 | 10 |
| **Implementation score** | **10.5** | **7.0** | **12.5** |

#### Documentation

| Criterion | AgentDojo | ASB | AgentHarm |
|-----------|-----------|-----|-----------|
| (Do1) Requirements file available | 15 | 10 | 10 |
| (Do2) Quick-start guide or demo code available | 15 | 10 | 15 |
| (Do3) Includes informative in-line code comments | 10 | 5 | 10 |
| (Do4) Code documentation available | 15 | 5 | 10 |
| (Do5) Documentation of test task categories & rationale | 15 | 10 | 15 |
| (Do6) Documentation of assumptions about normative properties | n/a | n/a | n/a |
| (Do7) Documentation of limitations | 15 | 0 | 15 |
| (Do8) Documentation of benchmark construction process | 15 | 15 | 15 |
| (Do9) Documentation of data collection or environment/prompt design process | 15 | 10 | 10 |
| (Do10) Documentation of evaluation metric(s) | 15 | 15 | 15 |
| (Do11) Report statistical significance of benchmark results | 15 | 0 | 0 |
| (Do12) Accepted at peer-reviewed venue | 15 | 15 | 15 |
| (Do13) Specifies applicable license | 15 | 10 | 15 |
| (Do14) Provision of a globally unique, persistent identifier | 15 | 5 | 5 |
| (Do15) Inclusion of standardized metadata (Croissant) | 5 | 0 | 10 |
| (Do16) Documentation of data sources and how the data was collected | 15 | 10 | 10 |
| (Do17) Documentation of the data preprocessing steps taken | 10 | 5 | 10 |
| (Do18) Documentation of the data annotation process | n/a | n/a | n/a |
| (Do19) Documentation of the representativeness of the data | 5 | 0 | 10 |
| (Do20) Standardized documentation | 15 | 0 | 5 |
| **Documentation score** | **13.3** | **6.9** | **10.8** |

#### Maintenance

| Criterion | AgentDojo | ASB | AgentHarm |
|-----------|-----------|-----|-----------|
| (M1) Code usability checked within the last year | 15 | 10 | 15 |
| (M2) Maintained feedback channel for users | 5 | 10 | 15 |
| (M3) Provide contact details of person responsible | 15 | 15 | 15 |
| **Maintenance score** | **11.7** | **11.7** | **15.0** |

#### Education

| Criterion | AgentDojo | ASB | AgentHarm |
|-----------|-----------|-----|-----------|
| (E1) Tool execution isolation | 15 | 15 | 15 |
| (E2) Support for user-built agents or defenses | 15 | 0 | 15 |
| (E3) Extension points for tasks, attacks, and tools | 15 | 10 | 15 |
| (E4) Run trace inspection | 10 | 10 | 15 |
| (E5) Assignment-sized evaluation | 10 | 10 | 15 |
| (E6) Fully local evaluation | 10 | 10 | 10 |
| (E7) Hardware requirement | 15 | 15 | 15 |
| (E8) Low-sensitivity subset for classroom use | 15 | 15 | 15 |
| **Education score** | **13.1** | **10.6** | **14.4** |

#### Summary

| Score | AgentDojo | ASB | AgentHarm |
|-------|-----------|-----|-----------|
| Design | 12.3 | 10.4 | 13.1 |
| Implementation | 10.5 | 7.0 | 12.5 |
| Documentation | 13.3 | 6.9 | 10.8 |
| Maintenance | 11.7 | 11.7 | 15.0 |
| Education | 13.1 | 10.6 | 14.4 |
| Usability | 12.3 | 7.4 | 11.8 |

## Appendix

### Model benchmarks vs Agent security testing

Most tools in this survey (i.e., those listed in [`attack-risk-coverage.md`](docs/attack-risk-coverage.md)) test model capability, not agent security. The typical design instantiates a fixed agent harness (a ReAct loop or function-calling wrapper), swaps in a model, and measures how that model behaves under attack. The orchestration logic, guardrails, and tool-access controls belong to the benchmark rather than the user. Thus, what the result answers is "how safe is this LLM when given tools?" rather than "how secure is my agent system?".

On the other hand, a production agent's security depends on its full stack, including input sanitization, output guardrails, memory isolation, tool-access controls, and orchestration logic. **A model that scores well on a benchmark can still be exploited inside a poorly defended agent**, and a weaker model can be adequately protected by strong system-level controls.

The tools fall into three tiers on this axis:
1. **Supports custom agent pipelines**:
    + These tools can evaluate a **user-built** agent, not only a model.
    + Examples: **AgentDojo**, **AgentHarm**.
2. **Tests existing agent systems as targets**: 
    + These tools send adversarial prompts to diverse code-agent systems in the wild and grade by execution results. A user could substitute their own agent if it speaks the same interface, but the benchmarks were not designed for plug-and-play agent swapping.
    + Examples: RedCodeAgent, OS-Harm, RiOSWorld, SafeArena, BrowserART. 
3. **Model benchmarks in agent clothing**:
    + These tools measure the model's inherent safety by instantiating their own agent framework and only allows swapping the model. They do not measure the security of an **arbitrary** agent system.
    + Examples: InjecAgent, ToolEmu, **ASB**, ToolSword, AgentPoison, EIA, AgentDAM, HAICOSYSTEM, MobileSafetyBench, VPI-Bench, RedCode, SafeArena.

### Tool calling and output parsing

The three tools use the same ollama server, but they differ in who parses the model's tool calls. This is why plan-format failures appear only in ASB (see the [full-run callout](asb/README.md#full-run-naive-dpi-all-400-attacker-tools-all-3-models) in the ASB README).
+ **AgentDojo and AgentHarm** pass the tool schemas in the `tools` field of the request. ollama renders them through the model's chat template and parses the model's native tool-call tokens into structured `message.tool_calls` objects, so the harness never parses free text. A malformed call surfaces as an HTTP 500 (see [Affected tasks](agentdojo/README.md#affected-tasks)) or as a tool error message.
+ **ASB** never sends `tools`. It describes the expected JSON format in the prompt text and receives only `message.content`, a plain string. Its own `parse_json_format` (`aios/llm_core/llm_classes/base_llm.py`) searches the string for JSON and returns `'[]'` when it finds none, which counts as a failed plan and, after 10 retries, as an empty trajectory that the judge tends to label as a refusal.

As a result, ASB's ASR and RR for a model with many plan failures measure **format compliance** first and resistance second.
