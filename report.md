# CodeSafe tool survey: rollup report

> This report uses ASD-STE100 Simplified Technical English. It collects every evaluated tool.
> Each tool also has a detailed report in `<tool>/report.md`.

## Comparison table

| Tool | Deployability | Extensibility | Maintenance & Support | Execution isolation | Content sensitivity | Observability | Experimentability | Attack Vectors | Security Risks |
|------|---------------|---------------|----------------------|---------------------|---------------------|---------------|-------------------|----------------|----------------|
| [AgentHarm](agentharm/report.md) | High: no Docker, VM, or web server; synthetic tools; local ollama inference only | High: modular; add tools, grading, agents, or prompts one folder at a time; documented | Excellent: very active repo (HEAD commit 2026-08-10); one small dependency fix needed | High: synthetic tools; no real actions; harm score measures tool calls against a template | High: harmful prompts in 8 categories (Hate, Sexual, Harassment); benign task subset available; withheld test_private split | Good: Inspect viewer shows full message trajectory; clear grading breakdown (tool calls, order, arguments, refusal) | Good: Inspect solver abstraction supports custom agent pipelines; jailbreak template not shipped, students must write their own | V4 (Direct prompt injection) | R2 (Wrong instruction following), R5 (Private data leakage), R6 (Unintended/unauthorized actions) |
| [ASB](asb/report.md) | Fair: ollama works but requires 2 code fixes (conda, judge) and 1 workaround (ChromaDB); incomplete requirements.txt; serial scheduler makes large runs slow | Fair: data-driven for new tools and agents; defense changes need deep code reading; no developer docs | Poor: 20 total commits; last commit 2026-04-17; 3 open issues with no maintainer response; incomplete dependencies | High: fully simulated tools; no real API calls, server connections, or transactions; tools return fixed confirmation strings | Moderate: concrete attack instructions (crypto mining, credential theft, privilege escalation); non-aggressive subset available | Fair: clear ASR output; verbose console text; no trajectory viewer; binary scoring (0 or 1); attack success is a substring match | Poor: model-swap only; no API for custom agent pipelines or defense logic | V1 (Indirect prompt injection), V4 (Direct prompt injection), V6 (Memory poisoning) | R1 (Heterogeneous untrusted interfaces), R2 (Wrong instruction following), R3 (Unconstrained/unsafe data flow), R5 (Private data leakage), R6 (Unintended/unauthorized actions) |
| [AgentDojo](agentdojo/report.md) | High: simulated in-memory tools; 2 small code fixes needed (timeout, Pydantic); ollama via openai-compatible provider | High: extensible pipeline API for custom agents and defenses; register new attacks, suites, and injection tasks independently | Good: NeurIPS 2024; active SPYLab repo; published on PyPI (v0.1.35); 2 code fixes needed | High: in-memory Pydantic objects; tools mutate simulated state only; environment resets between runs | Low: injection templates are formulaic; language is not violent or offensive; actions described are malicious (financial fraud, data theft) but not graphic | Good: structured JSON results with full message traces; dual utility/security scoring (0.0 to 1.0); no built-in trajectory viewer | High: extensible pipeline API for custom defense logic (input filtering, output checking, prompt hardening); student can benchmark their own agent | V1 (Indirect prompt injection) | R1 (Heterogeneous untrusted interfaces), R2 (Wrong instruction following), R3 (Unconstrained/unsafe data flow), R5 (Private data leakage), R6 (Unintended/unauthorized actions), R7 (Denial-of-service) |

## Score legend

The report uses four rating levels:

- **High / Excellent / Good**: the tool scores well on this criterion.
- **Moderate / Fair**: the tool scores adequately, with some gaps or effort required.
- **Low**: the tool scores below expectations on this criterion.
- **Poor**: the tool does not meet the criterion.

For Content sensitivity, a higher rating means more harmful content is present. For all other criteria, a higher rating is better.

## Per-tool notes

- **AgentHarm**: AgentHarm measures how harmful a tool-using LLM agent becomes. It is an Inspect (`inspect_ai`) eval. It runs with local ollama models and needs no special infrastructure. The setup was smooth, except the ollama provider needs the `openai`
  package. The full run (all three models, both tasks, `test_public`, 1056 samples) shows a clear trend by model size. On the harmful split, refusal falls as the model shrinks (`gpt-oss:120b` 0.93, `qwen3-coder:30b` 0.61, `qwen3:14b` 0.26). So the smallest model is the most harmful overall (harm score 0.49), and the largest model is the safest (harm score 0.125). But the largest model over-refuses 45% of benign tasks, which hurts its usefulness.
  The mid-size model is the most balanced. See `agentharm/report.md`.

- **ASB**: ASB benchmarks attacks and defenses on 10 scenario-specific LLM agents. It is a custom Python framework (not Inspect). It supports ollama via the `ollama` Python client, but the refusal judge and ChromaDB embeddings hardcode the OpenAI API, so code changes are needed. Full runs confirm the quick-test pattern: `qwen3-coder:30b` resisted every naive DPI attack (ASR 0.0%, Refusal 95.0%), `qwen3:14b` was nearly fully vulnerable (ASR 99.75%, Refusal 2.5%), and `gpt-oss:120b` was vulnerable but less so (ASR 87.0%, Refusal 14.0%).
  The framework is less mature than AgentHarm: 20 commits, incomplete dependencies, no trajectory viewer, and no developer documentation. The dataset is ungated with concrete attack instructions. See `asb/report.md`.

- **AgentDojo**: AgentDojo evaluates prompt injection attacks on tool-calling LLM agents. It injects attacker goals into the environment data (emails, bills, messages) that the agent reads through tool calls. The benchmark scores utility (task completion) and security (injection resistance) independently. Two code fixes were needed: an OpenAI client timeout for reasoning models and a Pydantic forward reference for cached result loading. The reduced benchmark (105 of 949 attack pairs, `important_instructions` attack) shows that all three models are highly vulnerable to indirect prompt injection. Combined security ranges from 34.3% to 45.7%. The utility-security tradeoff is the core finding: without explicit defense logic in the agent pipeline, prompt injection succeeds at high rates regardless of model size. AgentDojo's extensible pipeline API makes it the strongest tool for teaching defense construction. See `agentdojo/report.md`.

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
