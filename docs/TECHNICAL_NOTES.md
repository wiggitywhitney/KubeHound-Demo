# Technical Implementation Notes for PRD 2

## Research Date: 2025-11-05

This document captures validated technical details for implementing the automated KubeHound demo environment.

---

## 1. KubeHound Backend Commands

### Prerequisites
- Docker >= 19.03
- Docker Compose >= v2.0

### Backend Startup Command
```bash
kubehound backend up
```

Optional: Use custom docker-compose overrides:
```bash
kubehound backend up -f docker-compose.overrides.yml
```

### What Gets Started
The backend command starts these services via Docker Compose v2 API:
- **MongoDB**: `mongodb://localhost:27017` (data storage)
- **JanusGraph**: `ws://localhost:8182/gremlin` (graph database)
- **Jupyter UI**: <http://localhost:8888> (default password: `admin`)
- Additional UI components (invana-engine, invana-studio)

### Backend Health Check
- Jupyter UI accessible at <http://localhost:8888>
- Password can be changed via `NOTEBOOK_PASSWORD` env var
- Connection timeouts default to 30s

### Backend Shutdown Command
```bash
kubehound backend down
```

---

## 2. Kubernetes Goat Installation

### IMPORTANT: No Helm Chart Installation

**Finding**: Kubernetes Goat is NOT installed via Helm chart, despite having Helm as a prerequisite.

### Installation Methods

#### Method 1: Standard Installation (NOT suitable for our use case)
```bash
git clone https://github.com/madhuakula/kubernetes-goat.git
cd kubernetes-goat
bash setup-kubernetes-goat.sh
```

This assumes you already have a cluster running.

#### Method 2: Kind-Specific Installation (RECOMMENDED for our PRD)
Kubernetes Goat provides a dedicated Kind setup script that:
1. Creates a Kind cluster
2. Deploys all Kubernetes Goat scenarios
3. Configures everything for local access

**Location**: `kubernetes-goat/platforms/kind-setup/`

**Command**:
```bash
git clone https://github.com/madhuakula/kubernetes-goat.git
cd kubernetes-goat/platforms/kind-setup
bash setup-kind-cluster-and-goat.sh
```

**Access**:
```bash
bash access-kubernetes-goat.sh
# Opens http://127.0.0.1:1234
```

### Kubernetes Goat Features
- 20+ security scenarios (originally stated as 22 in PRD)
- Intentionally vulnerable by design
- Covers: privilege escalation, RBAC misconfigurations, secrets exposure, container escapes, etc.

**WARNING**: Never run alongside production environments!

---

## 3. Kind Cluster Configuration

### Basic Cluster Creation
```bash
kind create cluster --name kubehound-demo
```

### Custom Configuration (Optional)

If we need custom ports or mounts, use a config file:

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30950
    hostPort: 30950
    listenAddress: "127.0.0.1"
    protocol: TCP
  extraMounts:
  - hostPath: /path/on/host
    containerPath: /path/in/node
```

```bash
kind create cluster --name kubehound-demo --config kind-config.yaml
```

### Cluster Deletion
```bash
kind delete cluster --name kubehound-demo
```

### Accessing the Cluster
```bash
kubectl cluster-info --context kind-kubehound-demo
```

---

## 4. KubeHound Analysis Commands

### Data Collection (MANUAL - Part of Demo)
```bash
kubehound dump
```

This connects to the current kubectl context and collects cluster data.

### Attack Path Analysis (MANUAL - Part of Demo)
```bash
kubehound ingest
```

This analyzes the collected data and builds the attack graph in JanusGraph.

### Expected Results
- 25+ attack types can be identified
- Attack paths stored in graph database
- Accessible via Jupyter UI for exploration

---

## 5. KubeHound + Kubernetes Goat Compatibility Analysis

### Research Methodology (2025-11-05)
Cross-referenced KubeHound's attack detection capabilities against Kubernetes Goat's vulnerable scenarios to validate compatibility.

**Sources**:
- KubeHound attack reference: <https://kubehound.io/reference/graph/>
- Kubernetes Goat scenarios: <https://madhuakula.com/kubernetes-goat/docs/>

### KubeHound Attack Detection Capabilities (25+ types)

**Container Escape Attacks**:
- CE_MODULE_LOAD, CE_NSENTER, CE_PRIV_MOUNT, CE_SYS_PTRACE, CE_UMH_CORE_PATTERN, CE_VAR_LOG_SYMLINK

**Container Access**:
- CONTAINER_ATTACH, POD_ATTACH, POD_EXEC, POD_CREATE, POD_PATCH

**Exploitation**:
- ENDPOINT_EXPLOIT, EXPLOIT_CONTAINERD_SOCK, EXPLOIT_HOST_READ, EXPLOIT_HOST_TRAVERSE, EXPLOIT_HOST_WRITE

**Identity & Access**:
- IDENTITY_ASSUME, IDENTITY_IMPERSONATE, ROLE_BIND, PERMISSION_DISCOVER

**Token Abuse**:
- TOKEN_BRUTEFORCE, TOKEN_LIST, TOKEN_STEAL

**Volume Access**:
- VOLUME_ACCESS, VOLUME_DISCOVER, SHARE_PS_NAMESPACE

### Kubernetes Goat Vulnerable Scenarios (22 scenarios)

**Confirmed Vulnerable Scenarios**:
1. Sensitive keys in codebases
2. Gaining environment information
3. DIND (docker-in-docker) exploitation
4. Container escape to the host system
5. Hidden in layers
6. SSRF in Kubernetes
7. NodePort exposed services
8. Attacking private registry
9. Kubernetes namespaces bypass
10. RBAC least privileges misconfiguration
11. DoS Memory/CPU resources
12. Docker/Kubernetes CIS benchmarks (analysis tools)
13. Runtime security monitoring (Falco, Cilium Tetragon)
14. Policy enforcement (Kyverno)

### Compatibility Matrix: Strong Overlap ✅

| Kubernetes Goat Scenario | → KubeHound Detects | Confidence |
|--------------------------|---------------------|------------|
| **RBAC least privileges** (#13) | IDENTITY_IMPERSONATE, ROLE_BIND, PERMISSION_DISCOVER | High |
| **DIND exploitation** (#3) | EXPLOIT_CONTAINERD_SOCK, CE_PRIV_MOUNT | High |
| **Container escape** (#4) | CE_NSENTER, CE_MODULE_LOAD, CE_SYS_PTRACE | High |
| **Sensitive keys in codebases** (#1) | TOKEN_STEAL, IDENTITY_ASSUME | High |
| **NodePort exposed services** (#8) | ENDPOINT_EXPLOIT (entry point) | Medium |
| **Environment information** (#2) | TOKEN_LIST, TOKEN_STEAL | Medium |
| **Namespaces bypass** (#10) | POD_CREATE, POD_EXEC, IDENTITY_IMPERSONATE | Medium |

### Potential Gaps (Requires Testing)

| KubeHound Attack Type | Goat Coverage | Risk Level |
|-----------------------|---------------|------------|
| VOLUME_ACCESS, VOLUME_DISCOVER | Unknown if Goat has vulnerable volumes | Medium |
| POD_CREATE, POD_PATCH | Depends on Goat's RBAC configuration | Low |
| SHARE_PS_NAMESPACE | Not explicitly mentioned in Goat scenarios | Low |

### Expected Attack Paths (Based on Analysis)

**High Confidence - Will Likely Discover**:
1. **Public Service → Container → Node Compromise**: NodePort (entry) → DIND exploit → container escape
2. **Service Account Token Abuse → Cluster Admin**: TOKEN_STEAL → IDENTITY_ASSUME → ROLE_BIND → cluster-admin
3. **Secrets Exposure → Lateral Movement**: Hardcoded credentials → TOKEN_STEAL → IDENTITY_IMPERSONATE

**Medium Confidence - May Discover**:
4. **Container Escape via Privileged Capabilities**: CE_SYS_PTRACE → CE_NSENTER → host access
5. **RBAC Privilege Escalation Chain**: PERMISSION_DISCOVER → IDENTITY_IMPERSONATE → POD_CREATE

### Demo-Worthy Attack Paths (Recommendations)
1. **Multi-hop lateral movement**: Show 3+ step attack chain from entry to compromise
2. **Privilege escalation**: Demonstrate low-privilege → cluster-admin path
3. **Container escape**: Highlight container breakout to node access

---

## 6. Integration Architecture Decision

### Approach 1: Use Kubernetes Goat's Kind Script (RECOMMENDED)
**Pros**:
- Officially supported by Kubernetes Goat
- Creates cluster + deploys goat in one step
- Battle-tested configuration
- Simpler for end users

**Cons**:
- Less control over cluster naming
- Need to inspect their script to understand what it does
- May create cluster with different name than "kubehound-demo"

### Approach 2: Create Custom Kind Cluster + Deploy Goat Manually
**Pros**:
- Full control over cluster name and configuration
- More transparent to users
- Can optimize for our specific needs

**Cons**:
- More complex script
- Need to replicate Kubernetes Goat's deployment logic
- May miss important Goat-specific configurations

### DECISION FOR IMPLEMENTATION
**Use Approach 1** with modifications:
1. Clone Kubernetes Goat repo (one-time step, can be in setup script)
2. Modify/wrap their Kind setup script to ensure cluster is named "kubehound-demo"
3. OR: Inspect their script and replicate the important parts in our setup script

**Alternative**: Document both approaches and let users choose.

---

## 7. Timing Estimates

Based on typical operations:

| Step | Estimated Time |
|------|---------------|
| Check prerequisites | 5-10 seconds |
| Pull Docker images (first time) | 2-3 minutes |
| Create Kind cluster | 30-60 seconds |
| Deploy Kubernetes Goat | 60-90 seconds |
| Wait for pods Ready | 60-120 seconds |
| Start KubeHound backend | 30-60 seconds |
| Verify health | 10-20 seconds |
| **TOTAL** | **4.5-7 minutes** |

**Target from PRD**: 3-5 minutes
**Realistic with pre-pulled images**: 3-5 minutes
**First-time run**: 5-7 minutes

---

## 8. Prerequisites Validation

Scripts should check for:
```bash
# Docker
docker --version  # >= 19.03

# Kind
kind --version

# Helm (prerequisite for Kubernetes Goat, though not directly used)
helm version

# kubectl
kubectl version --client

# KubeHound binary
kubehound version
```

---

## 9. Open Questions - ANSWERED

### Q: What Kind cluster configuration is needed?
**A**: Basic Kind cluster sufficient. Kubernetes Goat's Kind script handles necessary configuration. Custom ports/mounts optional.

### Q: Which Helm repository/chart for Kubernetes Goat?
**A**: NO HELM CHART. Use `bash setup-kind-cluster-and-goat.sh` from `kubernetes-goat/platforms/kind-setup/`.

### Q: What are exact KubeHound backend commands?
**A**: `kubehound backend up` (start), `kubehound backend down` (stop).

### Q: Which 2-3 attack paths are most impressive?
**A**:
1. Public service → privileged container → node compromise
2. Service account token abuse → cluster-admin
3. Secrets exposure → lateral movement to sensitive namespaces

### Q: What timeouts for pod readiness?
**A**: Recommend 5 minutes (300 seconds) with progress indicators every 30 seconds.

### Q: Should setup script check Docker resources?
**A**: YES. Recommend checking Docker is running and has at least 4GB memory available.

---

## 10. Implementation Recommendations

### Setup Script Structure
```bash
#!/bin/bash
set -e  # Exit on error

# 1. Check prerequisites
# 2. Clone/update Kubernetes Goat repo
# 3. Create Kind cluster (using Goat script or custom)
# 4. Wait for Kubernetes Goat pods Ready
# 5. Start KubeHound backend
# 6. Verify backend health
# 7. Print success message with URLs
```

### Teardown Script Structure
```bash
#!/bin/bash

# 1. Stop KubeHound backend gracefully
# 2. Delete Kind cluster
# 3. Optionally clean up Kubernetes Goat repo
# 4. Print confirmation
```

### Prep Script Structure
```bash
#!/bin/bash

# 1. Verify all prerequisites installed
# 2. Pre-pull Docker images
# 3. Run test cycle (setup -> verify -> teardown)
# 4. Report readiness status
```

---

## 11. Supplemental Vulnerabilities Contingency Plan

### Purpose
If KubeHound discovers fewer than 5 interesting attack paths in Kubernetes Goat, deploy supplemental vulnerabilities to guarantee demo success.

### Deployment Strategy
Create `supplemental-vulnerabilities.yaml` with guaranteed KubeHound-detectable vulnerabilities:

```yaml
---
# Guaranteed VOLUME_ACCESS and EXPLOIT_HOST_WRITE attacks
apiVersion: v1
kind: Pod
metadata:
  name: host-mount-pod
  namespace: default
  labels:
    app: supplemental-vuln
spec:
  containers:
  - name: app
    image: nginx:alpine
    volumeMounts:
    - name: host-root
      mountPath: /host
  volumes:
  - name: host-root
    hostPath:
      path: /
      type: Directory

---
# Guaranteed ROLE_BIND and IDENTITY_IMPERSONATE attacks
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: overprivileged-default-sa
  labels:
    app: supplemental-vuln
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: default
  namespace: default

---
# Guaranteed CE_PRIV_MOUNT container escape
apiVersion: v1
kind: Pod
metadata:
  name: privileged-escape-pod
  namespace: default
  labels:
    app: supplemental-vuln
spec:
  hostNetwork: true
  hostPID: true
  hostIPC: true
  containers:
  - name: privileged
    image: ubuntu:22.04
    command: ["sleep", "3600"]
    securityContext:
      privileged: true
    volumeMounts:
    - name: host-root
      mountPath: /host
  volumes:
  - name: host-root
    hostPath:
      path: /
      type: Directory

---
# Guaranteed TOKEN_STEAL via exposed secrets
apiVersion: v1
kind: Pod
metadata:
  name: secrets-exposed-pod
  namespace: default
  labels:
    app: supplemental-vuln
spec:
  serviceAccountName: default
  containers:
  - name: app
    image: nginx:alpine
    env:
    - name: SECRET_TOKEN
      value: "hardcoded-admin-token-12345"
    - name: KUBECONFIG_DATA
      value: "exposed-kubeconfig-content"
```

### Attack Paths Guaranteed by Supplemental Vulnerabilities

| Vulnerability | KubeHound Attack Type | Demo Value |
|---------------|----------------------|------------|
| `host-mount-pod` | VOLUME_ACCESS, EXPLOIT_HOST_WRITE | Show container → host filesystem access |
| `overprivileged-default-sa` | ROLE_BIND, IDENTITY_IMPERSONATE | Show privilege escalation to cluster-admin |
| `privileged-escape-pod` | CE_PRIV_MOUNT, CE_NSENTER | Show container escape to node |
| `secrets-exposed-pod` | TOKEN_STEAL, IDENTITY_ASSUME | Show credential theft leading to lateral movement |

### Deployment Command
```bash
kubectl apply -f supplemental-vulnerabilities.yaml
```

### Cleanup
All supplemental resources are labeled with `app: supplemental-vuln` for easy cleanup:
```bash
kubectl delete pods,clusterrolebindings -l app=supplemental-vuln
```

### Integration into setup-demo.sh
```bash
# After Kubernetes Goat deployment, optionally deploy supplemental vulnerabilities
if [ "$DEPLOY_SUPPLEMENTAL_VULNS" = "true" ]; then
  echo "Deploying supplemental vulnerabilities for guaranteed attack paths..."
  kubectl apply -f supplemental-vulnerabilities.yaml
  echo "✅ Supplemental vulnerabilities deployed"
fi
```

### Decision Criteria: When to Deploy Supplemental Vulnerabilities
- **Automatic**: If Phase 1 validation finds < 5 attack paths
- **Manual**: User sets `DEPLOY_SUPPLEMENTAL_VULNS=true` environment variable
- **Documentation**: README explains when/why to use supplemental vulnerabilities

---

## 12. Next Implementation Steps

1. **Examine Kubernetes Goat's Kind setup script** to understand:
   - What cluster name it uses
   - What configurations it applies
   - What resources it creates

2. **Create setup-demo.sh** implementing Phase 1 requirements:
   - Prerequisite checks
   - Kind cluster creation
   - Kubernetes Goat deployment
   - KubeHound backend startup
   - Health verification

3. **Create teardown-demo.sh** for cleanup

4. **Create README.md** with complete workflow

5. **Create prep-demo.sh** for pre-demo validation

---

## References

- **KubeHound Docs**: <https://kubehound.io/>
- **KubeHound GitHub**: <https://github.com/DataDog/KubeHound>
- **Kubernetes Goat Docs**: <https://madhuakula.com/kubernetes-goat/>
- **Kubernetes Goat GitHub**: <https://github.com/madhuakula/kubernetes-goat>
- **Kind Docs**: <https://kind.sigs.k8s.io/>
- **Kind Configuration**: <https://kind.sigs.k8s.io/docs/user/configuration/>
