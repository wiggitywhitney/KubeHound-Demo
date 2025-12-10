# KubeHound Test Environment

A local Kubernetes environment for learning and exploring [KubeHound](https://kubehound.io/), a tool that identifies attack paths in Kubernetes clusters by building a graph of relationships between resources. This answers a question vulnerability scanners can't: **which misconfigurations should you fix first?**

This repository provides automation to deploy a test cluster with intentional misconfigurations and explore the discovered attack paths through an interactive Jupyter notebook.

## Quick Start

### Getting Started

First, clone this repository:

```bash
git clone https://github.com/wiggitywhitney/KubeHound-Demo.git
cd KubeHound-Demo
```

Then proceed to install the prerequisites below.

### Prerequisites

Install these tools before running the setup script:

| Tool | Purpose |
|------|---------|
| **Docker** | Container runtime |
| **Kind** | Local Kubernetes clusters |
| **kubectl** | Kubernetes CLI |
| **KubeHound CLI** | Attack path analysis |

<details>
<summary><strong>macOS (Homebrew)</strong></summary>

```bash
# Docker Desktop (requires macOS 14+)
brew install --cask docker-desktop
# Then launch Docker Desktop from Applications and complete setup

# Kind, kubectl, and KubeHound
brew install kind kubectl kubehound
```

</details>

<details>
<summary><strong>Linux (Ubuntu/Debian)</strong></summary>

```bash
# Docker Engine - Add Docker's official repository
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add your user to docker group (log out and back in after)
sudo usermod -aG docker $USER

# Kind (v0.30.0)
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.30.0/kind-linux-amd64
[ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.30.0/kind-linux-arm64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# KubeHound
wget https://github.com/DataDog/KubeHound/releases/latest/download/kubehound-$(uname -o | sed 's/GNU\///g')-$(uname -m) -O kubehound
chmod +x kubehound
sudo mv kubehound /usr/local/bin/
```

</details>

<details>
<summary><strong>Windows (WSL2)</strong></summary>

First, ensure WSL2 is installed with Ubuntu:
```powershell
# Run in PowerShell as Administrator
wsl --install
```

Install Docker Desktop for Windows with WSL2 backend:
1. Download from [Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/)
2. During installation, enable "Use WSL 2 based engine"
3. After installation, go to Settings → Resources → WSL Integration and enable your distro

Then install remaining tools inside your WSL2 Ubuntu terminal:
```bash
# Kind (v0.30.0)
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.30.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# KubeHound
wget https://github.com/DataDog/KubeHound/releases/latest/download/kubehound-Linux-x86_64 -O kubehound
chmod +x kubehound
sudo mv kubehound /usr/local/bin/
```

</details>

> **Windows users**: This demo requires bash scripts. Use WSL2 (see install instructions above) or [Git Bash](https://git-scm.com/download/win).

### Setup

Run the setup script to create everything:

```bash
./setup-kubehound-test-cluster.sh
```

**What this does:**
1. Creates a 3-node Kind cluster named `kubehound.test.local`
2. Deploys 1 vulnerable resource manifest (ENDPOINT_EXPLOIT: privileged pod with exposed service)
3. Waits for all pods to reach Running state
4. Starts KubeHound backend (MongoDB, JanusGraph, Jupyter UI)
5. **Dumps cluster data** - Collects information about all cluster resources
6. **Builds attack graph** - Analyzes relationships and identifies attack paths

Setup takes about 2-3 minutes. When complete, you'll see:

```
✅ KubeHound Test Cluster Ready!

🌐 KubeHound UI: http://localhost:8888
   Password: admin
```

### What do you want to do next?

- **[Explore the notebook](#exploring-attack-paths-with-jupyter-notebook)** — Jump straight into querying attack paths in the Jupyter UI
- **[Understand the setup](#understanding-kubehound-commands)** — Learn what the setup script did and how KubeHound commands work

## What You Just Built

- **3-node Kind cluster** with 1 attack scenario (ENDPOINT_EXPLOIT) designed to demonstrate Kubernetes security issues
- **KubeHound backend** (MongoDB, JanusGraph graph database, Jupyter UI)
- **Interactive notebook** for exploring attack paths visually
- **One-command setup** that handles cluster creation, data collection, and attack graph generation

**Data flow:**
```text
Kubernetes Cluster
    ↓ (kubehound dump)
Compressed cluster data
    ↓ (kubehound ingest)
MongoDB + JanusGraph
    ↓ (Jupyter queries)
Visual attack path graphs
```

## Exploring Attack Paths with Jupyter Notebook

### What is Jupyter Notebook?

Jupyter Notebook is a web-based interactive environment where you can write and execute code in "cells." Each cell contains either:
- **Code** (queries that fetch and visualize attack paths)
- **Markdown** (explanatory text)

Think of it like a runnable document that combines explanations with live query results.

### Accessing the UI

Open your browser to: **http://localhost:8888**

**Password:** `admin`

You'll see the Jupyter file browser showing directories.

### Opening the Demo Notebook

1. Navigate to the `kubehound_presets/` folder
2. Click on **`KindCluster_Demo.ipynb`**

This is the demo notebook designed specifically for Kind clusters.

### What You'll See in the Notebook

The notebook interface has code cells that you run one at a time. Each query produces results in multiple formats:

![Jupyter cell with code and console output](docs/images/Jupyter_Cells_Console.png)

*A code cell with a query and its results. The notebook includes a "First Time Using Jupyter?" guide at the top.*

After running a query, click between tabs to view results differently:

![Result tabs showing Console, Graph, and Query Metadata](docs/images/Jupyter_Cells_Tabs.png)

*Results appear in tabs: Console (table data), Graph (visual diagram), Query Metadata (stats).*

![Graph visualization of attack paths](docs/images/Jupyter_Cells_Visualization.png)

*The Graph tab shows attack paths as connected nodes - this is where the visual insights are!*

### The KindCluster_Demo Notebook

The notebook walks you through attack path discovery, progressively filtering from hundreds of paths down to the most critical findings. It's self-guided with explanations in each cell.

### Understanding Attack Path Graphs

When viewing results in the **Graph** tab, you'll see:

- **Nodes (circles)** - Kubernetes resources (pods, containers, identities, roles, nodes)
- **Edges (arrows)** - Attack steps connecting resources
- **Edge labels** - Attack type (e.g., VOLUME_ACCESS, ROLE_BIND, CE_PRIV_MOUNT)

**Common attack types:** (see [full attack library](https://kubehound.io/reference/attacks/))
- **VOLUME_ACCESS** - Container can access a volume containing sensitive data
- **ROLE_BIND** - Identity can bind a privileged role to itself
- **CE_PRIV_MOUNT** - Container can escape to host via privileged mount
- **TOKEN_STEAL** - Container can steal service account tokens
- **IDENTITY_ASSUME** - Identity can assume another identity's permissions

**Reading a path:** Follow arrows from left to right to see the attack progression. Example: "Endpoint exposes Pod → Pod has privileged container → Container can CE_PRIV_MOUNT → Gains Node access."

### Query Language: Gremlin and KubeHound DSL

The queries in the notebook use **Gremlin**, a graph traversal language designed for querying graph databases. KubeHound provides a custom DSL (Domain-Specific Language) wrapper on top of Gremlin to make security analysis easier.

**KubeHound DSL shortcuts:**
- `kh.V()` - Get all vertices (all resources in the cluster)
- `kh.containers()` - Get all container vertices
- `kh.endpoints()` - Get all endpoint vertices (exposed services)
- `.criticalPaths()` - Find paths that lead to critical access (nodes, cluster-admin, etc.)

**Gremlin traversal methods:**
- `.has("property", "value")` - Filter vertices by property
- `.not(...)` - Exclude matching vertices
- `.outE().inV()` - Follow outgoing edges to connected vertices
- `.repeat(...).until(...)` - Traverse paths until a condition is met
- `.path()` - Return the full path taken through the graph
- `.limit(n)` - Limit results to n items

**Example breakdown:**
```gremlin
kh.endpoints()                           // Start with all endpoints
  .not(has("serviceEndpoint","kube-dns")) // Exclude kube-dns
  .criticalPaths()                        // Find paths to critical access
  .by(elementMap())                       // Include all properties
```

This query finds attack paths starting from exposed services (excluding system services) that lead to cluster compromise.

### Experimenting with Queries

The notebook is designed for experimentation - modify existing queries or add new cells to explore further. Start with small changes to learn the syntax.

**References:**
- [Gremlin documentation](https://tinkerpop.apache.org/gremlin.html)
- [KubeHound query examples](https://github.com/DataDog/KubeHound/tree/main/docs)

## Understanding KubeHound Commands

The setup script automatically runs two key KubeHound CLI commands:

### `kubehound dump`

**What it does:** Collects data from the Kubernetes cluster (pods, roles, role bindings, service accounts, volumes, endpoints, etc.) and saves it locally.

**Command used:**
```bash
kubehound dump local ./dump-test -y
```

**Output:** Creates `dump-test/kind-kubehound.test.local/` directory with compressed cluster data.

**When to run manually:** If you modify the cluster (deploy new workloads, change RBAC) and want to re-analyze it, run this command with the kubeconfig:
```bash
export KUBECONFIG=./kubehound-test.kubeconfig
kubehound dump local ./dump-test -y
```

### `kubehound ingest`

**What it does:** Processes the dumped data, analyzes relationships between resources, and builds an attack graph stored in the JanusGraph database. This is where KubeHound identifies attack paths like "Container with privileged permissions can escape to node, node can access secrets, secrets lead to cluster-admin."

**Command used:**
```bash
kubehound ingest local dump-test/kind-kubehound.test.local --skip-backend
```

**Output:** Ingests identities, permission sets, pods, containers, volumes, endpoints, and creates edges representing attack steps (VOLUME_ACCESS, ROLE_BIND, CE_PRIV_MOUNT, TOKEN_STEAL, etc.).

**When to run manually:** After running `dump` with modified cluster data:
```bash
kubehound ingest local dump-test/kind-kubehound.test.local --skip-backend
```

## Kubeconfig Isolation

The setup script creates a **local kubeconfig file** (`./kubehound-test.kubeconfig`) instead of modifying your global `~/.kube/config`. This keeps the test cluster isolated from your other Kubernetes contexts.

**To interact with the cluster manually:**
```bash
export KUBECONFIG=./kubehound-test.kubeconfig
kubectl get pods --all-namespaces
```

Or use the `--kubeconfig` flag:
```bash
kubectl --kubeconfig=./kubehound-test.kubeconfig get nodes
```

## Cleanup

When you're done exploring, remove everything:

```bash
./teardown-kubehound-test-cluster.sh
```

This deletes the cluster, backend containers, kubeconfig file, and dump data.

---

## Why Attack Paths Matter

Kubernetes misconfigurations are common—and often introduced with the best intentions. A developer hits a permissions error during deployment and grants `cluster-admin` "just to make it work." A CI/CD job fails, so someone adds broad RBAC access to get it running. A support engineer needs quick access to logs and mounts the host filesystem.

### Example: Over-privileged Service Account

![Over-privileged Service Account](docs/images/misconfig-overprivileged-sa.png)

*A service account granted cluster-admin privileges—often done to bypass permission errors during development.*

### Example: HostPath Mount

![HostPath Mount](docs/images/misconfig-hostpath-mount.png)

*A pod mounting the host's root filesystem—breaks container isolation entirely.*

### Example: Insecure RBAC Binding

![Insecure RBAC Binding](docs/images/misconfig-insecure-rbac.png)

*A ClusterRoleBinding giving broad permissions to automation—often created when CI/CD pipelines fail with access errors.*

### The Problem with Lists

Security scanners can find these issues. But they give you a list:

| Finding | Count |
|---------|-------|
| Container escapes | 14 |
| Privilege escalations (RBAC) | 32 |
| Escape to host (volume configs) | 34 |
| Lateral movement between containers | 72 |

Here's the critical question: **Is this cluster actually secure?**

You can't tell from a list. Which of these 152 findings actually matter? Can an attacker chain them together to reach critical assets? What should you fix first?

### Graphs, Not Lists

KubeHound answers these questions by modeling your cluster as a graph:

![KubeHound Attack Graph](docs/images/attack-graph-example.png)

Instead of listing problems, KubeHound shows how they connect—revealing actual attack paths from entry points to cluster compromise. Each node is a resource (Container, Node, Identity, Volume). Each edge is an attack technique (TOKEN_STEAL, VOLUME_ACCESS, ENDPOINT_EXPLOIT).

This lets you focus your security efforts on what truly matters: the paths attackers can actually exploit.

## How KubeHound Works

### Misconfigurations vs. Attacks

It's important to distinguish between **misconfigurations** and **attacks**:

- **Misconfigurations** are opportunities—a privileged container, an overly permissive role binding, a hostPath mount. They're not inherently exploited, but they create openings.
- **Attacks** are actions an attacker takes to exploit those opportunities—stealing a token, escaping a container, binding a new role.

Here are some example attacks that exploit our misconfiguration examples from earlier:

| Misconfiguration | Example Attacks |
|------------------|-----------------|
| Over-privileged Service Account | TOKEN_STEAL (steal the powerful token), IDENTITY_ASSUME (act as that identity) |
| HostPath Mount | EXPLOIT_HOST_READ/WRITE (access host files), CE_PRIV_MOUNT (escape container) |
| Insecure RBAC Binding | ROLE_BIND (grant yourself more permissions), POD_CREATE (spawn privileged pods) |

### Attack Primitives Library

KubeHound includes a library of ~27 attack primitives—small, discrete actions an attacker might take in a Kubernetes cluster. These primitives are mapped to the [MITRE ATT&CK framework](https://attack.mitre.org/), a widely-used knowledge base of adversary tactics and techniques. MITRE categories like "Privilege Escalation," "Credential Access," and "Lateral Movement" help security teams understand attacks using industry-standard terminology.

KubeHound chains these primitives together based on your cluster's actual configuration—turning individual misconfigurations into realistic, exploitable attack paths.

See the full list: [KubeHound Attack Reference](https://kubehound.io/reference/attacks/)

### Collect, Build, Query

KubeHound analyzes your cluster in three steps:

**Step 1: Collect** — KubeHound connects to the Kubernetes API and gathers entity data. This isn't just a list of resources—it's the security-relevant details: pod security contexts, volume mounts, service account bindings, RBAC permissions, network policies, and more.

**Step 2: Build Graph** — KubeHound processes the collected data and constructs an attack graph. Resources become nodes; attack primitives become edges connecting them.

**Step 3: Query & Visualize** — You explore the graph to find attack paths. KubeHound provides a DSL (domain-specific language) on top of Gremlin that makes common security questions easy to ask, like *"What's the shortest path from a public endpoint to cluster-admin?"*

### Components

KubeHound has 4 main components in this setup:

#### 1. KubeHound CLI (binary on your computer)
- The `kubehound` command you install
- Connects to Kubernetes clusters to collect configuration data
- Processes and stores data in the backend
- Commands: `kubehound dump` (collect data), `kubehound ingest` (build graph)

#### 2. MongoDB container (data storage)
- Stores raw Kubernetes resource data
- Contains pods, roles, bindings, service accounts, volumes, etc.

#### 3. JanusGraph container (graph database)
- Reads data from MongoDB
- Builds the attack graph with vertices (resources) and edges (attack techniques)
- Processes Gremlin queries to find attack paths

#### 4. Jupyter container (web UI)
- Interactive notebook interface at [http://localhost:8888](http://localhost:8888)
- Runs queries against JanusGraph
- Visualizes attack paths as graphs and tables

**Data Flow:**
```text
KubeHound CLI → Collects from Kind cluster → Stores in MongoDB
                      ↓
KubeHound CLI → Tells JanusGraph to ingest → Builds attack graph
                      ↓
You → Use Jupyter UI → Queries JanusGraph → See attack paths
```

## Architecture & Scaling

### Architecture Overview

**Components:**
- **Kind cluster** (`kubehound.test.local`) - 3-node Kubernetes cluster
- **Attack scenarios** - 1 YAML manifest (ENDPOINT_EXPLOIT) deploying vulnerable configuration
- **MongoDB** - Stores normalized cluster data
- **JanusGraph** - Graph database storing attack paths
- **Jupyter UI** - Web interface for exploring the graph at http://localhost:8888

### Running at Scale

This demo runs KubeHound locally against a small Kind cluster. In production, KubeHound handles much larger environments.

#### Performance

KubeHound is [designed for speed](https://kubehound.io/#:~:text=KubeHound%20was%20built%20with%20efficiency%20in%20mind%20and%20can%20consequently%20handle%20very%20large%20clusters.%20Ingestion%20and%20computation%20of%20attack%20paths%20typically%20takes%20a%20few%20seconds%20for%20a%20cluster%20with%201%27000%20running%20pods%2C%202%20minutes%20for%2010%27000%20pods%2C%20and%205%20minutes%20for%2025%27000%20pods.):
- **~1,000 pods**: A few seconds for ingestion and graph construction
- **~10,000 pods**: About 2 minutes

#### KubeHound as a Service

For production clusters, KubeHound can run as a distributed service:

![KubeHound as a Service Architecture](docs/images/kubehound-as-a-service-architecture.png)

1. **Collectors** run on each cluster (prod, staging, dev), gathering entity data from the Kubernetes API
2. **Push dump** — Collectors push data to centralized storage (e.g., S3)
3. **gRPC signal** — Triggers the ingestor when new data arrives
4. **Graph creation** — The KH Ingestor processes data and builds the attack graph in JanusGraph
5. **Data visualization** — Jupyter UI provides a unified view across all clusters

This architecture lets you monitor attack paths across your entire Kubernetes fleet from one place.

For more details, see the [KubeHound documentation](https://kubehound.io/).

---

## Resources

- **KubeHound Official Site** - https://kubehound.io/
- **KubeHound GitHub** - https://github.com/DataDog/KubeHound
- **Gremlin Query Language** - https://tinkerpop.apache.org/gremlin.html
- **Jupyter Notebook Basics** - https://jupyter.org/
- **Kind Documentation** - https://kind.sigs.k8s.io/

## Repository Structure

```
KubeHound-Demo/
├── setup-kubehound-test-cluster.sh    # One-command setup script
├── teardown-kubehound-test-cluster.sh  # Complete cleanup script
├── docs/
│   └── images/                        # Screenshots for README
└── README.md                          # This file
```

**Generated files (gitignored):**
- `kubehound-test.kubeconfig` - Isolated cluster config
- `dump-test/` - Cluster data dump
- `*.log` - Setup/teardown logs

## Contributing

This is a personal learning repository. Feel free to fork and experiment!

## License

This repository's automation scripts are provided as-is for educational purposes. KubeHound itself is licensed under Apache 2.0.
