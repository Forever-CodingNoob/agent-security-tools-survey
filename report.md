# Roll-up Report

> Each tool also has a detailed report in `<tool>/README.md`.

## Comparison Table

| Tool | Deployability | Extensibility | Maintenance & Support | Execution isolation | Content sensitivity | Observability | Experimentability | Attack Vectors | Security Risks |
|------|---------------|---------------|----------------------|---------------------|---------------------|---------------|-------------------|----------------|----------------|
| [AgentHarm](agentharm/README.md) | High: no Docker, VM, or web server; synthetic tools; local ollama inference only | High: modular; add tools, grading, agents, or prompts one folder at a time; documented | High: very active repo (HEAD commit 2026-08-10); one small dependency fix needed | High: synthetic tools; no real actions; harm score measures tool calls against a template | High: harmful prompts in 8 categories (Hate, Sexual, Harassment); benign task subset available; withheld test_private split | High: Inspect viewer shows full message trajectory; clear grading breakdown (tool calls, order, arguments, refusal) | High: Inspect solver abstraction supports custom agent pipelines; jailbreak template not shipped, students must write their own | V4 (Direct prompt injection) | R2 (Wrong instruction following), R5 (Private data leakage), R6 (Unintended/unauthorized actions) |
| [ASB](asb/README.md) | Good: ollama works but requires 4 code fixes (conda fallback, judge model, per-task duration, plan retry nudge) and 1 workaround (ChromaDB); incomplete requirements.txt; serial scheduler makes large runs slow | Fair: data-driven for new tools and agents; defense changes need deep code reading; no developer docs | Poor: 20 total commits; last commit 2026-04-17; 3 open issues with no maintainer response; incomplete dependencies; a corrupted data file (`agent_task_pot_all.jsonl`) shipped unnoticed since May 2025 | High: fully simulated tools; no real API calls, server connections, or transactions; tools return fixed confirmation strings | Good: concrete attack instructions (crypto mining, credential theft, privilege escalation); non-aggressive subset available | Fair: clear ASR output; verbose console text; no trajectory viewer; binary scoring (0 or 1); attack success is a substring match; refusal judge counts plan-generation failures as refusals | Poor: model-swap only; no API for custom agent pipelines or defense logic | V1 (Indirect prompt injection), V4 (Direct prompt injection), V6 (Memory poisoning) | R1 (Heterogeneous untrusted interfaces), R2 (Wrong instruction following), R3 (Unconstrained/unsafe data flow), R5 (Private data leakage), R6 (Unintended/unauthorized actions) |
| [AgentDojo](agentdojo/README.md) | Good: simulated in-memory tools; 3 small code fixes needed (timeout, Pydantic, InternalServerError catch); ollama via openai-compatible provider | High: extensible pipeline API for custom agents and defenses; register new attacks, suites, and injection tasks independently | Good: NeurIPS 2024; active SPYLab repo; published on PyPI (v0.1.35); 3 code fixes needed | High: in-memory Pydantic objects; tools mutate simulated state only; environment resets between runs | Poor: injection templates are formulaic; language is not violent or offensive; actions described are malicious (financial fraud, data theft) but not graphic | Fair: structured JSON results with full message traces; dual utility/security scoring (0.0 to 1.0); no built-in trajectory viewer | High: extensible pipeline API for custom defense logic (input filtering, output checking, prompt hardening); student can benchmark their own agent | V1 (Indirect prompt injection) | R1 (Heterogeneous untrusted interfaces), R2 (Wrong instruction following), R3 (Unconstrained/unsafe data flow), R5 (Private data leakage), R6 (Unintended/unauthorized actions), R7 (Denial-of-service) |

## Evaluation Criteria

Each criterion is scored on a 1 to 3 scale per factor. The criterion average is the mean of its factor scores. For all criteria except Content sensitivity, 3 is the best outcome. For Content sensitivity, 3 means the most harmful content is present.

The verdict words map to score ranges:
| Verdict | Score range |
|---------|------------|
| High / Excellent | 2.5 to 3.0 |
| Good / Active | 2.0 to 2.4 |
| Moderate / Fair | 1.5 to 1.9 |
| Low / Poor | 1.0 to 1.4 |

### Factor Rubrics

#### Deployability

> How costly/easy is it to set up and run the tool?

| Factor | 1 | 2 | 3 |
|--------|---|---|---|
| Hardware requirements | Needs specialized hardware beyond a GPU server | Needs GPU server with extra configuration | Runs on standard hardware |
| Software dependencies | Multiple fixes or workarounds; incomplete dependency list | Mostly complete; a few fixes needed | Installs cleanly with one command or one small fix |
| API credits | Requires paid API credits | Partial local alternative | Fully local; zero API cost |
| Gated dataset access | Gated (application, token, approval wait) | Public with restrictions | Open access |
| Time to complete full eval | Over 24h per model | 2 to 24h per model | Under 2h per model |

#### Extensibility

> How easily can someone add new benchmark content (tasks, attacks, tools, scoring functions) to the framework?

| Factor | 1 | 2 | 3 |
|--------|---|---|---|
| Core modification required | Must modify core code to extend | Some extensions data-driven, others need core changes | All extensions through subclassing, decorators, or config |
| Extension points documented | No developer documentation | Partial documentation | Documented in code, paper, or README with examples |
| Changes scoped to one module | Changes spread across multiple files | Partially scoped | Each extension is one file or directory |

#### Maintenance & Support

> How actively is the tool maintained and supported? 

| Factor | 1 | 2 | 3 |
|--------|---|---|---|
| Commit frequency | Under 50 commits; months between clusters | Moderate activity; periodic gaps | Active repository with regular commits |
| Issue responsiveness | Open issues with no response | Some responses, but delays | Active community with timely responses |
| Dependencies install cleanly | Multiple fixes or workarounds needed | One fix needed | Installs cleanly |

#### Execution isolation

> How well are the tool's actions isolated from real systems?

| Factor | 1 | 2 | 3 |
|--------|---|---|---|
| Tool isolation level | Tools interact with real systems | Sandboxed but with some real-system access | Fully simulated, in-memory, or mock tools |

#### Content sensitivity

> To what extent does the dataset contain content that is harmful or offensive to read?

(Higher score = more harmful content present)

| Factor | 1 | 2 | 3 |
|--------|---|---|---|
| Harmful content presence | Formulaic or benign | Concrete harmful instructions, not graphic | Real harmful text across multiple categories |

#### Observability (i.e., Interpretability)

> How well can a student trace what happened in a task run and why it scored the way it did? 

| Factor | 1 | 2 | 3 |
|--------|---|---|---|
| Full message sequence | Partial trace | Full trace but unstructured | Full structured trace (prompt, messages, tool calls, results) |
| Scoring breakdown | Aggregate score only | Per-task score with partial explanation | Per-task breakdown with rationale |
| Trajectory viewer | No viewer; raw output only | Basic viewer | Structured trajectory browser with message-level detail |
| Score granularity | Binary (0 or 1) | Few discrete levels | Continuous (0.0 to 1.0) |

#### Experimentability

>  To what extent can a student plug in their own agent or defense pipeline (in lieu of merely swapping the model) and measure the effect?

| Factor | 1 | 2 | 3 |
|--------|---|---|---|
| API for custom pipelines | No API for custom pipelines | Limited API | Full pipeline API (subclass, plug in, run) |
| Run against own agent | Cannot plug in external agent | Possible with adaptation | Designed for user-built agents |
| Beyond model swap | Model swap only | Some extension beyond model swap | Full extension (attacks, defenses, tasks, scoring) |

### Factor Scores

| Criterion | Factor | AgentDojo | ASB | AgentHarm |
|-----------|--------|-----------|-----|-----------|
| Deployability | Hardware requirements | 2 | 2 | 2 |
| Deployability | Software dependencies | 2 | 1 | 3 |
| Deployability | API credits | 3 | 3 | 3 |
| Deployability | Gated dataset access | 3 | 3 | 3 |
| Deployability | Time to complete full eval | 1 | 2 | 2 |
| **Deployability** | **Average** | **2.2** | **2.2** | **2.6** |
| Extensibility | Core modification required | 3 | 2 | 3 |
| Extensibility | Extension points documented | 3 | 1 | 3 |
| Extensibility | Changes scoped to one module | 3 | 2 | 3 |
| **Extensibility** | **Average** | **3.0** | **1.7** | **3.0** |
| Maintenance | Commit frequency | 3 | 1 | 2 |
| Maintenance | Issue responsiveness | 2 | 1 | 3 |
| Maintenance | Dependencies install cleanly | 1 | 1 | 2 |
| **Maintenance** | **Average** | **2.0** | **1.0** | **2.3** |
| Execution isolation | Tool isolation level | 3 | 3 | 3 |
| **Execution isolation** | **Average** | **3.0** | **3.0** | **3.0** |
| Content sensitivity | Harmful content presence | 1 | 2 | 3 |
| **Content sensitivity** | **Average** | **1.0** | **2.0** | **3.0** |
| Observability | Full message sequence | 3 | 2 | 3 |
| Observability | Scoring breakdown | 2 | 2 | 3 |
| Observability | Trajectory viewer | 1 | 1 | 3 |
| Observability | Score granularity | 1 | 1 | 3 |
| **Observability** | **Average** | **1.75** | **1.5** | **3.0** |
| Experimentability | API for custom pipelines | 3 | 1 | 3 |
| Experimentability | Run against own agent | 3 | 1 | 3 |
| Experimentability | Beyond model swap | 3 | 1 | 3 |
| **Experimentability** | **Average** | **3.0** | **1.0** | **3.0** |

## Model benchmarks vs. agent security testing

Most tools in this survey test model capability, not agent security. The typical design instantiates a fixed agent harness (a ReAct loop or function-calling wrapper), swaps in a model, and measures how that model behaves under attack. The orchestration logic, guardrails, and tool-access controls belong to the benchmark, not to the user. The result answers "how safe is this LLM when given tools?" rather than "how secure is my agent system?"

A production agent's security depends on its full stack: input sanitization, output guardrails, memory isolation, tool-access controls, and orchestration logic. A model that scores well on a benchmark can still be exploited inside a poorly defended agent, and a weaker model can be adequately protected by strong system-level controls. The distinction matters for CodeSafe because classroom exercises should teach students to build and evaluate secure agent systems, not only to compare bare model refusal rates.

The tools fall into three tiers on this axis:

1. **Supports custom agent pipelines**:
    + AgentDojo: let users implement a custom pipeline class with their own defense logic (input filtering, output checking, prompt hardening) and test it against the injection suite. 
    + AgentHarm: use Inspect AI's solver abstraction, which can wrap a full agent pipeline
    + These two tools can evaluate a user-built agent, not only a model.

2. **Tests existing agent systems as targets**: 
    + RedCodeAgent: send adversarial prompts to diverse code-agent systems (OpenHands, Aider, and others) and grades by execution results.
    + OS-Harm, RiOSWorld, SafeArena, BrowserART: run against specific agent frameworks in real environments. 
    + A user could substitute their own agent if it speaks the same interface (BrowserGym, OSWorld), but the benchmarks were not designed for plug-and-play agent swapping.

3. **Model benchmarks in agent clothing**:
    + InjecAgent, ToolEmu, ASB, ToolSword, AgentPoison, EIA, AgentDAM, HAICOSYSTEM, MobileSafetyBench, VPI-Bench, RedCode, SafeArena: instantiate their own agent framework and only vary the model.
    + They measure the model's inherent safety, not the security posture of an arbitrary agent system.

For the CodeSafe curriculum, Tier 1 tools (AgentDojo, AgentHarm) are the most useful because students can build an agent, add defenses, and measure the effect. Tier 3 tools remain valuable for teaching students how attacks work and how model choice affects baseline safety, but they cannot evaluate a student-built defense.

## Test Harness

All tools use the shared ollama server at `http://korn.ics.uci.edu:48763`.
The agent models under test are `gpt-oss:120b` (large), `qwen3-coder:30b` (mid), and `qwen3:14b` (small).
