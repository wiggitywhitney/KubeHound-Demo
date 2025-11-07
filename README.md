# KubeHound Test Environment

A local Kubernetes environment for learning and exploring [KubeHound](https://kubehound.io/), a tool that identifies attack paths in Kubernetes clusters by building a graph of relationships between resources.

This repository provides automation to deploy KubeHound's official test cluster (24 purpose-built attack scenarios) and explore discovered attack paths through an interactive Jupyter notebook interface.

## What You'll Get

- **3-node Kind cluster** with 24 attack scenarios designed to demonstrate various Kubernetes security issues
- **KubeHound backend** (MongoDB, JanusGraph graph database, Jupyter UI)
- **Interactive notebooks** for exploring attack paths visually
- **One-command setup** that handles cluster creation, data collection, and attack graph generation

## Prerequisites

Install these tools before running the setup:

```bash
# Docker Desktop (must be running)
# https://www.docker.com/products/docker-desktop

# Kind (Kubernetes in Docker)
brew install kind

# kubectl
brew install kubectl

# KubeHound CLI
# https://github.com/DataDog/KubeHound#installation
```

Verify Docker is running:
```bash
docker ps
```

## Quick Start

### Setup

Run the setup script to create everything:

```bash
./setup-kubehound-test-cluster.sh
```

**What this does:**
1. Clones KubeHound repository to `/tmp/kubehound-repo`
2. Creates a 3-node Kind cluster named `kubehound.test.local`
3. Deploys 24 vulnerable resource manifests (pods, roles, service accounts, etc.)
4. Waits for all 43 pods to reach Running state
5. Starts KubeHound backend (MongoDB, JanusGraph, Jupyter UI)
6. **Dumps cluster data** - Collects information about all cluster resources
7. **Builds attack graph** - Analyzes relationships and identifies attack paths

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

This deletes the cluster, backend containers, kubeconfig file, dump data, and cloned KubeHound repository.

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

This opens the main demo notebook designed specifically for Kind clusters.

![KindCluster_Demo Notebook](docs/images/KubeHound_Screenshot_2.png)
*The KindCluster_Demo notebook showing the title, introduction, and initial setup section*

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

![Console vs Graph Tabs](docs/images/KubeHound_Screenshot_3.png)
*Console tab shows tabular data, while the Graph tab (shown with many scattered nodes) visualizes relationships*

### The KindCluster_Demo Notebook Structure

The notebook walks you through attack path discovery with a progressive narrative:

**1. Initial Setup**
Configures graph visualization settings (smooth edges, arrows, etc.).

**2. "What are we looking at?"**
Starts with the big picture - queries all vertices (resources) and their critical paths.

**Query example:**
```gremlin
kh.V().limit(100).criticalPaths().by(elementMap()).limit(500)
```

**Result:** Overwhelming! Shows hundreds of attack paths. Too much to make sense of.

**3. "Let's look at the containers then"**
Narrows focus to just container-based attack paths.

**Query example:**
```gremlin
kh.containers().criticalPaths().by(elementMap()).limit(200)
```

**Result:** Still too much. Demonstrates the need for further filtering.

**4. "Let's look at the basic, the endpoints"**
Focuses on endpoints (exposed services) since they're the most realistic entry points for attackers.

**Query example:**
```gremlin
kh.endpoints().criticalPaths().by(elementMap()).limit(100)
```

**Result:** More manageable! Shows which exposed services can lead to critical access.

**5. "Let's get the vulnerability context"**
Groups endpoints by service to understand which services are vulnerable.

**Query example:**
```gremlin
kh.endpoints().criticalPaths().limit(local,1)
  .dedup().valueMap("serviceEndpoint","port")
  .group().by("serviceEndpoint").by("port")
```

**Result:** Table showing service endpoints and their exposed ports.

**6. "Let's look at the specific services that interest us"**
Filters out noise (like `kube-dns`) to focus on actual vulnerable services.

**Query example:**
```gremlin
kh.endpoints().not(has("serviceEndpoint","kube-dns")).criticalPaths().by(elementMap())
```

**Result:** Clean list of attack paths from interesting services.

**7. "Initial exposure identified"**
Shows multi-hop attack chains: starts from an endpoint, follows the attack path, stops when it reaches a Node.

**Query example:**
```gremlin
kh.endpoints().not(has("serviceEndpoint","kube-dns"))
  .repeat(
    outE().inV().simplePath()
  )
  .until(
    hasLabel("Node")
    .or()
    .loops().is(5)
  )
  .hasLabel("Node")
  .path()
  .by(elementMap())
  .limit(100)
```

**Result:** Multi-step attack paths showing: Endpoint → Container → Pod → Node

This is the "true findings" section showing realistic attack scenarios.

### Understanding Attack Path Graphs

When viewing results in the **Graph** tab, you'll see:

- **Nodes (circles)** - Kubernetes resources (pods, containers, identities, roles, nodes)
- **Edges (arrows)** - Attack steps connecting resources
- **Edge labels** - Attack type (e.g., VOLUME_ACCESS, ROLE_BIND, CE_PRIV_MOUNT)

![Attack Path Graph](docs/images/KubeHound_Screenshot_6.png)
*An unfiltered attack path graph showing ALL relationships - this is overwhelming! The notebook explains "this is bad" and demonstrates why filtering is necessary. Different colored nodes represent different resource types.*

**Common attack types:**
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
- **Attack scenarios** - 24 YAML manifests deploying vulnerable configurations
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

## Contributing

This is a personal learning repository. Feel free to fork and experiment!

## License

This repository's automation scripts are provided as-is for educational purposes. KubeHound itself is licensed under Apache 2.0.
