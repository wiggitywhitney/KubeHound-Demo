# KubeHound Test Environment

A local Kubernetes environment for learning and exploring [KubeHound](https://kubehound.io/), a tool that identifies attack paths in Kubernetes clusters by building a graph of relationships between resources.

This repository provides automation to deploy KubeHound's official test cluster (1 attack scenario: ENDPOINT_EXPLOIT) and explore discovered attack paths through an interactive Jupyter notebook interface.

## What You'll Get

- **3-node Kind cluster** with 1 attack scenario (ENDPOINT_EXPLOIT) designed to demonstrate Kubernetes security issues
- **KubeHound backend** (MongoDB, JanusGraph graph database, Jupyter UI)
- **Interactive notebook** for exploring attack paths visually
- **One-command setup** that handles cluster creation, data collection, and attack graph generation

## How KubeHound Works

KubeHound has 4 main components in this setup:

**1. KubeHound CLI (binary on your computer)**
- The `kubehound` command you install
- Connects to Kubernetes clusters to collect configuration data
- Processes and stores data in the backend
- Commands: `kubehound dump` (collect data), `kubehound ingest` (build graph)

**2. MongoDB container (data storage)**
- Stores raw Kubernetes resource data
- Contains pods, roles, bindings, service accounts, volumes, etc.

**3. JanusGraph container (graph database)**
- Reads data from MongoDB
- Builds the attack graph with vertices (resources) and edges (attack techniques)
- Processes Gremlin queries to find attack paths

**4. Jupyter container (web UI)**
- Interactive notebook interface at http://localhost:8888
- Runs queries against JanusGraph
- Visualizes attack paths as graphs and tables

**Data Flow:**
```
KubeHound CLI → Collects from Kind cluster → Stores in MongoDB
                      ↓
KubeHound CLI → Tells JanusGraph to ingest → Builds attack graph
                      ↓
You → Use Jupyter UI → Queries JanusGraph → See attack paths
```

## Prerequisites

Install these tools before running the setup script:

| Tool | Purpose | Installation |
|------|---------|--------------|
| **Docker** | Container runtime | [Install Docker](https://docs.docker.com/get-docker/) |
| **Kind** | Local Kubernetes clusters | [Install Kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation) |
| **kubectl** | Kubernetes CLI | [Install kubectl](https://kubernetes.io/docs/tasks/tools/) |
| **KubeHound CLI** | Attack path analysis | [Install KubeHound](https://kubehound.io/getting-started/installation/) |

## Quick Start

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

### Cleanup

Remove everything:

```bash
./teardown-kubehound-test-cluster.sh
```

This deletes the cluster, backend containers, kubeconfig file, and dump data.

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

### Understanding the Notebook Interface

**Cell numbering:**
- `[1]`, `[2]`, `[3]` - Cell has been executed (number shows execution order)
- `[*]` - Cell is currently running (or hasn't been executed yet)
- `[ ]` - Cell hasn't been executed

**Running cells:**
- Click a cell to select it
- Press **Shift + Enter** to execute the cell
- Results appear below the cell

**Important:** Run cells sequentially from top to bottom. Some cells depend on previous ones.

### Result Tabs

After executing a query cell, you'll see tabs above the results:

- **Console** - Shows data in table format (good for seeing raw details)
- **Graph** - Shows visual network diagram of attack paths (nodes and edges)
- **Query Metadata** - Shows query execution details

Click between tabs to view results differently.

### The KindCluster_Demo Notebook Structure

The notebook walks you through attack path discovery with a progressive filtering approach, demonstrating how to narrow down from hundreds of attack paths to the most critical, actionable findings:

**1. Initial Setup**
Configures graph visualization settings (smooth edges, arrows).

**2. What are we looking at?**
Shows all Kubernetes resources as individual dots, with each color representing a different resource type (pods, containers, identities, nodes, volumes).

**3. Critical attack paths**
Finds attack chains that lead to cluster compromise - when an attacker gains control of a Node and can access all containers, secrets, and data.

**Result:** 388 attack paths found - overwhelming!

**4. Too much information!**
Narrows down to containers since they often have misconfigurations like excessive permissions, container escape vulnerabilities, and access to sensitive volumes.

**Result:** Still too many results.

**5. Still too many results**
Focuses on endpoints (exposed services) - the realistic entry points for external attackers. Supply chain attacks exist but are sophisticated and less common.

**Result:** More manageable - shows attack paths from externally accessible services.

**6. Identify the vulnerable services**
Steps back from complex graphs to get a simple list of which services (by name and port) have critical attack paths.

**Result:** Table showing vulnerable service endpoints and ports.

**7. Filter out internal infrastructure**
Removes internal services like `kube-dns` (Kubernetes' internal DNS service) to focus on externally-accessible services attackers would actually target.

**Result:** Clean attack paths from interesting services only.

**8. Trace the complete attack path**
Shows the complete step-by-step attack chain: which endpoint an attacker starts from, what they compromise along the way (containers, identities, permissions), and how they reach Node access.

**Query example:**
```gremlin
kh.endpoints().not(has("serviceEndpoint","kube-dns"))
  .repeat(outE().inV().simplePath())
  .until(hasLabel("Node").or().loops().is(5))
  .hasLabel("Node")
  .path().by(elementMap())
  .limit(100)
```

**Result:** Complete attack chains from external entry points to cluster compromise.

**9. Congratulations!**
You've successfully filtered down from hundreds of attack paths to the most critical, actionable findings.

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

You can modify queries or add new cells:

1. **To add a new cell:** Click the `+` button in the toolbar
2. **To modify a query:** Click into the cell, edit the code, press Shift+Enter
3. **To restart:** Kernel → Restart & Clear Output

**Tip:** Start with the existing queries and make small changes to learn the syntax. The [Gremlin documentation](https://tinkerpop.apache.org/gremlin.html) and [KubeHound query examples](https://github.com/DataDog/KubeHound/tree/main/docs) are helpful references.

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

## Architecture Overview

**Components:**
- **Kind cluster** (`kubehound.test.local`) - 3 nodes running Kubernetes v1.33.1
- **Attack scenarios** - 1 YAML manifest (ENDPOINT_EXPLOIT) deploying vulnerable configuration
- **MongoDB** - Stores normalized cluster data
- **JanusGraph** - Graph database storing attack paths
- **Jupyter UI** - Web interface for exploring the graph at http://localhost:8888

**Data flow:**
```
Kubernetes Cluster
    ↓ (kubehound dump)
Compressed cluster data
    ↓ (kubehound ingest)
MongoDB + JanusGraph
    ↓ (Jupyter queries)
Visual attack path graphs
```

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
├── prds/                              # Product requirement documents
│   ├── 2-automated-demo-environment.md
│   └── 3-kubernetes-goat-integration.md
└── README.md                          # This file
```

**Generated files (gitignored):**
- `kubehound-test.kubeconfig` - Isolated cluster config
- `dump-test/` - Cluster data dump
- `*.log` - Setup/teardown logs

## Troubleshooting

### Setup Issues

**"Missing required tools" error**
- The setup script checks for Docker, Kind, kubectl, and KubeHound CLI
- Follow the installation links provided in the error message
- macOS users: Most tools are available via Homebrew

**"Docker is installed but not running"**
- macOS/Windows: Start Docker Desktop application
- Linux: Start Docker daemon with `sudo systemctl start docker`

**"Cluster already exists" error**
```bash
./teardown-kubehound-test-cluster.sh
./setup-kubehound-test-cluster.sh
```

### Cluster Issues

**Cluster creation takes too long or times out**
- Ensure Docker has sufficient resources (8GB RAM recommended)
- macOS/Windows: Docker Desktop → Settings → Resources
- Check Docker is not running other resource-intensive containers

**Pods stuck in Pending or CrashLoopBackOff**
```bash
# Check pod status
export KUBECONFIG=./kubehound-test.kubeconfig
kubectl get pods --all-namespaces

# Check specific pod logs
kubectl logs <pod-name> -n <namespace>
```

### KubeHound Backend Issues

**"Backend health check timeout"**
- JanusGraph and MongoDB can take 60-90 seconds to start
- Check container status: `docker ps`
- Check logs: `docker logs kubehound-release-janus-1`

**Cannot access Jupyter at http://localhost:8888**
- Verify container is running: `docker ps | grep jupyter`
- Check if port is already in use: `lsof -i :8888` (macOS/Linux)
- Restart container: `docker restart kubehound-release-ui-jupyter-1`

### Platform-Specific Issues

**Windows: Cannot access localhost:8888 from browser**
- WSL2 should forward ports automatically
- If not working, find WSL2 IP: `ip addr show eth0`
- Access via `http://<WSL2-IP>:8888` in Windows browser

**Linux: Permission denied connecting to Docker**
```bash
# Add user to docker group
sudo usermod -aG docker $USER
# Logout and login, or run:
newgrp docker
```

**macOS: "kind: command not found" after installation**
- Verify Homebrew installation: `brew doctor`
- Reinstall if needed: `brew reinstall kind`
- Ensure `/opt/homebrew/bin` (Apple Silicon) or `/usr/local/bin` (Intel) is in PATH

## Contributing

This is a personal learning repository. Feel free to fork and experiment!

## License

This repository's automation scripts are provided as-is for educational purposes. KubeHound itself is licensed under Apache 2.0.
