# CodeSafe tool survey: rollup report

> This report uses ASD-STE100 Simplified Technical English. It collects every evaluated tool.
> Each tool also has a detailed report in `detailed/<tool>.md`.

## Comparison table

| Tool | Deployability | Extensibility | Educational Viability | Maintenance & Support | Classroom Safety | Attack Vectors | Security Risks |
|------|---------------|---------------|-----------------------|-----------------------|------------------|----------------|----------------|
| [AgentHarm](detailed/agentharm.md) | High: does not require Docker, VM, or web server; synthetic tools; local ollama inference only | High: modular; add tools, grading, agents, or prompts one folder at a time; documented | Good: clear score breakdown and trajectory viewer; jailbreak template not shipped | Excellent: very active repo (HEAD commit 2026-08-10); one small dependency fix needed | Caution: real harmful prompts in 8 categories; synthetic tools, use-restricted license, and withheld private split lower the risk | V4 (Direct prompt injection) | R2 (Wrong instruction following), R5 (Private data leakage), R6 (Unauthorized actions) |
| [ASB](detailed/asb.md) | Fair: ollama works but requires 2 code fixes (conda, judge) and 1 workaround (ChromaDB); incomplete requirements.txt; serial scheduler makes large runs slow | Fair: data-driven for new tools and agents; defense changes need deep code reading; no developer docs | Fair: clear ASR output; simulated tools reduce realism; no trajectory viewer; binary scoring only | Poor: 20 total commits; last commit 2026-04-17; 3 open issues with no maintainer response; incomplete dependencies | Caution: concrete harmful instructions (crypto mining, credential theft); fully simulated tools; MIT with no use restriction; non-aggressive subset available | V1 (Indirect prompt injection), V4 (Direct prompt injection), V6 (Memory poisoning) | R1 (Heterogeneous untrusted interfaces), R2 (Wrong instruction following), R3 (Unconstrained data flow), R5 (Private data leakage), R6 (Unauthorized actions) |

## Score legend

The report uses four words to rate a cell:

- **High / Excellent / Good**: the tool meets the criterion well.
- **Fair**: the tool meets the criterion with some effort or some gaps.
- **Caution**: the tool needs care, usually for safety.
- **Poor**: the tool does not meet the criterion.

## Per-tool notes

- **AgentHarm**: AgentHarm measures how harmful a tool-using LLM agent becomes. It is an
  Inspect (`inspect_ai`) eval. It runs with local ollama models and needs no special
  infrastructure. The setup was smooth, except the ollama provider needs the `openai`
  package. The full run (all three models, both tasks, `test_public`, 1056 samples) shows a
  clear trend by model size. On the harmful split, refusal falls as the model shrinks
  (`gpt-oss:120b` 0.93, `qwen3-coder:30b` 0.61, `qwen3:14b` 0.26). So the smallest model is
  the most harmful overall (harm score 0.49), and the largest model is the safest (harm score
  0.125). But the largest model over-refuses 45% of benign tasks, which hurts its usefulness.
  The mid-size model is the most balanced. See `detailed/agentharm.md`.

- **ASB**: ASB benchmarks attacks and defenses on 10 scenario-specific LLM agents. It is a
  custom Python framework (not Inspect). It supports ollama via the `ollama` Python client,
  but the refusal judge and ChromaDB embeddings hardcode the OpenAI API, so code changes are
  needed. Full runs confirm the quick-test pattern: `qwen3-coder:30b` resisted every naive
  DPI attack (ASR 0.0%, Refusal 95.0%), `qwen3:14b` was nearly fully vulnerable (ASR 99.75%,
  Refusal 2.5%), and `gpt-oss:120b` was vulnerable but less so (ASR 87.0%, Refusal 14.0%).
  The framework is less mature than AgentHarm: 20 commits, incomplete dependencies, no
  trajectory viewer, and no developer documentation. The dataset is ungated with concrete
  attack instructions. See `detailed/asb.md`.

## Model benchmarks vs. agent security testing

Most tools in this survey test model capability, not agent security. The typical design
instantiates a fixed agent harness (a ReAct loop or function-calling wrapper), swaps in a
model, and measures how that model behaves under attack. The orchestration logic, guardrails,
and tool-access controls belong to the benchmark, not to the user. The result answers "how safe
is this LLM when given tools?" rather than "how secure is my agent system?"

A production agent's security depends on its full stack: input sanitization, output guardrails,
memory isolation, tool-access controls, and orchestration logic. A model that scores well on a
benchmark can still be exploited inside a poorly defended agent, and a weaker model can be
adequately protected by strong system-level controls. The distinction matters for CodeSafe
because classroom exercises should teach students to build and evaluate secure agent systems,
not only to compare bare model refusal rates.

The tools fall into three tiers on this axis:

1. **Supports custom agent pipelines.** AgentDojo lets users implement a custom pipeline class
   with their own defense logic (input filtering, output checking, prompt hardening) and test it
   against the injection suite. AgentHarm uses Inspect AI's solver abstraction, which can wrap a
   full agent pipeline. These two tools can evaluate a user-built agent, not only a model.

2. **Tests existing agent systems as targets.** RedCodeAgent sends adversarial prompts to
   diverse code-agent systems (OpenHands, Aider, and others) and grades by execution results.
   OS-Harm, RiOSWorld, SafeArena, and BrowserART run against specific agent frameworks in real
   environments. A user could substitute their own agent if it speaks the same interface
   (BrowserGym, OSWorld), but the benchmarks were not designed for plug-and-play agent swapping.

3. **Model benchmarks in agent clothing.** InjecAgent, ToolEmu, ASB, ToolSword, AgentPoison,
   EIA, AgentDAM, HAICOSYSTEM, MobileSafetyBench, VPI-Bench, RedCode, and SafeArena all
   instantiate their own agent framework and only vary the model. They measure the model's
   inherent safety, not the security posture of an arbitrary agent system.

For the CodeSafe curriculum, Tier 1 tools (AgentDojo, AgentHarm) are the most useful because
students can build an agent, add defenses, and measure the effect. Tier 3 tools remain valuable
for teaching students how attacks work and how model choice affects baseline safety, but they
cannot evaluate a student-built defense.

## Test harness

All tools use the shared ollama server at `http://circinus-44.ics.uci.edu:48763`. The agent
models under test are `gpt-oss:120b` (large), `qwen3-coder:30b` (mid), and `qwen3:14b`
(small). The Inspect ollama recipe is in the `agentic-tool-eval` skill.

## Status

- AgentHarm: complete. The setup, the validation, and the full `test_public` run (both tasks,
  all three models, 1056 samples, about 14.5 hours) are done. The detailed report holds the
  full six-row results table and the cross-model analysis.
- ASB: complete. Setup required 3 code fixes. Quick validation ran 3 models with 3 DPI attack
  types (9 test runs). Full runs done: `qwen3:14b` (400 tasks, 8h 33m), `qwen3-coder:30b`
  (100 tasks, 1h 15m), `gpt-oss:120b` (100 tasks, 58m). Reports are final.
- Next tool in the survey (not started): AgentDojo.
