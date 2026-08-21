# CodeSafe tool survey: rollup report

> This report uses ASD-STE100 Simplified Technical English. It collects every evaluated tool.
> Each tool also has a detailed report in `<tool>/report.md`.

## Comparison table

| Tool | Deployability | Extensibility | Maintenance & Support | Execution isolation | Content sensitivity | Observability | Experimentability | Attack Vectors | Security Risks |
|------|---------------|---------------|----------------------|---------------------|---------------------|---------------|-------------------|----------------|----------------|
| [AgentHarm](agentharm/report.md) | High: no Docker, VM, or web server; synthetic tools; local ollama inference only | High: modular; add tools, grading, agents, or prompts one folder at a time; documented | Excellent: very active repo (HEAD commit 2026-08-10); one small dependency fix needed | High: synthetic tools; no real actions; harm score measures tool calls against a template | High: harmful prompts in 8 categories (Hate, Sexual, Harassment); benign task subset available; withheld test_private split | Good: Inspect viewer shows full message trajectory; clear grading breakdown (tool calls, order, arguments, refusal) | Good: Inspect solver abstraction supports custom agent pipelines; jailbreak template not shipped, students must write their own | V4 (Direct prompt injection) | R2 (Wrong instruction following), R5 (Private data leakage), R6 (Unintended/unauthorized actions) |
| [ASB](asb/report.md) | Fair: ollama works but requires 2 code fixes (conda, judge) and 1 workaround (ChromaDB); incomplete requirements.txt; serial scheduler makes large runs slow | Fair: data-driven for new tools and agents; defense changes need deep code reading; no developer docs | Poor: 20 total commits; last commit 2026-04-17; 3 open issues with no maintainer response; incomplete dependencies | High: fully simulated tools; no real API calls, server connections, or transactions; tools return fixed confirmation strings | Moderate: concrete attack instructions (crypto mining, credential theft, privilege escalation); non-aggressive subset available | Fair: clear ASR output; verbose console text; no trajectory viewer; binary scoring (0 or 1); attack success is a substring match | Poor: model-swap only; no API for custom agent pipelines or defense logic | V1 (Indirect prompt injection), V4 (Direct prompt injection), V6 (Memory poisoning) | R1 (Heterogeneous untrusted interfaces), R2 (Wrong instruction following), R3 (Unconstrained/unsafe data flow), R5 (Private data leakage), R6 (Unintended/unauthorized actions) |
| [AgentDojo](agentdojo/report.md) | High: simulated in-memory tools; 3 small code fixes needed (timeout, Pydantic, InternalServerError catch); ollama via openai-compatible provider | High: extensible pipeline API for custom agents and defenses; register new attacks, suites, and injection tasks independently | Good: NeurIPS 2024; active SPYLab repo; published on PyPI (v0.1.35); 3 code fixes needed | High: in-memory Pydantic objects; tools mutate simulated state only; environment resets between runs | Low: injection templates are formulaic; language is not violent or offensive; actions described are malicious (financial fraud, data theft) but not graphic | Good: structured JSON results with full message traces; dual utility/security scoring (0.0 to 1.0); no built-in trajectory viewer | High: extensible pipeline API for custom defense logic (input filtering, output checking, prompt hardening); student can benchmark their own agent | V1 (Indirect prompt injection) | R1 (Heterogeneous untrusted interfaces), R2 (Wrong instruction following), R3 (Unconstrained/unsafe data flow), R5 (Private data leakage), R6 (Unintended/unauthorized actions), R7 (Denial-of-service) |

## Score legend

Each criterion is scored on a 1 to 3 scale per factor. The criterion average is the mean of its factor scores. For all criteria except Content sensitivity, 3 is the best outcome. For Content sensitivity, 3 means the most harmful content is present.

The verdict words map to score ranges:

| Verdict | Score range |
|---------|------------|
| High / Excellent | 2.5 to 3.0 |
| Good / Active | 2.0 to 2.4 |
| Moderate / Fair | 1.5 to 1.9 |
| Low / Poor | 1.0 to 1.4 |

### Factor rubrics

#### Deployability

| Factor | 1 | 2 | 3 |
|--------|---|---|---|
| Hardware requirements | Needs specialized hardware beyond a GPU server | Needs GPU server with extra configuration | Runs on standard hardware |
| Software dependencies | Multiple fixes or workarounds; incomplete dependency list | Mostly complete; a few fixes needed | Installs cleanly with one command or one small fix |
| API credits | Requires paid API credits | Partial local alternative | Fully local; zero API cost |
| Gated dataset access | Gated (application, token, approval wait) | Public with restrictions | Open access |
| Time to complete full eval | Over 24h per model | 2 to 24h per model | Under 2h per model |

#### Extensibility

| Factor | 1 | 2 | 3 |
|--------|---|---|---|
| Core modification required | Must modify core code to extend | Some extensions data-driven, others need core changes | All extensions through subclassing, decorators, or config |
| Extension points documented | No developer documentation | Partial documentation | Documented in code, paper, or README with examples |
| Changes scoped to one module | Changes spread across multiple files | Partially scoped | Each extension is one file or directory |

#### Maintenance & Support

| Factor | 1 | 2 | 3 |
|--------|---|---|---|
| Commit frequency | Under 50 commits; months between clusters | Moderate activity; periodic gaps | Active repository with regular commits |
| Issue responsiveness | Open issues with no response | Some responses, but delays | Active community with timely responses |
| Dependencies install cleanly | Multiple fixes or workarounds needed | One fix needed | Installs cleanly |

#### Execution isolation

| Factor | 1 | 2 | 3 |
|--------|---|---|---|
| Tool isolation level | Tools interact with real systems | Sandboxed but with some real-system access | Fully simulated, in-memory, or mock tools |

#### Content sensitivity

Higher score = more harmful content present.

| Factor | 1 | 2 | 3 |
|--------|---|---|---|
| Harmful content presence | Formulaic or benign | Concrete harmful instructions, not graphic | Real harmful text across multiple categories |

#### Observability

| Factor | 1 | 2 | 3 |
|--------|---|---|---|
| Full message sequence | Partial trace | Full trace but unstructured | Full structured trace (prompt, messages, tool calls, results) |
| Scoring breakdown | Aggregate score only | Per-task score with partial explanation | Per-task breakdown with rationale |
| Trajectory viewer | No viewer; raw output only | Basic viewer | Structured trajectory browser with message-level detail |
| Score granularity | Binary (0 or 1) | Few discrete levels | Continuous (0.0 to 1.0) |

#### Experimentability

| Factor | 1 | 2 | 3 |
|--------|---|---|---|
| API for custom pipelines | No API for custom pipelines | Limited API | Full pipeline API (subclass, plug in, run) |
| Run against own agent | Cannot plug in external agent | Possible with adaptation | Designed for user-built agents |
| Beyond model swap | Model swap only | Some extension beyond model swap | Full extension (attacks, defenses, tasks, scoring) |

## Factor scores

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
| Maintenance | Commit frequency | 3 | 1 | 3 |
| Maintenance | Issue responsiveness | 2 | 1 | 3 |
| Maintenance | Dependencies install cleanly | 1 | 1 | 2 |
| **Maintenance** | **Average** | **2.0** | **1.0** | **2.7** |
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

## Per-tool notes

- **AgentHarm**: AgentHarm measures how harmful a tool-using LLM agent becomes. It is an Inspect (`inspect_ai`) eval. It runs with local ollama models and needs no special infrastructure. The setup was smooth, except the ollama provider needs the `openai`
  package. The full run (all three models, both tasks, `test_public`, 1056 samples) shows a clear trend by model size. On the harmful split, refusal falls as the model shrinks (`gpt-oss:120b` 0.93, `qwen3-coder:30b` 0.61, `qwen3:14b` 0.26). So the smallest model is the most harmful overall (harm score 0.49), and the largest model is the safest (harm score 0.125). But the largest model over-refuses 45% of benign tasks, which hurts its usefulness.
  The mid-size model is the most balanced. See `agentharm/report.md`.

- **ASB**: ASB benchmarks attacks and defenses on 10 scenario-specific LLM agents. It is a custom Python framework (not Inspect). It supports ollama via the `ollama` Python client, but the refusal judge and ChromaDB embeddings hardcode the OpenAI API, so code changes are needed. Full runs confirm the quick-test pattern: `qwen3-coder:30b` resisted every naive DPI attack (ASR 0.0%, Refusal 95.0%), `qwen3:14b` was nearly fully vulnerable (ASR 99.75%, Refusal 2.5%), and `gpt-oss:120b` was vulnerable but less so (ASR 87.0%, Refusal 14.0%).
  The framework is less mature than AgentHarm: 20 commits, incomplete dependencies, no trajectory viewer, and no developer documentation. The dataset is ungated with concrete attack instructions. See `asb/report.md`.

- **AgentDojo**: AgentDojo evaluates prompt injection attacks on tool-calling LLM agents. It injects attacker goals into the environment data (emails, bills, messages) that the agent reads through tool calls. The benchmark scores utility (task completion) and security (injection resistance) independently. Three code fixes were needed: an OpenAI client timeout for reasoning models, a Pydantic forward reference for cached result loading, and an `InternalServerError` catch for tool-call parsing failures. The full benchmark (all 949 attack pairs, `important_instructions` attack) shows that all three models are highly vulnerable to indirect prompt injection. Combined security ranges from 17.6% to 27.0%. The utility-security tradeoff is the core finding: without explicit defense logic in the agent pipeline, prompt injection succeeds at high rates regardless of model size. AgentDojo's extensible pipeline API makes it the strongest tool for teaching defense construction. See `agentdojo/report.md`.

## Model benchmarks vs. agent security testing

Most tools in this survey test model capability, not agent security. The typical design instantiates a fixed agent harness (a ReAct loop or function-calling wrapper), swaps in a model, and measures how that model behaves under attack. The orchestration logic, guardrails, and tool-access controls belong to the benchmark, not to the user. The result answers "how safe is this LLM when given tools?" rather than "how secure is my agent system?"

A production agent's security depends on its full stack: input sanitization, output guardrails, memory isolation, tool-access controls, and orchestration logic. A model that scores well on a benchmark can still be exploited inside a poorly defended agent, and a weaker model can be adequately protected by strong system-level controls. The distinction matters for CodeSafe because classroom exercises should teach students to build and evaluate secure agent systems, not only to compare bare model refusal rates.

The tools fall into three tiers on this axis:

1. **Supports custom agent pipelines.** AgentDojo lets users implement a custom pipeline class with their own defense logic (input filtering, output checking, prompt hardening) and test it against the injection suite. AgentHarm uses Inspect AI's solver abstraction, which can wrap a full agent pipeline. These two tools can evaluate a user-built agent, not only a model.

2. **Tests existing agent systems as targets.** RedCodeAgent sends adversarial prompts to diverse code-agent systems (OpenHands, Aider, and others) and grades by execution results.
   OS-Harm, RiOSWorld, SafeArena, and BrowserART run against specific agent frameworks in real environments. A user could substitute their own agent if it speaks the same interface (BrowserGym, OSWorld), but the benchmarks were not designed for plug-and-play agent swapping.

3. **Model benchmarks in agent clothing.** InjecAgent, ToolEmu, ASB, ToolSword, AgentPoison, EIA, AgentDAM, HAICOSYSTEM, MobileSafetyBench, VPI-Bench, RedCode, and SafeArena all instantiate their own agent framework and only vary the model. They measure the model's inherent safety, not the security posture of an arbitrary agent system.

For the CodeSafe curriculum, Tier 1 tools (AgentDojo, AgentHarm) are the most useful because students can build an agent, add defenses, and measure the effect. Tier 3 tools remain valuable for teaching students how attacks work and how model choice affects baseline safety, but they cannot evaluate a student-built defense.

## Test harness

All tools use the shared ollama server at `http://korn.ics.uci.edu:48763`.
The agent models under test are `gpt-oss:120b` (large), `qwen3-coder:30b` (mid), and `qwen3:14b`
(small).
