# Setup and Installation


## Setting up Olama
### Prerequisite
A server with enough GPU computation power.

### Installation
1. Switch to the machine to run Ollama.
2. Install Ollama v0.23.1 either from the released tarball (local installation) or have the official isntallation script get through the hasssle for you (system-side, root privilege required):
   ```sh
   # install locally
   curl -LO https://github.com/ollama/ollama/releases/download/v0.23.1/ollama-linux-amd64.tgz
   mkdir -p ~/ollama
   tar -xzf ollama-linux-amd64.tgz -C ~/ollama
   echo 'export PATH=$HOME/ollama/bin:$PATH' >> ~/.bashrc

   # install for the whole system
   curl -fsSL https://ollama.com/install.sh | OLLAMA_VERSION=0.23.1 sh
   ```
3. Test its version.
   ```sh
   ollama -v
   # ollama version is 0.23.1
   ```



### Start the Server 

### Pull Models


## Setting up Olama (For OpenGPU Cluster Only)

