---
issue: 3
title: Kubernetes Goat Integration for KubeHound Demo
status: Backlog
created: 2025-11-05
last_updated: 2025-11-05
priority: Medium
---

# PRD: Kubernetes Goat Integration for KubeHound Demo

## Overview

**Problem**: Current demo uses KubeHound's own test cluster with 24 purpose-built attack scenarios. While this demonstrates KubeHound's capabilities effectively, integrating with Kubernetes Goat (a widely-used, community-maintained vulnerable environment) would be more impressive and demonstrate broader real-world applicability.

**Solution**: Create setup automation that deploys Kubernetes Goat and successfully demonstrates KubeHound attack path analysis against it, showing that KubeHound can analyze third-party vulnerable environments beyond its own test scenarios.

**User Impact**: Whitney can demonstrate KubeHound analyzing a "real-world" vulnerable application (Kubernetes Goat's 20+ security scenarios) rather than just its own test cases, making the demo more compelling for audiences familiar with Goat.

## Success Criteria

✅ Run `./setup-goat-demo.sh` and get working environment in 3-5 minutes
✅ All components healthy: Kind cluster, Kubernetes Goat pods (20+), KubeHound backend
✅ KubeHound successfully ingests Goat cluster data
✅ **At least 5 interesting attack paths discoverable** in KubeHound UI
✅ Attack paths visualize correctly using KindCluster_Demo.ipynb queries
✅ Run `./teardown-goat-demo.sh` and all resources cleaned up
✅ README documents Goat-specific attack paths and demo narrative

## Why This Matters

**Advantages over Test Cluster:**
- **Community recognition**: Kubernetes Goat is industry-standard for Kubernetes security training
- **Real-world scenarios**: 20+ scenarios designed for security professionals, not just KubeHound testing
- **Broader applicability**: Shows KubeHound works with third-party vulnerable environments
- **Better narrative**: "Here's KubeHound analyzing Kubernetes Goat" is more impressive than "Here's KubeHound analyzing its own test cluster"

**Current Limitations (Why This is Future Work):**
- Time pressure: Current deadline requires focusing on proven test cluster approach
- Learning curve: Requires understanding both KubeHound query patterns AND Goat scenario structure
- Uncertain attack paths: Initial testing showed data ingestion success but unclear visualization results
- Query complexity: Need to identify which Goat scenarios map to which KubeHound attack types

## Technical Approach

### Architecture

```
setup-goat-demo.sh → Kind cluster → Kubernetes Goat (Helm) → KubeHound backend (ready)
                                                              ↓
                                            [MANUAL] kubehound dump (collect data)
                                                              ↓
                                            [MANUAL] kubehound ingest (analyze)
                                                              ↓
                                            KubeHound UI (explore attack paths)
```

### Key Components

1. **Kind Cluster**: Created by Kubernetes Goat's official setup script
   - Cluster name: `kubernetes-goat-cluster` (their default)
   - 3-node cluster with proper networking

2. **Kubernetes Goat**: 20+ vulnerable scenarios
   - Deployed via their official `platforms/kind-setup/setup-kind-cluster-and-goat.sh` script
   - Includes: RBAC misconfigurations, secrets exposure, container escapes, network policies, etc.

3. **KubeHound Backend**: Same as test cluster setup
   - JanusGraph, MongoDB, Jupyter UI
   - Reuse existing backend if running

### Implementation Strategy

**Reuse Existing Work from PRD 2:**
- ✅ `setup-demo.sh` already exists and successfully deploys Goat cluster (2m 46s, 20/20 pods)
- ✅ KubeHound ingestion tested and working (60 identities, 70 permission sets ingested)
- ✅ Backend integration proven
- ❓ Attack path visualization needs validation

**What's Needed:**
1. **Query Pattern Research**:
   - Identify which KindCluster_Demo.ipynb queries work with Goat
   - Document Goat scenario → KubeHound attack type mappings
   - Create Goat-specific query examples

2. **Visualization Validation**:
   - Confirm attack paths render in graph UI
   - Document any Goat-specific query modifications needed
   - Validate at least 5 compelling attack paths

3. **Documentation**:
   - Update README with Goat-specific demo workflow
   - Document interesting Goat scenarios to highlight
   - Troubleshooting guide for Goat-specific issues

4. **Comparison Analysis**:
   - Compare attack path quantity/quality: Test cluster vs Goat
   - Document pros/cons of each approach
   - Recommend which to use for different audiences

## Research Findings (From PRD 2 Evaluation)

### Compatibility Analysis

**KubeHound Attack Types ↔ Kubernetes Goat Scenarios:**

| KubeHound Attack | Goat Scenario | Confidence |
|-----------------|---------------|------------|
| IDENTITY_ASSUME | Scenario 1-3 (DIND, SSRF, privileged container) | High |
| CE_PRIV_MOUNT | Scenario 3 (Privileged container escape) | High |
| VOLUME_ACCESS | Scenario 4-5 (Docker socket, secrets) | High |
| TOKEN_LIST/BRUTEFORCE | Scenario 6 (Kubernetes namespaces bypass) | High |
| ROLE_BIND | Scenario 7-8 (RBAC least privilege) | High |
| ENDPOINT_EXPLOIT | Scenario 16 (Hidden in layers) | Medium |

### Known Challenges

1. **Query Learning Curve**: Initial testing showed "No data available" for some queries
   - Root cause: User unfamiliarity with Gremlin query syntax
   - Solution: Use proven queries from KindCluster_Demo.ipynb as baseline

2. **External Endpoints**: Some advanced queries look for public-facing services
   - Local Kind may not have LoadBalancer/external IPs
   - May require GCP deployment for full endpoint-based attack paths

3. **Scenario Mapping**: Not all 20+ Goat scenarios may map to KubeHound attack types
   - Some scenarios focus on app-level vulnerabilities (XSS, SQLi)
   - Focus on infrastructure-level scenarios (RBAC, containers, secrets)

## Implementation Milestones

### Phase 1: Validation & Query Research
- [ ] Re-deploy Goat cluster using existing setup-demo.sh
- [ ] Test all KindCluster_Demo.ipynb queries against Goat
- [ ] Document which queries return attack paths
- [ ] Identify at least 5 compelling Goat attack paths
- [ ] Create query examples specific to Goat scenarios

### Phase 2: Automation Refinement
- [ ] Rename setup-demo.sh → setup-goat-demo.sh (clarity)
- [ ] Create teardown-goat-demo.sh (currently missing)
- [ ] Add Goat-specific health checks
- [ ] Optimize pod readiness waiting

### Phase 3: Documentation
- [ ] README section for Goat demo workflow
- [ ] Document Goat scenario → KubeHound attack type mappings
- [ ] Comparison guide: When to use Goat vs Test cluster
- [ ] Troubleshooting guide for Goat-specific issues

### Phase 4: Advanced Features (Optional)
- [ ] GCP deployment option for external endpoint testing
- [ ] Supplemental vulnerabilities manifest (if needed for guaranteed attack paths)
- [ ] Dual-cluster demo: Show both Goat and Test cluster side-by-side

## Open Questions

### Research Needed
- **Attack Path Quality**: Do Goat scenarios produce "impressive" multi-hop attack chains? Or mostly single-step issues?
- **Query Modifications**: Do KindCluster_Demo queries need Goat-specific adjustments?
- **External Endpoints**: Are endpoint-based attacks viable in local Kind? Or require cloud deployment?
- **Demo Narrative**: What's the best story to tell with Goat vs Test cluster?

### Technical Unknowns
- **Graph Visualization**: Will Goat attack paths render as clearly as test cluster paths?
- **Performance**: Does Goat ingestion take longer than test cluster?
- **Maintenance**: How often does Goat update? Will our integration break?

## Dependencies

**Prerequisite PRDs:**
- ✅ PRD 2: Automated Demo Environment (test cluster implementation provides foundation)

**External Dependencies:**
- Kubernetes Goat repository: https://github.com/madhuakula/kubernetes-goat
- Community maintenance of Goat scenarios
- KubeHound query documentation

**Internal Dependencies:**
- KubeHound backend (shared with test cluster setup)
- KindCluster_Demo.ipynb query patterns

## Future Enhancements (Out of Scope)

- Automated scenario selection (choose which Goat scenarios to deploy)
- Custom Goat scenario creation specifically for KubeHound demo
- Integration testing CI/CD for Goat compatibility
- Multi-cluster comparison dashboard (Goat vs Test vs Real clusters)
- Attack path recording/playback for offline demos

## Work Log

### 2025-11-05: PRD Creation
**Context**: Moved from PRD 2 after deciding to focus on test cluster for immediate deadline

**Decision Rationale**:
- Test cluster proven and working (Phase 1 complete)
- Time pressure requires focusing on reliable approach
- Goat integration valuable but not critical for first demo
- Captured research and learnings for future implementation

**Existing Assets to Leverage**:
- setup-demo.sh (already working with Goat)
- Ingestion validation (60 identities, 70 permission sets confirmed)
- Compatibility research (attack type mapping documented)
- Design decisions on reusing Goat's official scripts

**Estimated Effort**: 2-4 hours
- 1 hour: Query validation and attack path confirmation
- 1 hour: Documentation updates
- 1 hour: Teardown script creation
- 1 hour: Testing and refinement

**Value Proposition**: Medium priority - Makes demo more impressive but not required for core functionality

---

## References

- **Kubernetes Goat**: https://github.com/madhuakula/kubernetes-goat
- **KubeHound**: https://github.com/DataDog/KubeHound
- **PRD 2**: Automated Demo Environment (test cluster implementation)
- **KindCluster_Demo.ipynb**: Query reference for attack path visualization
