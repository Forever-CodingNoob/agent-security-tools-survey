# Attack and Risk Coverage of Agentic-LLM Security Tools

This document maps 16 agentic-LLM security tools onto the taxonomy of Xie et al., [The Attack and Defense Landscape of Agentic AI: A Comprehensive Survey](https://arxiv.org/abs/2603.11088). 
Each tool's README uses the codes defined here in its "Attack vectors and security risks" section, and the [summary report](../report.md) lists them in its comparison table.

## Table of Contents
+ [Taxonomy](#taxonomy)
    + [Attack vectors (by threat model)](#attack-vectors-by-threat-model)
    + [Security risks (by category)](#security-risks-by-category)
+ [Coverage Table](#coverage-table)
+ [Coverage Gaps](#coverage-gaps)
    + [Attack vectors with weak coverage](#attack-vectors-with-weak-coverage)
    + [Security risks with weak coverage](#security-risks-with-weak-coverage)
+ [References](#references)

## Taxonomy

The taxonomy separates two questions: an *attack vector* is the path by which an attacker's input reaches the agent, while a *security risk* is the property of the agent system that the attack exploits or the harm that results.

### Attack vectors (by threat model)

The following threat models are classified based on attackers' access to the agent at the time of attack execution rather than during the attack's development, per the SoK paper:
+ External: the attacker controls resources the agent fetches, such as web pages, documents, or tools.
+ User-level: the attacker controls part of the user input.
+ Internal: the attacker has modified a component inside the agent, such as the model or its memory.

The six attack vectors are:
- **V1 Indirect prompt injection** [External]: attacker injects malicious instructions into external resources the agent retrieves, such as web pages or documents.
- **V2 Malicious data injection** [External]: attacker injects non-prompt malicious data consumed during sensitive operations, such as malicious packages or manipulated parameter values.
- **V3 Tool poisoning and manipulation** [External]: attacker injects malicious instructions into tool names or descriptions, or malicious payloads into tool implementations.
- **V4 Direct prompt injection** [User-level]: attacker controls parts of otherwise benign inputs and appends malicious instructions to user inputs. Jailbreak templates are one instantiation.
- **V5 Model poisoning** [Internal]: attacker injects a backdoor into the LLM that activates during inference.
- **V6 Memory poisoning** [Internal]: attacker manipulates the agent's memory to inject malicious instructions or false knowledge, or leaks sensitive data from the memory.

### Security risks (by category)

The three groups are:
+ Attack surface: the entry points through which attacker-controlled data reaches the agent.
+ Model risks: weaknesses in how the model handles instructions and data.
+ Consequence risks: the resulting harm to the user, the agent, or external systems.

> [!IMPORTANT]
> According to the SoK paper, "an expanded attack surface (R1) increases entry points for attacker-controlled data, allowing malicious inputs to reach and exploit model risks (R2, R3, R4) ... Model risks then amplify consequence risks (R5, R6, R7)."


The seven security risks are:
- **R1 Heterogeneous untrusted interfaces** [Attack surface]: the system exposes multiple heterogeneous untrusted interfaces (external data sources, persistent memory, third-party tools) that serve as attack entry points.
- **R2 Wrong instruction following** [Model risk]: agent follows attacker-injected prompts instead of the intended instructions of benign users or developers.
- **R3 Unconstrained/unsafe data flow** [Model risk]: data flows freely from untrusted inputs to any output, unlike traditional systems with regulated data propagation.
- **R4 Hallucinations and model mistakes** [Model risk]: the model hallucinates or errs, and the agent acts on that content with real-world consequences.
- **R5 Private data leakage** [Consequence risk]: sensitive data across conversations, memory, credentials, and environment resources is exposed to unauthorized parties.
- **R6 Unintended/unauthorized actions and data corruption** [Consequence risk]: the agent makes irreversible state changes or modifies stored resources without authorization.
- **R7 Resource drain and denial-of-service** [Consequence risk]: attackers exploit agent autonomy to trigger costly calls, infinite loops, or excessive memory use, making the agent or external systems unusable.

## Coverage Table

| Tool | Covered Attack Vectors | Covered Security Risks |
|------|----------------------|----------------------|
| [AgentDojo](../agentdojo/README.md) | V1 Indirect prompt injection (payloads in emails, calendar, drive files, messages) | R1 Untrusted interfaces (four suites with distinct injection surfaces), R2 Wrong instruction following (measures targeted ASR for attacker goal completion), R3 Unconstrained data flow (injected data flows into safety-critical tool calls), R5 Private data leakage (exfiltrates subscriptions, IBANs, security codes), R6 Unauthorized actions (deletes files, modifies payments, sends funds to attacker), R7 Denial-of-service (DoS attacks halt task completion via refusal triggers) |
| InjecAgent | V1 Indirect prompt injection (attacker instructions embedded in retrieved external content such as notes, reviews, product descriptions, and email, across 17 user tools that return attacker-modifiable content) | R2 Wrong instruction following (measures ASR for instruction compliance), R3 Unconstrained data flow (extraction-to-transmission data stealing chain), R5 Private data leakage (two-stage pipeline extracts and transmits private data), R6 Unauthorized actions (unauthorized state-changing tool executions, such as an unauthorized $500 BankManagerPayBill payment and smart home device manipulation) |
| AgentPoison | V6 Memory poisoning (adversarial pairs injected into RAG knowledge base) | R2 Wrong instruction following (poisoned demonstrations cause adversarial target actions), R3 Unconstrained data flow (poisoned retrievals flow directly into LLM reasoning), R6 Unauthorized actions (emergency stops, patient record deletion, wrong answers) |
| [AgentHarm](../agentharm/README.md) | V4 Direct prompt injection (malicious user queries with optional jailbreak wrapper) | R2 Wrong instruction following (measures compliance rate and jailbreak effectiveness), R5 Private data leakage (tools extract credit cards, passwords, login data), R6 Unauthorized actions (ransomware, fraud, phishing, malware via multi-step tool calls) |
| [ASB](../asb/README.md) | V1 Indirect prompt injection (injection text appended to tool observation outputs), V4 Direct prompt injection (malicious instructions appended to user query), V6 Memory poisoning (malicious plans injected into ChromaDB store) | R1 Untrusted interfaces (four injection surfaces across user, tool, memory, prompt), R2 Wrong instruction following (measures ASR across 13 LLMs and four attack types), R3 Unconstrained data flow (injection in one component propagates to tool invocations), R5 Private data leakage (attacker tools exfiltrate financial and patient data), R6 Unauthorized actions (400 tools test transaction duplication, privilege escalation, tampering) |
| EIA | V1 Indirect prompt injection (malicious forms and instructions injected into webpages) | R2 Wrong instruction following (persuasive instructions mislead agent to attacker-controlled fields), R3 Unconstrained data flow (PII flows from task input through injected forms to attacker server), R5 Private data leakage (leaks the user's specific PII at up to 70% ASR, or the full user request at 16% ASR, by auto-submitting typed values to an attacker-controlled site) |
| RedCode | V4 Direct prompt injection (jailbreak prefixes and code-as-docstring bypass alignment) | R2 Wrong instruction following (low rejection rate and high ASR across code agents), R5 Private data leakage (reads /etc/passwd and sensitive system files), R6 Unauthorized actions (deletes system files, terminates processes, modifies shell config), R7 Denial-of-service (memory-leak scenario: executed code creates a large number of unfreed objects tracked via tracemalloc, ASR 71.7%) |
| ToolSword | V2 Malicious data injection (harmful texts and error-riddled payloads injected into the feedback of 18 constructed tools), V3 Tool poisoning (interchanged tool names and risky tool descriptions), V4 Direct prompt injection (malicious queries with three jailbreak methods) | R1 Untrusted interfaces (three distinct interfaces exercised: user input, tool metadata, tool return values), R2 Wrong instruction following (tool availability disrupts alignment; ASR reaches 100%), R3 Unconstrained data flow (harmful tool feedback flows unchecked to user responses), R4 Hallucinations and model mistakes (over-reliance on erroneous output; misselection from name noise), R6 Unauthorized actions (wrong tool selection causes irreversible harm in real-world systems) |
| OS-Harm | V1 Indirect prompt injection (injections in websites, documents, code files, emails, notifications), V4 Direct prompt injection (deliberate misuse instructions with optional jailbreak) | R1 Untrusted interfaces (six heterogeneous injection interfaces: websites, emails, email drafts, docx files, code comments, desktop notifications), R2 Wrong instruction following (agents comply with injected goals in 20% of cases), R3 Unconstrained data flow (credentials and files flow to attacker-controlled destinations), R4 Hallucinations and model mistakes (open-ended tasks trigger hallucinated and over-helpful behavior), R5 Private data leakage (exfiltrates passwords, SSH keys, files, task instructions), R6 Unauthorized actions (executes scripts, sets CRON persistence, deletes system files), R7 Denial-of-service (the Stop Task injection goal makes the agent abort and falsely report completion) |
| SafeArena | V4 Direct prompt injection (malicious user requests harmful web actions) | R2 Wrong instruction following (agents complete 27 to 35% of harmful requests), R6 Unauthorized actions (misinformation posts, illicit item listings, and harassment actions that change state on self-hosted WebArena-style replica websites) |
| MobileSafetyBench | V1 Indirect prompt injection (injected prompts in UI text and images via messages and posts), V4 Direct prompt injection (100 high-risk daily-scenario tasks feature a misusing user issuing harmful instructions, with refusal rates measured) | R2 Wrong instruction following (agents follow injected instructions as new user instructions; defenses ranged from 3/50 to 15/50), R3 Unconstrained data flow (untrusted message and post content flows from screen observations into actions in banking, trading, and settings apps), R5 Private data leakage (mishandles authentication codes and credit card data), R6 Unauthorized actions (injected prompts cause unauthorized stock sales, banking access, and device password change attempts) |
| BrowserART | V4 Direct prompt injection (harmful instructions with four jailbreak techniques) | R2 Wrong instruction following (ASR rises from 12% in chat to 74% in browser agent), R6 Unauthorized actions (100 harmful behaviors across interaction and content generation) |
| VPI-Bench | V1 Indirect prompt injection (visual attack prompts in rendered web pages and popups) | R2 Wrong instruction following (measures attempted rate for visually embedded malicious tasks), R5 Private data leakage (75.5% of samples involve data exfiltration, monitored in the execution environment), R6 Unauthorized actions (79.4% of samples involve unauthorized actions such as file modification and command execution) |
| HAICOSYSTEM | V4 Direct prompt injection (simulated malicious users with multi-turn adversarial prompts) | R2 Wrong instruction following (agents follow malicious simulated users; multi-turn interaction surfaces up to 3 times more safety risks than single-turn benchmarks), R4 Hallucinations and model mistakes (benign users with vague instructions trigger risks without any adversary, such as sending money to the wrong person), R5 Private data leakage (evaluation scores unauthorized privacy violations), R6 Unauthorized actions (scores intrusion, system impairment, unauthorized actions, fraud) |
| RiOSWorld | V1 Indirect prompt injection (induced text, pop-ups, phishing emails, file-embedded instructions), V2 Malicious data injection (attacker-supplied harmful files delivered through phishing links and email attachments; the risk evaluator checks whether harmful files are downloaded), V4 Direct prompt injection (user instructs harmful posts and high-risk commands) | R1 Untrusted interfaces (tests across browser, email, desktop, file system, terminal), R2 Wrong instruction following (89.8% unsafe rate; agents trust screen content unconditionally), R3 Unconstrained data flow (file-embedded commands propagate to system execution), R4 Hallucinations and model mistakes (imprecise clicks hit unintended pop-ups despite risk awareness), R5 Private data leakage (agents upload private API keys to public repositories), R6 Unauthorized actions (system sabotage, system crippling, financial fraud, illegal acts) |
| RedCodeAgent | V4 Direct prompt injection (adversarial prompts with jailbreak methods and code substitution) | R2 Wrong instruction following (measures ASR and rejection rate for risky instructions), R5 Private data leakage (scenarios test reading, copying, and listing files in sensitive directories), R6 Unauthorized actions (file deletion, reverse shells, eight malware families) |

## Coverage Gaps

The vectors and risks below are covered by few or no tools, so a curriculum built from these tools alone would leave them untaught.

### Attack vectors with weak coverage

+ **V2 Malicious data injection: 2 tools.** ToolSword injects harmful and error-riddled payloads into tool feedback. RiOSWorld delivers attacker-supplied harmful files through phishing links and attachments. Poisoned software packages that trigger supply-chain compromise receive no coverage from any tool.
+ **V3 Tool poisoning and manipulation: 1 tool.** Only ToolSword covers this, through tool name interchange and risky functional descriptions. Attacks that inject malicious payloads into actual tool implementations are not tested by any tool.
+ **V5 Model poisoning: 0 tools.** No tool tests genuine model weight backdoors. ASB's Plan-of-Thought Backdoor Attack manipulates the system prompt with trigger-activated examples, but it does not modify the model itself.
+ **V6 Memory poisoning: 2 tools.** AgentPoison and ASB cover this through RAG knowledge base poisoning and ChromaDB workflow injection. Coverage is limited to retrieval-augmented generation stores. Attacks that leak sensitive data from agent memory (the second half of the V6 definition) are not directly tested.

### Security risks with weak coverage

+ **R1 Heterogeneous untrusted interfaces: 5 tools.** AgentDojo, ASB, ToolSword, OS-Harm, and RiOSWorld exercise multiple distinct untrusted interfaces.
+ **R4 Hallucinations and model mistakes: 4 tools.** ToolSword, OS-Harm, HAICOSYSTEM, and RiOSWorld test this through fabricated tool inputs, erroneous tool selection, over-helpful behavior, vague-instruction failures, and imprecise agent actions. Package hallucination attacks, where attackers register packages with names that LLMs frequently hallucinate, receive no coverage from any tool.
+ **R7 Resource drain and denial-of-service: 3 tools.** AgentDojo tests refusal-triggering DoS injections. RedCode tests a memory-leak execution scenario. OS-Harm tests a Stop Task injection goal that aborts the task with a false completion report. Agent-level resource exhaustion through costly API call loops or infinite execution chains remains largely untested.

## References
+ Taxonomy: [The Attack and Defense Landscape of Agentic AI: A Comprehensive Survey](https://arxiv.org/abs/2603.11088)
+ Scoring scheme that uses these codes as descriptive labels: [`criteria.md`](criteria.md)
