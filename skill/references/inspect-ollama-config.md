# Inspect (`inspect_ai`) with the ollama server: validated recipe

Many agentic benchmarks (AgentHarm and other `inspect_evals` tasks) run on the Inspect
framework. Inspect supports ollama, even when the benchmark's own README does not mention it.
This recipe is validated against the shared ollama server.

## Steps

1. Install the framework. In an `inspect_evals` checkout, run `uv sync`.
2. Install the `openai` package. The ollama provider needs it. `uv sync` does not add it.

   ```bash
   uv pip install openai
   ```

3. Set the environment variables that point at your ollama server. The evaluation scripts
   fall back to `http://korn.ics.uci.edu:48763/v1` if these variables are unset.

   ```bash
   export OLLAMA_BASE_URL=http://korn.ics.uci.edu:48763/v1
   export OLLAMA_API_KEY=ollama
   ```

4. Select an ollama model with the `ollama/<model>` prefix.

   ```bash
   uv run inspect eval inspect_evals/<task> --model ollama/qwen3-coder:30b
   ```

## Notes

- The ollama provider is an OpenAI-compatible client. The base URL variable name is
  `OLLAMA_BASE_URL`. The API key defaults to the literal `ollama`.
- Some tasks use judge models. Set them to ollama models too, or the run needs an OpenAI key.
  For AgentHarm: `-T refusal_judge=ollama/qwen3:14b -T semantic_judge=ollama/qwen3:14b`.
- Read `.eval` logs with `inspect_ai.log.read_eval_log` or `uv run inspect log dump`. Do not
  use the Python stdlib `zipfile`, because the logs use zstd compression.
- The server shares 4 GPUs for one model at a time. Run models one at a time. Raise
  `--max-connections` so same-model requests batch and keep the GPUs busy.
