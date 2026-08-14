# Setup and Installation


## Setting up Ollama
### Prerequisite
A server with enough GPU computation power.

### Installation
1. On the machine intended to run Ollama, install Ollama v0.23.1 either from the released tarball (local installation) or have the official isntallation script get through the hasssle for you (system-side, root privilege required):
   ```sh
   # install locally
   curl -LO https://github.com/ollama/ollama/releases/download/v0.23.1/ollama-linux-amd64.tgz
   mkdir -p ~/ollama
   tar -xzf ollama-linux-amd64.tgz -C ~/ollama
   echo 'export PATH=$HOME/ollama/bin:$PATH' >> ~/.bashrc

   # install for the whole system
   curl -fsSL https://ollama.com/install.sh | OLLAMA_VERSION=0.23.1 sh
   ```
2. Test its version.
   ```sh
   ollama -v
   # ollama version is 0.23.1
   ```

### Start the Server 
To start Ollama, execute [`scripts/ollama.sbatch`](scripts/ollama.sbatch) on the machine intended to run Ollama. You should adjuct the environment variables set in the script (e.g., `OLLAMA_HOST`, `OLLAMA_MODELS`, and `OLLAMA_CONTEXT_LENGTH`) based on your needs.


### <a id="my-custom-anchor"></a>Pull Models

Let's say you are to conduct the evaluations on 3 models: `qwen3:14b`, `qwen3-coder:30b`, and `gpt-oss:120b`, exactly the same as what we used in our experiments.
1. Have Ollama pull them one by one via Ollama's API from ANY machine:
   ```sh
   for model in 'qwen3:14b' 'qwen3-coder:30b' 'gpt-oss:120b'; do
      curl -s http://<ollama_host>:<ollama:port>/api/pull -d "{\"name\": \"$model\"}";
   done
   ```
   where `<ollama_host>:<ollama:port>` is the IP address and port that your Ollama server is hosted and listening to. For example, we used `korn.ics.uci.edu:48763` because our Ollama runs on korn (korn.ics.uci.edu) and listens on port 48763, as configured by the `OLLAMA_HOST` variable in the previous step.
2. Verify that Ollama finished pulling all models with
   ```sh
   curl -s http://<ollama_host>:<ollama:port>/api/tags | python3 -m json.tool
   ```
3. Force Ollama to load all models in advance with
   ```sh
   for model in 'qwen3:14b' 'qwen3-coder:30b' 'gpt-oss:120b'; do
      curl -s http://<ollama_host>:<ollama:port>/api/generate -d "{\"name\": \"$model\"}";
   done
   ```
4. Verify that all models are loaded with
   ```sh
   curl -s http://<ollama_host>:<ollama:port>/api/ps | python3 -m json.tool
   ```

   
## Setting up Ollama (for OpenGPU Cluster Only)

### Installation
Ollama (currently v0.23.1) is already installed on the OpenGPU cluster, yay!

### Start the Server 
To start Ollama, execute [`scripts/ollama.sbatch`](scripts/ollama.sbatch) on the [OpenLab cluster](https://wiki.ics.uci.edu/doku.php/instructional_support:openlab). You should adjuct the environment variables (e.g., `OLLAMA_HOST`, `OLLAMA_MODELS`, and `OLLAMA_CONTEXT_LENGTH`) and `SBATCH` flags (e.g., `--time`, `--mem`, and `-w`) set in the script based on your needs.

**You may want to set the IP address of `OLLAMA_HOST` to `0.0.0.0` if you want the Ollama server to be accessible to all devides that can access korn/poison.** Alternatively, for those concerning security, you may as well have Ollama server listen only on the lookback interface by setting the IP address of `OLLAMA_HOST` to `127.0.0.1`, and set up SSH tunneling afterwards.

### Pull Models

See [Pull Models](#my-custom-anchor).



