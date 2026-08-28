# Evaluation Rubric

This document defines how we score an agentic-security tool. It adopts the assessment framework of BetterBench ([paper](https://arxiv.org/abs/2411.12990), [methodology](https://betterbench.stanford.edu/methodology.html)) for the four lifecycle stages that BetterBench scores, and adds a fifth stage, *Education*, for the concerns of (1) an instructor who lets students run the tool and build defenses against it and (2) building a security educational platform on agentic LLMs.

## Table of Contents
+ [Scale and aggregation](#scale-and-aggregation)
+ [BetterBench stages: Design, Implementation, Documentation, and Maintenance](#betterbench-stages-design-implementation-documentation-and-maintenance)
    + [Design (14 criteria)](#design-14-criteria)
    + [Implementation (10 criteria)](#implementation-10-criteria)
    + [Documentation (20 criteria)](#documentation-20-criteria)
    + [Maintenance (3 criteria)](#maintenance-3-criteria)
+ [Our stage: Education](#our-stage-education)
    + [Education (8 criteria)](#education-8-criteria)
+ [References](#references)

## Scale and aggregation

Every criterion is scored on BetterBench's discrete levels, with BetterBench's meanings:
+ 0: neither acknowledged nor addressed
+ 5: acknowledged but not addressed (the developers state the need or the gap without meeting it)
+ 10: partially addressed
+ 15: fully addressed
+ n/a: not relevant to this benchmark (excluded from every average)

Source of judgements:
+ For *Design*, *Implementation*, *Documentation*, and *Maintenance*, the evidence is material published by the tool's developers (paper, website, repository), as BetterBench prescribes. Each criterion row cites the section, heading, or path that supports the score.
+ For the *Education* stage, the evidence is our own run of the tool (measured times, result files, trajectories) in addition to published material.

Our aggregational scoring follows BetterBench:
+ A *stage score* is the mean of all criteria in that stage, excluding any criteria scored as "n/a".
+ The *usability score* is the **criterion-count-weighted** mean of the *Implementation*, *Documentation*, and *Maintenance* stage scores, which equals the plain mean over all applicable criteria in those three stages. *Design* is reported separately.
+ The *Education* stage is reported as its own score and is not folded into usability, so the four BetterBench stage scores of a tool stay comparable with the scores that BetterBench publishes for other benchmarks.



## BetterBench stages: Design, Implementation, Documentation, and Maintenance

The criteria below are copied verbatim from the BetterBench methodology page.

> [!NOTE]
> Criteria that will usually be n/a for agent-security benchmarks with generated data are D10 (human performance level), Do6 (normative properties), and Do18 (data annotation process).

### Design (14 criteria)

#### D1. Definition of tested capability or characteristic

Explanation: The benchmark developers mention and define what underlying capability or characteristic of a model is supposed to be tested with the benchmark.

Justification: Defining the objective of the benchmark is necessary for clarity in its design. It also helps users determine if the benchmark aligns with their specific application needs and ensures that users and developers have a shared understanding of the concept being evaluated, facilitating consistent interpretation of results.

Points:
+ 0: Tested concept, capability, or characteristic not explicitly mentioned.
+ 5: Tested concept explicitly mentioned and need for definition acknowledged, but definition not provided.
+ 10: Tested concept, capability, or characteristic explicitly mentioned but not defined.
+ 15: Tested concept, capability, or characteristic explicitly mentioned and defined.

#### D2. Description of how tested capability or concept translates to benchmark task

Explanation: The benchmark developers describe how the tested capability or characteristic translates to the task implemented in the benchmark/the task the model is tested on in the benchmark.

Justification: Clearly explaining this translation ensures that the benchmark tasks accurately reflect the intended tested capabilities and concepts, providing valid assessment results.

Points:
+ 0: No description of how the tested capability or concept translates to the benchmark task.
+ 5: Acknowledgement that not describing how the tested capability or concept translates to the benchmark task is an issue, but no description provided.
+ 10: Description of how tested capability or concept translates to benchmark tasks provided for some but not all tasks.
+ 15: Description of how tested capability or concept translates to benchmark tasks provided for all tasks.

#### D3. Description of how knowing about the tested concept is helpful in the real world

Explanation: The developers describe why it is useful to know about the tested capability in the real world.

Justification: This description helps users understand the practical value of the benchmark, demonstrating how the tested capability impacts real-world applications and use cases.

Points:
+ 0: No description of how knowing about the tested concept is helpful in the real world.
+ 5: Acknowledgement that not describing how knowing about the tested concept is helpful in the real world is an issue, but no description provided.
+ 10: Limited description of how knowing about the tested concept is helpful in the real world.
+ 15: Full description of how knowing about the tested concept is helpful in the real world.

#### D4. Description of use cases and user personas for the benchmark

Explanation: A use case for an AI benchmark involves specifying a scenario in which the AI system will be evaluated. This scenario should include the cultural and geographic context and the type of interactions between humans and models, if applicable. Additionally, user personas should be defined to represent the different types of users that might interact with the AI system, if applicable.

Justification: Use cases set the context and scope of the benchmark. User personas outline an understanding of the different types of interactions the benchmark developers anticipate the tested AI system to be used in, e.g., ranging from typical users to those with specific challenges or malicious intent. This approach ensures that the design of the benchmark is closely related to real-world applications and that it's effective across diverse scenarios.

Points:
+ 0: The benchmark does not include any description of use cases or user personas.
+ 5: The benchmark acknowledges the importance of use cases or user personas but does not explicitly formulate or describe them.
+ 10: The benchmark provides a partial description of use cases or user personas.
+ 15: The benchmark fully describes use cases and user personas, specifying the cultural and geographic context, types of human-model interactions (if applicable), and representing different user types that might interact with the AI system (if applicable).

#### D5. Involvement of domain experts

Explanation: Domain expert(s) who have a professional background or research experience in the concept to be tested are either co-authors of the paper, or were involved in the benchmark design process, i.e., the paper makes clear how they obtained the expertise and how that informed the benchmark design.

Justification: Involving domain experts ensures that the benchmark design is informed by deep, specialized knowledge, increasing its validity and relevance. This expertise helps to create tasks that accurately assess the targeted capabilities and align with real-world scenarios.

Points:
+ 0: None of the authors has a background in the benchmark domain and no external experts were consulted during the design process.
+ 5: The benchmark mentions domain experts but doesn't specify any further details.
+ 10: The benchmark mentions that domain experts were consulted but not how their insights influenced the benchmark design.
+ 15: At least one of the co-authors has a professional or academic background in the benchmark domain or the benchmark specified how external experts were consulted and how that influenced the design process.

#### D6. Integration of domain literature

Explanation: The developers cite domain literature in the background section and describe how insights from this literature informed the design of their benchmark or cite relevant domain literature in the benchmark design process.

Justification: By consulting domain-specific literature, benchmark developers can ensure that the tasks and evaluation criteria they include are representative and aligned with the current state of knowledge in the field. This literature often contains valuable insights into best practices, established methodologies, and proven approaches for evaluating the tested concept, which can be incorporated into the benchmark design to enhance its reliability.

Points:
+ 0: The benchmark does not reference domain-specific literature.
+ 5: The benchmark mentions the need to integrate domain literature but did not address it in the background section or design process.
+ 10: The benchmark references domain literature in the background or related work section but does not describe how that domain literature informed the benchmark design process.
+ 15: The benchmark references domain literature throughout the paper and describes how that domain literature informed the benchmark design process.

#### D7. Description of how benchmark score should or shouldn't be interpreted/used

Explanation: The benchmark developers provide information about what benchmark users can and cannot take away from the benchmark score.

Justification: Clarifying the interpretation of benchmark scores prevents misuse and misinterpretation, ensuring that users draw accurate conclusions about a model's performance. This guidance helps users apply the scores appropriately within their specific contexts, and understand if the benchmark can be used to assess a model for their desired application context.

Points:
+ 0: The benchmark does not comment on how the benchmark scores should or shouldn't be interpreted.
+ 5: The benchmark acknowledges that the benchmark scores need to be interpreted but gives no guidance with respect to how or how not to do that.
+ 10: The benchmark describes how scores should or shouldn't be interpreted or used, but not both.
+ 15: The benchmark describes how scores should and shouldn't be interpreted or used.

#### D8. Informed choice of performance metric(s)

Explanation: The developers describe how the performance metric for the defined benchmark task should be interpretable, meaningful, and standard for the task that's being evaluated. If a non-standard metric is selected, they describe their rationale for choosing a non-standard metric.

Justification: The metric should be easily understood by the reader to build their own opinion about the model's capabilities, given the benchmark score. If a non-standard metric is used, an explanation is necessary to clarify its relevance and ensure that users can accurately interpret the results.

Points:
+ 0: The benchmark does not mention an evaluation metric or does not explain the choice of metric.
+ 5: The benchmark acknowledges the need for an informed metric choice but does not justify their metric choice.
+ 10: The benchmark provides an explanation for the choice of some but not all of their metrics.
+ 15: The benchmark provides an explanation for the choice of all of their metrics.

#### D9. Includes floors and ceilings for metric

Explanation: The benchmark provides clear floors and ceilings for the metric(s) it uses.

Justification: Establishing clear floors and ceilings for metrics ensures that users have a reference point for understanding model performance. It helps users understand if a benchmark is already saturated or if progress can be made on the task. This also allows benchmark developers to decide when a benchmark should be retired.

Points:
+ 0: The benchmark doesn't provide any floors or ceilings.
+ 5: Floors and ceilings are shown in the results figure but not explicitly mentioned in the text.
+ 10: The benchmark provides floors and ceilings for some but not all evaluation metrics.
+ 15: The benchmark provides floors and ceilings for all evaluation metrics.

#### D10. Includes human performance level

Explanation: The benchmark explicitly states human performance measured on the benchmark task. It also explains how human performance was measured and if this was the performance of an average or expert group of humans. The benchmark notes if measuring human performance is not possible on the benchmark task and why.

Justification: Including human performance on a benchmark allows the reader to put the model's performance into perspective and allows for a better interpretability of the benchmarking score.

Points:
+ 0: The benchmark does not state human performance and does not explain why this isn't applicable here.
+ 5: The benchmark mentions human performance in passing but does not provide a measurement or explanation.
+ 10: The benchmark states human performance but does not explain how it was obtained.
+ 15: The benchmark states human performance and explains how it was obtained.

#### D11. Includes random performance level

Explanation: The developers explicitly states the random performance measured on the benchmark.

Justification: By establishing a baseline performance level achieved through random guessing, generation, or selection, benchmark users can better understand the extent to which a model's performance stems from its inherent capabilities, rather than mere chance or the benchmark's design and especially metric choices. This random performance level serves as a reference point, allowing for a clearer assessment of the model's true effectiveness in tackling the specific task at hand.

Points:
+ 0: The benchmark does not state random performance and does not explain why this isn't applicable here.
+ 5: The benchmark mentions random performance but does not provide quantitative random performance on the benchmark task(s).
+ 10: The benchmark states random performance for some but not all tasks.
+ 15: The benchmark states random performance for all tasks.

#### D12. Addresses input sensitivity

Explanation: The benchmark contains multiple input variations with the same semantic meaning/intended to elicit the same response or output by the tested model. The developers describe all relevant details such as how many different variations were tested per prompt, and how the variations were designed. For language models, this would mean including a variety of semantically (but not syntactically) equivalent prompts to combat prompt sensitivity. For computer vision models, this could mean inputting a normal, a blurred, and a cropped version of the same image, etc.), while for reinforcement learning, this could mean measuring the sensitivity of learned policies to input features.

Justification: Addressing input sensitivity in a benchmark ensures that the model's performance is consistent across semantically equivalent inputs, thus validating its robustness. Including multiple variations per input and detailing their design allows for inspection and replicable evaluation of the model's capabilities. This serves the goal of approximating intrinsic model capabilities or harms better rather than just measuring "an artifact" of your input.

Points:
+ 0: The benchmark does not mention or address input sensitivity.
+ 5: The benchmark mentions the issue of input sensitivity but does not describe experiments to test for it.
+ 10: The benchmark includes some input variations with the same semantic meaning but lacks thorough descriptions or details on the number of variations and their design.
+ 15: The benchmark contains multiple input variations with the same semantic meaning, providing detailed descriptions of all relevant details such as the number of variations per prompt and how they were designed.

#### D13. Validated automatic evaluation available

Explanation: Evaluating a model against a benchmark does not require human evaluation in the process and the quality of the automated evaluation is validated (if applicable, e.g., in the case of FM-based evaluations).

Justification: Requiring human feedback to evaluate performance on a benchmark will significantly limit the scalability of the benchmark and potentially introduce biases from the human evaluators themselves. In addition, this may require an IRB for researchers, and will be more costly than an automatic evaluation, creating "major barriers to entry".

Points:
+ 0: The benchmark does not provide any form of automatic evaluation and relies entirely on human evaluation.
+ 5: The benchmark mentions the benefits of automatic evaluation but provides no none or limited automatic valuation.
+ 10: The benchmark includes an automatic evaluation method but does not offer any validation.
+ 15: The benchmark includes an automatic evaluation method and describes how it was validated as well as the results of the validation.

#### D14. Explanation of differences to related benchmarks

Explanation: The benchmark developers explain how their benchmark fills a gap compared to existing benchmarks or how it expands on existing benchmarks or their tested concepts.

Justification: Benchmark developers demonstrate the added value and relevance of the new benchmark, justifying its necessity by addressing specific gaps in existing benchmarks or by expanding on saturated benchmarks. This allows users to better understand the differences between related benchmarks and determine which one to use for their specific evaluation context.

Points:
+ 0: The benchmarks do not explain any differences or relevance to existing benchmarks.
+ 5: The benchmark briefly mentions existing benchmarks but provides no explanations of differences or added value.
+ 10: The benchmark provides an explanation of how it fills a gap or expands on existing benchmarks for some but not all mentioned related benchmarks.
+ 15: The benchmark provides an explanation of how it fills a gap or expands on existing benchmarks for all mentioned related benchmarks.

### Implementation (10 criteria)

#### I1. Availability of evaluation code

Explanation: The benchmark developers make the code available for others to evaluate their own models against the benchmark, e.g., as part of a GitHub repository.

Justification: Without access to the benchmarking procedure itself, the benchmark cannot be scrutinized by external parties to verify its reliability and adequacy, nor can it be utilized for independent evaluations and comparisons by benchmark users. In addition, if benchmark users have to write their evaluation code from scratch, it's more likely that seemingly minor implementation details affect the measured performance, hindering a fair comparison.

Points:
+ 0: The evaluation code is not publicly available.
+ 5: The benchmark mentions the availability of evaluation code but does not provide access to it.
+ 10: The evaluation code is publicly available for some metrics described by the benchmark.
+ 15: The evaluation code is publicly available for all metrics described by the benchmark.

#### I2. Script to replicate results is explicitly included

Explanation: The benchmark developers give access to the input, output, and evaluation code, as well as all other necessary information (e.g., hyperparameters or random seed set) that they used to create the initial benchmarking results presented in the paper.

Justification: Providing access to the input, output, and code allows for transparency and reproducibility of the reported results, fostering trust into the benchmark, and contributing to overcome the current reproducibility crisis in AI/ML research.

Points:
+ 0: [No description provided] (the BetterBench page gives no text for this level, so by the scale definition 0 means the criterion is neither acknowledged nor addressed)
+ 5: The issue of result replicability is mentioned in the benchmark paper but not addressed.
+ 10: A script to reproduce some results in the benchmark paper is available.
+ 15: A script to reproduce all results in the benchmark paper is available.

#### I3. Accessibility of evaluation data, prompts, or dynamic environment

Explanation: The benchmark developers make the evaluation data, prompts, or the data/environment generation mechanism accessible. These do not have to be made public in order to earn full points (if contamination is a concern, for example), but some access to it for evaluation purposes, e.g., by hosting it privately on Hugging Face, needs to be possible.

Justification: Without any accessibility of the evaluation data, prompts, or environment generation mechanism, a benchmark cannot be used.

Points:
+ 0: No access to evaluation data, prompts, or data/environment generation mechanism is provided.
+ 5: The existence of evaluation data, prompts, or data/environment generation mechanism is mentioned, but no concrete access is provided.
+ 10: Partial access to evaluation data, prompts, or data/environment generation mechanism is provided, allowing for limited evaluation.
+ 15: Full access to evaluation data, prompts, or data/environment generation mechanism is provided, enabling comprehensive evaluation.

#### I4. Supports evaluation of models via API calls

Explanation: The benchmark developers allow the benchmark evaluation of models via API access, if applicable.

Justification: This criteria is dependent on the subfield. In NLP, for example, closed-source models such as GPT-4 are oftentimes only accessible via API. Without support for API evaluation, they cannot be evaluated, which is especially problematic if such models are the state-of-the-art models in the field.

Points:
+ 0: The benchmark does not support evaluation of models via API calls.
+ 5: The benchmark mentions the possibility of API evaluation but does not provide concrete implementation details.
+ 10: The benchmark supports evaluation of models via one API.
+ 15: The benchmark supports evaluation of models via two or more APIs to different models.

#### I5. Supports evaluation of local models

Explanation: The benchmark developers implement code to support the evaluation of local models without API access.

Justification: Some model developers only host their models locally. A benchmark should support the evaluation of those to allow for a wide variety of models to be evaluated against the benchmark.

Points:
+ 0: The benchmark requires users to write their own code to evaluate a local model.
+ 5: The benchmark mentions that local evaluation should be possible but doesn't provide corresponding code.
+ 10: The benchmark provides minimal support for local model evaluation, requiring significant user effort.
+ 15: The benchmark provides full support for local model evaluation with user-friendly code.

#### I6. Inclusion of a globally unique identifier or encryption of evaluation instances

Explanation: Benchmark developers include a globally unique identifier (GUID) or canary string in the main public evaluation code and all public evaluation prompt or data files. Alternatively, they encrypt the test data files and make the key public.

Justification: Including a GUID in relevant (sub-)repositories, public code and data repositories can support the identification of data contamination in models, either by allowing model developers to filter out the evaluation data out of large amounts of web-scraped data or by allowing benchmark developers to identify which model developers trained on their data and hence have created models that potentially perform better than they should on the benchmark. Encrypted test data files prevent non-adversarial crawling of such data; however, some advise against "using standard obfuscation or compression methods that are not key-protected, since some crawling systems include pipelines of automatic decompression or deobfuscation."

Points:
+ 0: The benchmark does not include a GUID or encryption of evaluation instances.
+ 5: The benchmark acknowledges the risk of contamination but does not address it.
+ 10: The benchmark partially implements a GUID or encryption, but not consistently across all relevant files.
+ 15: The benchmark consistently includes a GUID or encryption across all relevant files and repositories.

#### I7. Inclusion of 'training_on_test_set' task

Explanation: The benchmark includes a task to identify if the model was trained on the benchmark data.

Justification: Public benchmarks face the challenges that their evaluation data may be web-scraped and used to train a model. A 'training_on_test_set' task can serve as a "post-hoc diagnosis of whether [...benchmark] data was used in model training."

Points:
+ 0: The benchmark does not include a 'training_on_test_set' task.
+ 5: The benchmark mentions the possibility that models were trained on its data but does not provide a way to check it.
+ 10: The benchmark includes a partial or limited implementation of a 'training_on_test_set' task that only tests for part of the data used.
+ 15: The benchmark includes a comprehensive 'training_on_test_set' task.

#### I8. Assess need for warnings for sensitive/harmful content

Explanation: Benchmark developers explicitly mention in the paper if the evaluation tasks or the expected output may contain sensitive or harmful content. If they do not anticipate sensitive/harmful content in either case, they should explicitly state that.

Justification: By explicitly stating the presence of sensitive or harmful content and issuing appropriate warnings, developers help users make informed decisions and take necessary precautions. Even if developers do not expect sensitive or harmful content, if they state that, they showcase to the benchmark users that they actually thought about the possibility. Otherwise, users couldn't be sure if the input or output doesn't contain problematic content or if the developers just forgot to include a warning.

Points:
+ 0: The benchmark does not mention that they checked for the presence or absence of sensitive/harmful content in the evaluation tasks or expected output.
+ 5: The benchmark mentions the general possibility of sensitive/harmful content but does not provide clear statements or warnings.
+ 10: The benchmark explicitly states the presence or absence of sensitive/harmful content for either the evaluation tasks or the expected output.
+ 15: The benchmark explicitly states the presence or absence of sensitive/harmful content for both the evaluation tasks and the expected output.

#### I9. Release requirements specified

Explanation: Benchmark developers specify rules for benchmark users to "ensure the integrity of test results". While not all benchmark developers will be able to enforce the release requirements, they should at least specify them. One example is: "1. Publishers do not train directly on or against the benchmark dataset and retract any reported results if and when benchmark data is found to have been in training data. 2. Techniques that are likely to increase the test performance without a commensurate increase in safety factor are discouraged and may result in benchmark exclusion. [...]"

Justification: Written terms of use can help to set expectations and have a foundation to address subsequent contamination or intentional gamification attempts of the benchmark. Potential options they could mention in case of release requirement breaches are, e.g., "publishing public statements correcting the public record" or "resulting in the [model] being permanently banned from the benchmark"; however, we will not assess the enforcement ability or potential listed sanctions as part of this criteria, just the statement of release requirements.

Points:
+ 0: The benchmark does not specify any release requirements for benchmark users.
+ 5: The benchmark briefly mentions the issue of potential gameability or misuse by benchmark users but does not provide specific details.
+ 10: The benchmark states dos and don'ts how to use the benchmark but does not specify these as requirements for use.
+ 15: The benchmark provides a set of release requirements for benchmark users.

#### I10. Includes build status or equivalent

Explanation: A build status is a feature, typically implemented as a GitHub Action, that indicates whether the most recent build of the benchmark was successful. It should be implemented for the benchmark's evaluation code. It verifies that the code is running correctly after the latest commit.

Justification: A passing build status signifies that the main evaluation code was usable at the latest commit. Including a build status or equivalent can help to ensure the reliability and usability of the evaluation code. It allows benchmark users to quickly determine if the code is functioning as intended, saving time and effort in identifying potential issues.

Points:
+ 0: The benchmark neither references nor implements any form of build status or equivalent.
+ 5: The benchmark mentions the need for working evaluation code but does not implement it in any meaningful way.
+ 10: The benchmark partially implements a build status or equivalent by providing the information in a less accessible manner.
+ 15: The benchmark fully implements a build status or equivalent, clearly displaying the status of the most recent build and providing easy access to the information.

### Documentation (20 criteria)

#### Do1. Requirements file available

Explanation: A requirements or environment file, or equivalent is available.

Justification: Ease of use is a key criteria for benchmark adoption. Providing a requirements file allows for the quick installation of relevant packages at the correct versions, e.g., within a virtual environment, to use the evaluation code.

Points:
+ 0: No requirements file or equivalent is provided.
+ 5: A requirements file is mentioned but not provided.
+ 10: A requirements file is provided but may be missing some dependencies or versions.
+ 15: A complete and accurate requirements file specifying all necessary dependencies and versions is provided.

#### Do2. Quick-start guide or demo code available

Explanation: The benchmark developers make a quick start guide or demo available that walks step-by-step through how the benchmark can be used.

Justification: Similar to the criteria above, ease of use is a key criteria for benchmark adoption. Providing a quick-start guide takes away any guesswork on the user side and allows them to directly set up and use the benchmark without spending extra time on setup issues.

Points:
+ 0: No quick-start guide or demo code is provided.
+ 5: A quick-start guide or demo code is mentioned but not provided.
+ 10: A quick-start guide or demo code is provided but may be missing some steps or details.
+ 15: A comprehensive, step-by-step quick-start guide or demo code is provided.

#### Do3. Includes informative In-line code comments

Explanation: In-line code comments state the purpose, inputs, outputs, and functionality of each code segment in all files relevant for the benchmark evaluation.

Justification: In-line documentation of code enhances clarity, understanding, and reproducibility. It facilitates collaboration, maintainability, and makes debugging easier for benchmark developers and users, should that be necessary.

Points:
+ 0: No in-line code comments are provided.
+ 5: In-line code comments are sparse and do not adequately explain the purpose, inputs, outputs, or functionality of the code.
+ 10: Informative in-line code comments are present for most of the code but may be lacking in detail or clarity for some code segments.
+ 15: Comprehensive and informative in-line code comments are provided for all relevant code segments, clearly explaining their purpose, inputs, outputs, and functionality.

#### Do4. Code documentation available

Explanation: A full documentation of the repository and code it entails is publicly available. This includes, for example, an overview of the folder structure, the files in the repo, an explanation of functions in the repo.

Justification: Detailed documentation of code enhances clarity, understanding, and reproducibility. It facilitates collaboration, maintainability, and makes debugging easier for benchmark developers and users, should that be necessary.

Points:
+ 0: No code documentation is provided.
+ 5: Code documentation is mentioned but not provided.
+ 10: Code documentation is minimal or incomplete, lacking important details about the repository structure and functions.
+ 15: Comprehensive code documentation is provided, including a clear overview of the folder structure, files in the repo, and detailed explanations of all relevant functions.

#### Do5. Documentation of test task categories & rationale

Explanation: The benchmark developers define the tasks or task categories a model is tested on and describe the rationale for choosing the tasks or task categories. The rationale should explain how these tasks are relevant to the benchmark's objectives, what they aim to measure, and why they are important for evaluating the concept or capability to be tested.

Justification: Documenting test tasks is essential for transparency and for allowing public scrutiny of the benchmark. The rationale provides insight into the selection process, demonstrating that the tasks are not arbitrary but are carefully chosen to reflect real-world applications and user needs. Both help users decide if the benchmark is adequate for their evaluation contexts.

Points:
+ 0: No documentation of test task categories or rationale is provided.
+ 5: Test task categories are mentioned but they are neither defined in detail and a rationale for their selection is missing or inadequate.
+ 10: Test task categories are defined, but the rationale for their selection is not provided.
+ 15: Test task categories are clearly defined, and a comprehensive rationale is provided, explaining their relevance to the benchmark's objectives, what they measure, and their importance for evaluating the targeted concept or capability.

#### Do6. Documentation of assumptions about normative properties

Explanation: If the benchmark measures properties that vary across cultural contexts (e.g., politeness), then normative assumptions are explicitly stated. The benchmark developers clearly define the cultural context and values that the benchmark adheres to, explaining how the measured properties are conceptualized and operationalized within the benchmark.

Justification: By explicitly stating normative assumptions, the authors provide transparency about the cultural framework and values that guide the benchmark's design and evaluation criteria, which can subsequently ensure cultural sensitivity and mitigate potential biases. It also facilitates informed decision-making for users of benchmarks, specifically for culture-dependent use cases they're interested in, such as measuring toxicity or bias, for example.

Points:
+ 0: No documentation of normative assumptions is provided, even though the benchmark measures culturally-dependent properties.
+ 5: The potential influence and importance of cultural context on the benchmark is acknowledged but normative assumptions aren't stated.
+ 10: Normative assumptions are stated, but the explanation of how they are conceptualized and operationalized within the benchmark is incomplete or lacks clarity.
+ 15: Normative assumptions are explicitly and clearly stated, defining the cultural context and values that the benchmark adheres to, and explaining how the measured properties are conceptualized and operationalized within the benchmark.

#### Do7. Documentation of limitations

Explanation: Benchmark developers outline the limitations of the benchmark, including but not limited to the tasks, contexts, and scenarios that are not covered by the evaluation are acknowledged. It's stated which use cases are out-of-scope.

Justification: Documenting a benchmark's limitations is necessary for users to assess its suitability for their specific evaluation needs. By understanding what the benchmark does not cover, users can make informed decisions about whether the benchmark aligns with their goals and whether additional evaluations (either in the form of other benchmarks or private evaluations) may be required to complement the benchmark's results.

Points:
+ 0: No documentation of the benchmark's limitations is provided.
+ 5: Limitations of AI evaluations more broadly are briefly mentioned but without any detail and not applied to the specific benchmark.
+ 10: Either limitations regarding the applicability and use of the benchmark or limitations of the benchmark design are discussed, but not both.
+ 15: Both limitations regarding the applicability and use of the benchmark and limitations of the benchmark design are comprehensively discussed.

#### Do8. Documentation of benchmark construction process

Explanation: Benchmark developers give a detailed account of the design process, including the specific decisions made at each life-cycle stage, the rationale behind them, and any trade-offs or compromises (e.g., balancing complexity vs. practicality) considered.

Justification: Documenting the benchmark design process is essential for transparency, as it allows users to understand how the benchmark was created and what factors influenced its development. It allows users to assess the thoroughness and rigor of the benchmark's construction. This information further enables users to critically evaluate whether the benchmark is suitable for their specific use case.

Points:
+ 0: No documentation of the benchmark construction process is provided.
+ 5: The benchmark construction process is briefly mentioned but lacks sufficient detail about the decisions made, rationale, and trade-offs considered.
+ 10: The benchmark construction process is documented, including some decisions made and their rationale, but the description lacks depth or fails to address important aspects such as trade-offs or compromises.
+ 15: The benchmark construction process is comprehensively documented, providing a detailed account of the specific decisions made at each stage, the rationale behind them, and any trade-offs or compromises considered.

#### Do9. Documentation of data collection or environment/prompt design process

Explanation: A detailed description of the data collection process, including the sources of the data, the criteria for selection, and any preprocessing steps is provided. For benchmarks involving prompts, a description of how the prompts were created, how they were validated, and why they were used to elicit the desired responses was included. For benchmarks involving dynamic environments or test data, the design specifics and templates for the dynamic process were explicitly described.

Justification: Documenting the data collection or prompt design process is important for ensuring the transparency, reproducibility, and validity of the benchmark. By providing a clear and detailed account of how the data was collected or how the prompts were designed, users can assess the quality and representativeness of the benchmark's data, identify potential biases or limitations, and determine whether the data or prompts are suitable for their specific use case.

Points:
+ 0: No documentation of the data collection or environment/prompt design process is provided.
+ 5: The data collection or environment/prompt design process is briefly mentioned but no information about the sources, selection criteria, preprocessing steps, or prompt validation is provided.
+ 10: The data collection or environment/prompt design process is documented, including some information about the sources, selection criteria, preprocessing steps, or prompt validation, but the description lacks depth or fails to address important aspects.
+ 15: The data collection or environment/prompt design process is comprehensively documented, providing a detailed account of the sources of the data, the criteria for selection, any preprocessing steps, and, if applicable, how the prompts were created, validated, and why they were used to elicit the desired responses.

#### Do10. Documentation of evaluation metric(s)

Explanation: The evaluation metrics used are clearly specified and defined, both for standard and custom metrics tailored to the specific task or domain. The exact formulas or processes used to calculate these metrics, along with any parameters or thresholds employed, are made transparent.

Justification: Documenting the evaluation metrics and scoring process is essential for enabling users to understand how the benchmark quantifies model performance and determines rankings or comparisons. By providing clear and detailed information about the metrics and scoring methods, users can assess whether the chosen metrics are appropriate for the task at hand, align with their own evaluation criteria, and provide a fair and meaningful basis for comparing different models or approaches.

Points:
+ 0: No documentation of the evaluation metrics is provided.
+ 5: The evaluation metrics are mentioned but not clearly defined, and the exact formulas or processes used to calculate them are not provided.
+ 10: The evaluation metrics are defined, but the documentation lacks some important details, such as any parameters or thresholds employed.
+ 15: The evaluation metrics are clearly specified. The exact formulas or processes used to calculate these metrics, along with any parameters or thresholds employed, are comprehensively documented.

#### Do11. Report statistical significance of benchmark results for at least one model

Explanation: Benchmark developers run statistical significance tests on the benchmark results. They report results for, e.g., more than one random seed, and provide variance bounds. In cases where the benchmark is perfectly deterministic, this should be explicitly stated.

Justification: Not doing statistical significance testing can significantly reduce the validity, utility and confidence in results. Especially for benchmarks, we want to understand how much of the results are due to noise and how much is caused by true differences between the models tested.

Points:
+ 0: No statistical significance testing or variance reporting is provided for the benchmark results.
+ 5: The need for valid benchmarks and/or statistical significance or uncertainty estimation is mentioned but not addressed.
+ 10: Benchmark developers "bound the expected variation across model training runs".
+ 15: Benchmark developers run statistical significance tests on the benchmark results for at least one model and provide variance bounds or other uncertainty estimations. In cases where the benchmark is perfectly deterministic, this is explicitly stated.

#### Do12. Accepted at peer-reviewed venue

Explanation: The benchmark/its associated paper was accepted to a peer-reviewed journal, conference, or similar venue.

Justification: Acceptance at a peer-reviewed venue signifies that the benchmark has undergone an evaluation by an external party, ensuring its validity, reliability, and scientific merit. This peer review process contributes to the credibility and assurance to users that the benchmark meets established standards of quality and relevance.

Points:
+ 0: The benchmark/its associated paper has not been accepted at a peer-reviewed venue.
+ 5: The benchmark/its associated paper has been submitted to a peer-reviewed venue but is still under review or awaiting acceptance.
+ 10: The benchmark/its associated paper has been accepted at a peer-reviewed workshop or symposium.
+ 15: The benchmark/its associated paper has been accepted at a peer-reviewed journal, conference, or similar high-profile venue.

#### Do13. Specifies applicable license

Explanation: The benchmark developers clearly specify the applicable license for the benchmark in the code repository or paper. This includes providing information about the conditions under which the benchmark can be used, modified, and distributed.

Justification: Specifying the applicable license ensures legal clarity and compliance for benchmark users and enables wider adoption, as commercial users might not be able to use the benchmark if no license is specified.

Points:
+ 0: No license is specified for the benchmark.
+ 5: A license is mentioned but not clearly specified or linked to in the code repository or paper.
+ 10: A license is specified but lacks some important details about the conditions under which the benchmark can be used, modified, or distributed.
+ 15: The applicable license for the benchmark is clearly specified in the code repository or paper, providing comprehensive information about the conditions under which the benchmark can be used, modified, and distributed.

#### Do14. Provision of a globally unique, persistent identifier for a dataset and its metadata

Explanation: The benchmark dataset and its associated metadata are assigned a globally unique and persistent identifier, such as a Digital Object Identifier (DOI), to ensure long-term accessibility and citability of the resource (FAIR Principles, 2024).

Justification: A persistent identifier supports the findability and accessibility of the benchmark and its dataset. It allows for unambiguous referencing of the data, facilitates proper attribution, and ensures that the dataset can be located and accessed over time, even if its physical location changes. This practice aligns with the FAIR (Findable, Accessible, Interoperable, Reusable) principles, enhancing the benchmark's scientific value and reusability.

Points:
+ 0: The benchmark paper, dataset, and metadata are not assigned any persistent identifier.
+ 5: The benchmark assigns persistent identifiers to the paper, the dataset, or the metadata.
+ 10: The benchmark assigns a persistent identifier to two out of three (paper, dataset, metadata).
+ 15: The benchmark assigns a globally unique, persistent identifier to the dataset, its metadata, and the paper.

#### Do15. Inclusion of standardized metadata (e.g., following the Croissant standard)

Explanation: The benchmark includes comprehensive, standardized metadata that describes the dataset, its structure, and relevant information about its creation and usage. This metadata adheres to established standards such as the Croissant standard, which is designed specifically for machine learning datasets.

Justification: Standardized metadata is crucial for ensuring interoperability and reusability of the benchmark dataset. It provides consistent and machine-readable information about the dataset's contents, structure, and provenance. This standardization facilitates easier discovery, understanding, and integration of the dataset into various research workflows. By following established standards like Croissant, the benchmark enhances its utility across different platforms and tools in the machine learning ecosystem.

Points:
+ 0: The benchmark does not include any structured metadata.
+ 5: The benchmark includes some basic metadata, but it is not standardized or comprehensive.
+ 10: The benchmark includes comprehensive metadata that covers most aspects of the dataset, but it does not fully adhere to a recognized standard like Croissant.
+ 15: The benchmark includes complete, standardized metadata (e.g., following the Croissant standard) that thoroughly describes all aspects of the dataset, ensuring maximum interoperability and reusability.

#### Do16. Documentation of data sources and how the data was collected (if applicable)

Explanation: The benchmark provides comprehensive documentation detailing the origins of the data, the methods used for data collection, and, where applicable, discusses issues of data provenance and informed consent. They also list the license types for all data used and how they ensured compliance with that license.

Justification: Thorough documentation of data sources and collection methods is necessary for ensuring transparency, reproducibility, and ethical design of the benchmark. It allows users to understand the context and limitations of the data, assess its appropriateness for their specific use cases, and make informed decisions about its application. Furthermore, discussing data provenance and informed consent addresses ethical considerations, particularly when dealing with sensitive or personal data, and helps ensure compliance with data protection regulations.

Points:
+ 0: The benchmark provides no information about data sources or collection methods.
+ 5: The benchmark mentions data sources but provides minimal details about collection methods or ethical considerations.
+ 10: The benchmark includes a detailed description of data sources and collection methods, but lacks a discussion of data provenance, compliance with licensing, or informed consent, where applicable.
+ 15: The benchmark provides extensive documentation of data sources, collection methods, and a thorough discussion of data provenance, compliance with licensing, and informed consent, addressing relevant ethical and legal considerations.

#### Do17. Documentation of the data preprocessing steps taken

Explanation: The benchmark provides a detailed account of all preprocessing steps applied to the raw data before its inclusion in the final dataset. This documentation includes information on data cleaning, normalization, feature engineering, handling of missing values, and any other transformations or manipulations performed on the original data. If no data preprocessing was done, the authors state this explicitly.

Justification: Thorough documentation of preprocessing steps is necessary for ensuring reproducibility and transparency of the benchmark. It allows users to understand exactly how the final dataset was created, which is key for interpreting results, replicating experiments, and assessing the benchmark's applicability to different use cases. Additionally, this information helps identify potential biases or artifacts introduced during preprocessing that could affect model performance or generalization.

Points:
+ 0: The benchmark provides no information about data preprocessing steps.
+ 5: The benchmark mentions that preprocessing was done but offers minimal details about the specific steps taken.
+ 10: The benchmark includes a general description of preprocessing steps, but lacks comprehensive details or fails to cover all aspects of the data preparation process.
+ 15: The benchmark provides an exhaustive, step-by-step documentation of all preprocessing procedures, including rationales for choices made and potential impacts on the data.

#### Do18. Documentation of the data annotation process (if applicable)

Explanation: The benchmark provides documentation of the data annotation process, including the annotation guidelines, the qualifications and training of annotators, the annotation tools used, quality control measures, and inter-annotator agreement metrics. This documentation covers the entire workflow from raw data to the final annotated dataset.

Justification: Comprehensive documentation of the annotation process is necessary for understanding the quality, reliability, and potential biases in the labeled data. It allows users to assess the suitability of the dataset for their specific tasks and to interpret results accurately. Transparent annotation documentation also enables reproducibility of the labeling process, facilitates improvements in future iterations of the benchmark, and helps in identifying and mitigating potential sources of bias or error in the annotations.

Points:
+ 0: The benchmark provides no information about the data annotation process.
+ 5: The benchmark mentions that data was annotated but offers minimal details about the process or guidelines used.
+ 10: The benchmark includes a general description of the annotation process, including guidelines and tools used, but lacks comprehensive details on quality control measures or inter-annotator agreement.
+ 15: The benchmark provides exhaustive documentation of the entire annotation process, including detailed guidelines, annotator information, quality control measures, inter-annotator agreement metrics, and discussions of potential biases or limitations in the annotation approach.

#### Do19. Documentation of the representativeness of the data (if applicable)

Explanation: The benchmark provides analysis and documentation of how representative the dataset or environment is of the target population or domain. This includes an explanation of the sampling procedure used, any potential biases in the data collection process, and how well the dataset captures the diversity and distribution of the intended population or phenomenon being studied.

Justification: Understanding the representativeness of the data is necessary for assessing the generalizability and validity of any conclusions drawn from models trained or evaluated on the benchmark. It helps users identify potential limitations or biases in the dataset that could affect model performance in real-world applications. Proper documentation of representativeness also aids in interpreting benchmark results within the context of the population it represents and highlights areas where the dataset may need expansion or improvement to better cover underrepresented groups or scenarios.

Points:
+ 0: The benchmark provides no information about the representativeness of the data or the sampling procedure used.
+ 5: The benchmark mentions the importance of data representativeness but offers minimal analysis or explanation of how representative the dataset actually is.
+ 10: The benchmark includes a general discussion of data representativeness and the sampling procedure, but lacks comprehensive analysis or fails to address potential biases or limitations in representativeness.
+ 15: The benchmark provides an in-depth analysis of data representativeness, including detailed explanation of the sampling procedure, quantitative measures of population coverage, discussion of potential biases, and acknowledgment of any limitations in representativeness.

#### Do20. Standardized documentation

Explanation: The benchmark utilizes a standardized documentation format, such as data cards, to present the information about the dataset that is underlying to the benchmark. This standardized approach ensures that all key aspects of the dataset are systematically covered, including its composition, collection methodology, intended uses, ethical considerations, and potential biases.

Justification: Adopting a standardized documentation scheme like data cards enhances the usability and transparency of the benchmark. It provides a consistent, structured format that makes it easier for users to quickly understand the dataset's characteristics, limitations, and appropriate use cases. Standardized documentation facilitates easier comparison between datasets and benchmarks, promotes best practices in data reporting, and helps identify potential issues or gaps in the dataset's coverage.

Points:
+ 0: The benchmark does not use any standardized documentation scheme.
+ 5: The benchmark includes some elements of standardized documentation, but does not fully adhere to an established scheme like data cards.
+ 10: The benchmark uses a standardized documentation scheme, but some sections are incomplete or lack detail.
+ 15: The benchmark fully implements a comprehensive standardized documentation scheme (e.g., data cards), providing thorough and structured information on all relevant aspects of the dataset.

### Maintenance (3 criteria)

#### M1. Code usability checked within the last year

Explanation: The main files of the public code were updated within the last year, or the developers checked that the benchmark code is still usable and explicitly state this check in the README file, including the date of the check.

Justification: Over time, packages that the benchmark depends on may be updated and become incompatible with the original evaluation/benchmark code. To ensure ongoing usability, benchmark developers must check if their code can still be used at least once a year. This practice ensures that users can use the benchmark without encountering and having to fix issues due to outdated dependencies.

Points:
+ 0: No updates to the main files of the public code within the last year, and no explicit statement of a usability check in the README file.
+ 5: Updates to minor files in the repo were made (e.g., README file) but an explicit statement of a usability check in the README file is not reported.
+ 10: Updates to the main files of the public code were made within the last year, but the build status check failed and wasn't fixed.
+ 15: Updates to the main files of the public code within the last year, accompanied by a successful build status check, or an explicit statement of a usability check in the README file, including the date of the check was provided.

#### M2. Maintained feedback channel for users

Explanation: GitHub issues are acknowledged or addressed within three months. If there are no open issues, benchmark developers would get full points.

Justification: Over time, users may find issues with the benchmark tasks or implementation. To ensure continued usability, benchmark developers should address these concerns in a reasonable amount of time. Promptly responding to user feedback helps maintain the reliability and relevance of the benchmark.

Points:
+ 0: No acknowledgment or response to GitHub issues that are older than three months.
+ 5: GitHub issues are mentioned as a way to provide feedback but there are GitHub issues that were not responded to and that are older than three months.
+ 10: All GitHub issues are acknowledged within three months, but not all are addressed or resolved or were closed because the issue/feature request won't be attended to.
+ 15: All GitHub issues are acknowledged and addressed within three months, or it is clearly stated if an issue cannot be fixed or if a feature request won't be fulfilled. Alternatively, there are no open issues.

#### M3. Provide contact details of person responsible for benchmark

Explanation: The benchmark should include contact details of the person responsible, such as a corresponding author in the associated paper, a contact person listed on GitHub or the website, or an available online feedback form.

Justification: Providing contact details ensures that users have a communication channel for inquiries, feedback, or reporting issues related to the benchmark. This transparency supports effective collaboration and resolution of problems, enhancing the benchmark's usability.

Points:
+ 0: It is not disclosed who developed the benchmark.
+ 5: The benchmark developers are disclosed but no explicit contact details are provided.
+ 10: Contact details are provided but are incomplete or difficult to find, e.g., only as part of terms of service on a website.
+ 15: Contact details of the person responsible for the benchmark are easily accessible, such as a corresponding author in the associated paper, a contact person listed on GitHub or the website, or an available online feedback form.

## Our stage: Education

BetterBench derived its stages from the objectives of five stakeholder groups (policymakers, model developers, benchmark developers, model users, and AI researchers). 
However, an instructor who lets students run a benchmark and build defenses against it is a sixth stakeholder whose objectives none of the 47 criteria cover: safety of execution, a plug-in point for student agents, extension of the task set, per-run traceability, class-session run time, local compute, content suitable for a classroom, etc. 

### Education (8 criteria)

#### E1. Tool execution isolation

Explanation: The benchmark's tools do not act on real systems when the agent calls them.

Justification: Students run attacks that instruct an agent to delete data, transfer money, or exfiltrate credentials. The exercise is only safe if those tool calls cannot reach a real system.

Points:
+ 0: Tools act on real systems (network, files, accounts) and the benchmark does not mention the risk.
+ 5: The benchmark acknowledges the risk of real side effects, but tools still act on real systems.
+ 10: Tools run in a sandbox or container, but some real-system access remains (for example, live web requests).
+ 15: All tools are simulated, mocked, or in-memory, so the agent cannot cause a real side effect.

#### E2. Support for user-built agents or defenses

Explanation: A user can plug their own agent pipeline or defense logic into the benchmark and run it, rather than only swapping the model.

Justification: The teaching goal is to build and evaluate secure agent systems, not only to compare bare model refusal rates. A benchmark that only swaps the model cannot measure a student's defense.

Points:
+ 0: Only the model can be swapped, and custom pipelines are not discussed.
+ 5: Custom pipelines are mentioned as possible or as future work, but there is no code path for them.
+ 10: A custom pipeline can be run after adapting harness code, without a documented interface.
+ 15: A documented interface exists for plugging in a user's agent or defense and running the full benchmark against it.

#### E3. Extension points for tasks, attacks, and tools

Explanation: New benchmark content (tasks, attacks, tools, scoring functions) can be added without modifying core code.

Justification: Course material needs new vulnerable-agent tasks and new attacks each term. Extension through configuration or subclassing keeps that work small and keeps the upstream code intact.

Points:
+ 0: Extension requires core code changes, and extension is not discussed.
+ 5: Extension is mentioned, but no mechanism is provided.
+ 10: Some extension types are data-driven or subclassable, while others need core changes.
+ 15: Every extension type goes through configuration, subclassing, or decorators, and the extension points are documented.

#### E4. Run trace inspection

Explanation: A user can see the full sequence of a run (prompt, model messages, tool calls, tool results) and why it scored as it did.

Justification: A student learns from a benchmark by tracing how an injected instruction reached a tool call. Aggregate scores alone do not teach that.

Points:
+ 0: Only aggregate scores are available.
+ 5: The value of per-run traces is acknowledged, but traces are not stored.
+ 10: Raw per-run logs or files contain the full message sequence, and the user reads them without tooling.
+ 15: A structured trajectory browser shows message-level detail and a per-task explanation of the score.

#### E5. Assignment-sized evaluation

Explanation: A meaningful evaluation fits in a class session or an assignment.

Justification: An evaluation that takes days per model cannot be assigned. Either the full run is short, or the tool documents a subset that is.

Points:
+ 0: A full evaluation takes over 24 hours per model, no subset exists, and run time is not discussed.
+ 5: Long run time is acknowledged, but no subset or sampling option is provided.
+ 10: A full evaluation takes 2 to 24 hours per model, or a subset exists but is undocumented.
+ 15: A full evaluation takes under 2 hours per model, or a documented subset runs within a class session.

Measurement: times are measured on the shared ollama server with the three reference models (`qwen3:14b`, `qwen3-coder:30b`, `gpt-oss:120b`), and the tool's README states the numbers.

#### E6. Fully local evaluation

Explanation: The benchmark runs end to end without paid API access, including the judge and any auxiliary component such as embeddings.

Justification: A course cannot issue paid API keys to every student. Every component that calls a paid API, including judges and embedding models, blocks local use.

Points:
+ 0: A paid API is required for the model, the judge, or an auxiliary component, and local evaluation is not discussed.
+ 5: Local evaluation is mentioned, but the shipped code needs changes to run locally.
+ 10: Local evaluation works after documented fixes to the shipped code.
+ 15: Local evaluation works as shipped, with zero API cost.

#### E7. Hardware requirement

Explanation: The hardware needed to run the benchmark with the reference models is within reach of a course.

Justification: Students and course servers have one GPU, not a cluster. The benchmark's own overhead (vector stores, local judges, perplexity detectors) must not raise the requirement beyond what the models need.

Points:
+ 0: Requires specialized hardware beyond a GPU server, and requirements are not stated.
+ 5: Requirements are stated but exceed a GPU server (for example, a cluster).
+ 10: Runs on a multi-GPU server, or on a single GPU with extra configuration.
+ 15: Runs on a single GPU server or CPU-only hardware without extra configuration.

Measurement: judged with the reference models. The largest one (`gpt-oss:120b`) needs the 4-GPU server, so a tool scores 15 only if the smaller reference models run on one GPU without special setup.

#### E8. Low-sensitivity subset for classroom use

Explanation: An instructor can run the benchmark without exposing students to the most harmful content.

Justification: Harmful prompts are the point of a security benchmark, but an introductory session needs a way to exercise the pipeline on less offensive material.

Points:
+ 0: Harmful content is present, no subset exists, and the issue is not discussed.
+ 5: Content sensitivity is acknowledged, but no subset or filter is provided.
+ 10: A lower-sensitivity subset can be obtained by filtering on a documented field.
+ 15: A benign or non-aggressive split is shipped and documented.

<!--
## Descriptive labels (not scored)

These properties inform course placement but are not qualities, so they carry no score. They appear in the comparison table beside the stage scores.
+ Content level: formulaic, concrete, or graphic, with the categories present (for example, Hate, Sexual, Harassment).
+ Score granularity: binary, discrete, or continuous.
+ Attack vectors and security risks covered, from [`attack-risk-coverage.md`](attack-risk-coverage.md).
-->

<!--
## Mapping from our previous factors

The previous scheme had 7 criteria with 1/2/3 factors. Every factor has a home in the new scheme:

| Previous criterion and factor | New home |
|---|---|
| Deployability: hardware requirements | E7 |
| Deployability: API credits | E6 |
| Deployability: software dependencies | Do1 (requirements file), M1 (code usability checked) |
| Deployability: gated dataset access | I3 (accessibility of evaluation data) |
| Deployability: time to complete full eval | E5 |
| Extensibility (all three factors) | E3, plus Do4 (code documentation) |
| Maintenance & Support (all three factors) | M1 to M3 (BetterBench's dated rules replace the previous ones) |
| Execution isolation | E1 |
| Content sensitivity: harmful content presence | Content level label, plus I8 (warnings for harmful content) and E8 (subset) |
| Observability: full message sequence, trajectory viewer | E4 |
| Observability: scoring breakdown | Do10 (documentation of evaluation metrics), D13 (validated automatic evaluation) |
| Observability: score granularity | Score granularity label |
| Experimentability (all three factors) | E2 |
-->

## References
+ BetterBench paper: [BetterBench: Assessing AI Benchmarks, Uncovering Issues, and Establishing Best Practices](https://arxiv.org/abs/2411.12990) (NeurIPS 2024 Datasets and Benchmarks)
+ BetterBench methodology and rubrics: [betterbench.stanford.edu/methodology.html](https://betterbench.stanford.edu/methodology.html)
