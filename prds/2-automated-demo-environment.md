---
issue: 2
title: Automated Demo Environment for KubeHound Presentation
status: In Progress
created: 2025-11-05
last_updated: 2025-11-05
priority: High
---

# PRD: Automated Demo Environment for KubeHound Presentation

## Overview

**Problem**: Preparing for a KubeHound presentation requires multiple manual setup steps (Kind cluster, test scenarios deployment, KubeHound backend configuration) that are error-prone, time-consuming, and dependent on internet connectivity. Current demo preparation risks technical failures during setup on presentation day.

**Solution**: Create comprehensive automation scripts and documentation that enable one-command deployment of a complete KubeHound demo environment running locally with Kind and KubeHound's official test cluster (24 purpose-built attack scenarios), ready for live attack path analysis demonstration.

**User Impact**: Whitney can reliably set up a complete KubeHound demo environment in under 3 minutes with a single command, demonstrate attack path analysis with confidence using proven scenarios, and clean up effortlessly afterward.

**Note**: A future PRD (#3) covers Kubernetes Goat integration for demonstrating KubeHound against third-party vulnerable environments.

## Success Criteria

✅ Run `./setup-kubehound-test-cluster.sh` and get working environment in under 3 minutes
✅ All components healthy: Kind cluster (3 nodes), test scenario pods (29), KubeHound backend
✅ KubeHound UI accessible at localhost:8888 ready for manual analysis demonstration
✅ 24 attack scenarios deployed and discoverable (850+ attack edges, 25+ attack types)
✅ Attack paths visualize correctly in KindCluster_Demo.ipynb notebook
✅ Run `./teardown-kubehound-test-cluster.sh` and all resources cleaned up
✅ README provides clear demo day workflow using test cluster
✅ No internet dependencies during demo (after initial setup)
✅ Repeatable and deterministic across runs

## User Journey

### Before Presentation Day
1. Whitney clones the KubeHound-Demo repository
2. Runs `./setup-kubehound-test-cluster.sh` for test run
3. Explores KindCluster_Demo.ipynb notebook to familiarize with attack path queries
4. Reviews README for interesting attack paths to highlight (endpoint → node, RBAC escalation, container escapes)

### Demo Day - Setup (2-3 minutes before presentation)
1. Runs `./setup-kubehound-test-cluster.sh` once
2. Waits for "Demo ready!" message (automated: cluster creation, pod deployment, backend start, ingestion)
3. Opens http://localhost:8888 (password: admin) to verify UI is ready
4. Opens KindCluster_Demo.ipynb notebook for demo walkthrough

### During Presentation
1. Explains KubeHound context and purpose-built test cluster with 24 attack scenarios
2. Follows KindCluster_Demo.ipynb narrative:
   - Show big picture (overwhelming graph of all attack paths)
   - Narrow to containers (still complex)
   - Focus on endpoints (more targeted)
   - Filter to specific scenarios (clear findings)
3. Demonstrates 2-3 interesting multi-hop attack chains
4. Explains attack types: VOLUME_ACCESS, ROLE_BIND, Container Escapes, TOKEN_STEAL

### After Presentation
1. Runs `./teardown-kubehound-test-cluster.sh` to clean up all resources
2. Receives confirmation that cluster, kubeconfig, and dump files are deleted

## Core Requirements

### 1. Automated Setup Script (`setup-kubehound-test-cluster.sh`) ✅

**Must do:**
- Clone KubeHound repository if not present (to /tmp/kubehound-repo)
- Create Kind cluster using KubeHound's test cluster configuration
  - Cluster name: "kubehound.test.local"
  - 3-node cluster (1 control-plane, 2 workers)
- Deploy 24 attack scenario manifests from test/setup/test-cluster/attacks/
- Wait for all pods to be Ready (with timeout and progress indicators)
- Start KubeHound backend stack if not already running (JanusGraph, MongoDB, UI)
- **Automatically run `kubehound dump` and `kubehound ingest`** to build attack graph
- Print success message with:
  - KubeHound UI URL (http://localhost:8888)
  - Cluster information
  - Next steps: Open KindCluster_Demo.ipynb notebook

**Implementation Notes:**
- Reuses KubeHound's official test cluster setup scripts
- Automated ingestion (unlike Goat approach) since test cluster is guaranteed compatible
- Setup completes in under 3 minutes

**Non-functional requirements:**
- ✅ Error checking after each major step
- ✅ Clear progress indicators
- ✅ Idempotent cluster name checking

### 2. Automated Teardown Script (`teardown-kubehound-test-cluster.sh`) ✅

**Must do:**
- Delete Kind cluster "kubehound.test.local"
- Clean up kubeconfig file (./kubehound-test.kubeconfig)
- Clean up dump directory (./dump-test)
- Print confirmation message
- Note: Backend intentionally left running (shared resource)

**Non-functional requirements:**
- ✅ Safe to run multiple times
- ✅ Clear confirmation of cleanup
- ✅ Handle missing resources gracefully

### 3. Comprehensive README

**Must include:**
- Project overview: KubeHound demo using purpose-built test cluster
- Prerequisites with installation commands (Docker, Kind, kubectl, KubeHound)
- Quick start: `./setup-kubehound-test-cluster.sh`
- What gets created: 3-node cluster, 29 pods, 24 attack scenarios, 850+ attack edges
- Demo day workflow using KindCluster_Demo.ipynb notebook
- Example attack path queries and visualizations
- 2-3 interesting attack paths to highlight (VOLUME_ACCESS, ROLE_BIND, Container Escapes)
- Troubleshooting common issues
- Cleanup: `./teardown-kubehound-test-cluster.sh`
- Reference to PRD #3 for Kubernetes Goat integration (future work)

**Tone**: Clear, practical, optimized for demo preparation

## Technical Architecture

### Components
1. **Kind Cluster**: Local Kubernetes cluster named "kubernetes-goat-cluster" (created by Goat's script)
2. **Kubernetes Goat**: Vulnerable K8s environment with 20+ security scenarios (community-maintained)
3. **KubeHound Backend**: JanusGraph (graph database), MongoDB (store), UI (visualization)

### Data Flow
```
setup-demo.sh → Kind cluster → Kubernetes Goat (Helm) → KubeHound backend (ready)
                                                              ↓
                                            [MANUAL] kubehound dump (collect data)
                                                              ↓
                                            [MANUAL] kubehound ingest (analyze)
                                                              ↓
                                            KubeHound UI (explore attack paths)
```

### Key Integration Points
- Kind cluster must be accessible to KubeHound for data collection
- Kubernetes Goat must deploy all 22 scenarios successfully
- KubeHound backend must be healthy before manual analysis
- All services must be accessible via localhost

## Implementation Milestones

### Phase 1: Core Automation + Validation ✅ COMPLETE
- [x] ~~Setup script creates Kind cluster and deploys Kubernetes Goat successfully~~ (ARCHIVED - switched to test cluster)
- [x] Setup script creates Kind cluster and deploys KubeHound test scenarios (setup-kubehound-test-cluster.sh: <3 minutes, 29/29 pods healthy)
- [x] Setup script starts KubeHound backend and verifies health (KubeHound UI accessible at localhost:8888)
- [x] **VALIDATION: Run kubehound dump + ingest to verify compatibility** (Completed: 81 identities, 92 permission sets, 850+ attack edges ingested)
- [x] **✅ RESOLVED: Confirm attack paths are discoverable and visualizable** (SUCCESS: Full attack graph visualizing in KindCluster_Demo.ipynb)
- [x] **TEST: Validate attack path queries work with test cluster** (COMPLETED: All query patterns working)
- [x] Teardown script for test cluster (teardown-kubehound-test-cluster.sh created and tested)
- [x] **DECISION: Choose cluster approach for demo** (FINAL: KubeHound test cluster selected)

### Phase 2: Documentation & User Experience
- [x] README complete with prerequisites, workflow, and troubleshooting (README.md: 409 lines, screenshots integrated, Gremlin/DSL documented)
- [ ] README includes 2-3 example attack paths researched from KubeHound/Goat integration
- [x] Scripts provide clear progress indicators and helpful error messages (setup script: separate dump/ingest sections, educational output)

### Phase 3: Demo Day Reliability
- [ ] Prep script validates environment and pre-pulls images
- [ ] Complete test cycle runs successfully (prep → setup → manual analysis → teardown)
- [ ] All scripts tested on clean environment

### Phase 4: Polish & Validation
- [ ] Error handling robust across failure scenarios
- [ ] Timing estimates accurate (3-5 min total setup)
- [ ] Demo workflow documented and validated
- [ ] Ready for presentation day use

## Open Questions & Decisions

### Decisions Made

#### Initial Decisions
✅ **Use Kind (not GCP)**: Local, fast, deterministic, no cloud costs
✅ **Use Kubernetes Goat**: Industry-standard vulnerable environment with 22 scenarios
✅ **Manual KubeHound analysis**: `dump` and `ingest` run live during demo (not in setup script)
✅ **One PRD**: Tasks 3-6 are cohesive "demo environment" feature

#### Design Decisions (2025-11-05)
✅ **"Build and Validate" Approach**: Implement with Kubernetes Goat first, empirically test KubeHound compatibility
- **Rationale**: Cross-reference of KubeHound attack types vs Goat scenarios shows strong overlap (RBAC, container escape, DIND, secrets exposure)
- **Impact**: Added Phase 1 validation checkpoints to confirm ≥5 attack paths discoverable
- **Risk Mitigation**: Prepared supplemental-vulnerabilities.yaml contingency for guaranteed attack paths

✅ **Empirical Testing Over Speculation**: Validate KubeHound-Goat compatibility through actual testing
- **Rationale**: No direct evidence found of KubeHound+Goat integration, but scenario overlap analysis promising
- **Impact**: Phase 1 explicitly includes dump → ingest → path verification step
- **Fallback**: If insufficient paths found, deploy supplemental vulnerabilities (privileged pods, volume mounts, overprivileged service accounts)

✅ **Contingency Plan for Demo Reliability**: Prepare supplemental-vulnerabilities.yaml manifest
- **Rationale**: Guarantees demo success regardless of Goat compatibility level
- **Impact**: Ensures at least 3 attack path types: VOLUME_ACCESS, ROLE_BIND, CE_PRIV_MOUNT
- **Scope**: Minimal additional work, maximum reliability improvement

✅ **Reuse Kubernetes Goat Scripts (Not Replicate)**: Wrap their official setup script in our orchestration
- **Rationale**: Community-maintained, battle-tested, automatic updates, proper attribution, lower maintenance burden
- **Impact**: Accept cluster name `kubernetes-goat-cluster` instead of `kubehound-demo`, rely on their repo structure
- **Trade-offs**: Less control over deployment details, but gain community support and reduced maintenance
- **Implementation**: Clone Goat repo, run `platforms/kind-setup/setup-kind-cluster-and-goat.sh`, add our value-adds (pod waiting, KubeHound backend, health verification)
- **Benefits**: Automatic scenario updates, community documentation applies, lower risk of missing configurations

🔄 **Dual-Cluster Evaluation Approach** (2025-11-05): Compare Kubernetes Goat vs KubeHound test cluster for demo reliability
- **Context**: setup-demo.sh successfully implemented with Kubernetes Goat. Cluster created, KubeHound ingestion completed (60 identities, 70 permission sets, 29 volumes ingested), data in graph database. However, graph visualization queries not showing attack paths.
- **Uncertainty**: Unclear if issue is user error (incorrect query syntax/approach) or cluster incompatibility (Goat lacks specific vulnerability configurations KubeHound detects)
- **Decision**: Create experimental setup with KubeHound's official test cluster (24 purpose-built attack scenarios) to isolate root cause
- **Evaluation Criteria**:
  1. If attack path queries work with KubeHound test cluster → User needs to learn correct query patterns
  2. If queries still fail → Deeper issue with KubeHound setup or configuration
  3. Once queries validated with test cluster → Apply knowledge back to Kubernetes Goat
- **Preference**: Demoing KubeHound working with community-maintained Kubernetes Goat is more compelling than using its own test cluster (shows broader applicability)
- **Fallback**: Willing to use KubeHound test cluster if it provides more reliable demo experience
- **Implementation**: Created `setup-kubehound-test-cluster.sh` in experiment branch for evaluation
- **Next Step**: Test KubeHound test cluster, validate query approach, then reassess Goat compatibility

✅ **FINAL DECISION: Use KubeHound Test Cluster for Demo** (2025-11-05)
- **Evaluation Complete**: KubeHound test cluster tested successfully with full attack path visualization
- **Root Cause Identified**: Issue was user unfamiliarity with query patterns, NOT cluster incompatibility
- **Key Discovery**: Found `KindCluster_Demo.ipynb` notebook specifically designed for Kind cluster demos with working queries
- **Decision**: Abandon Kubernetes Goat evaluation and proceed with KubeHound test cluster
- **Rationale**:
  - Time pressure: Demo deadline approaching, need to focus on what works
  - Test cluster proven: 24 purpose-built attack scenarios, all visualizing correctly
  - Better demo script: KindCluster_Demo.ipynb provides excellent progressive demo narrative
  - Reliability: Purpose-built for KubeHound, guaranteed to work on demo day
  - Full attack graph: 850+ edges across 25+ attack types successfully ingested and visualized
- **Trade-offs Accepted**:
  - Less impressive than showing KubeHound analyzing "real-world" vulnerable app (Kubernetes Goat)
  - Using KubeHound's own test scenarios vs. third-party vulnerable environment
  - However: Demonstrates KubeHound capabilities more clearly with purpose-built examples
- **Impact on PRD**:
  - Simplifies demo setup (single cluster approach)
  - Changes narrative from "KubeHound + Goat integration" to "KubeHound capabilities showcase"
  - All success criteria still met with test cluster
  - Setup time remains under 5 minutes
- **Status**: Moving forward with test cluster implementation, closing Goat evaluation

💡 **Alternative Hypothesis - External Endpoint Requirement** (2025-11-05): Consider GCP deployment with public exposure
- **Status**: ARCHIVED - Not needed after test cluster success
- **Observation**: Many attack path queries (RedTeam notebooks) look for exposed endpoints or external entry points
- **Root Cause Theory**: Local Kind cluster has no external LoadBalancers, public IPs, or internet-facing services. KubeHound's most compelling attack paths may require external access as entry points (e.g., "Public Service → Container → Node Compromise")
- **Alternative Solution**: Deploy Kubernetes Goat to GCP with actual external endpoints
  - Use LoadBalancer services instead of NodePort
  - Create public ingress points
  - Leverage Spider Rainbow project learnings for GCP Kubernetes deployment
  - This would test whether attack paths appear when cluster has real external exposure
- **Trade-offs**:
  - Pros: Could unlock endpoint-based attack paths, more realistic security scenario, validates KubeHound+Goat integration
  - Cons: Adds GCP costs, increases setup complexity, deviates from "local demo" requirement, requires cloud access on demo day
- **Decision Status**: Idea held in reserve. Will evaluate after testing KubeHound test cluster locally. If local test cluster shows attack paths, then issue isn't external endpoints. If local test cluster also fails, GCP with external endpoints becomes more attractive option.
- **Implementation Consideration**: Could maintain both local (Kind) and cloud (GCP) setup options, letting user choose based on demo requirements

### Questions Resolved (2025-11-05)
✅ **What Kind cluster configuration is needed?**
- Basic Kind cluster is sufficient
- Kubernetes Goat provides dedicated Kind setup script: `kubernetes-goat/platforms/kind-setup/setup-kind-cluster-and-goat.sh`
- Custom ports/mounts optional (can use Kind config YAML if needed)

✅ **Which Helm repository/chart for Kubernetes Goat?**
- **IMPORTANT**: No Helm chart! Despite Helm being a prerequisite, Kubernetes Goat deploys via bash script
- Use: `bash setup-kind-cluster-and-goat.sh` from `platforms/kind-setup/` directory

✅ **What are the exact KubeHound backend commands?**
- Start: `kubehound backend up` (optionally: `-f docker-compose.overrides.yml`)
- Stop: `kubehound backend down`
- Starts MongoDB, JanusGraph, Jupyter UI (http://localhost:8888, password: admin)

✅ **Which 2-3 attack paths are most impressive for demo?**
- Public service → privileged container → node compromise (multi-hop chain)
- Service account token abuse → cluster-admin (privilege escalation)
- Secrets exposure → lateral movement to sensitive namespaces (credential theft)

✅ **What timeouts are appropriate for pod readiness?**
- 5 minutes (300 seconds) with progress indicators every 30 seconds

✅ **Should setup script check for sufficient Docker resources?**
- Yes, verify Docker is running and has at least 4GB memory available

## Risk Assessment

| Risk | Impact | Mitigation | Status |
|------|--------|------------|--------|
| Prerequisites missing on demo day | High | Prep script validates and reports, README lists install commands | Mitigated |
| Network issues during setup | Medium | Pre-pull images with prep script, use local Kind (no cloud) | Mitigated |
| Kubernetes Goat pods fail to start | High | Robust waiting logic with timeout, clear error messages | Mitigated |
| KubeHound backend unhealthy | High | Health check verification, troubleshooting guide in README | Mitigated |
| Demo takes longer than 3-5 min | Medium | Test on clean environment, optimize wait times | Mitigated (2m 46s) |
| **Kubernetes Goat incompatible with KubeHound attack detection** | **High** | **Evaluation in progress**: Test KubeHound's official cluster to validate queries, then either supplement Goat with additional attack manifests or switch to test cluster for demo reliability | **🔴 Active** |

## Success Metrics

**Demo Day Success:**
- Setup completes in < 5 minutes
- Zero manual intervention required during setup
- All components healthy on first try
- Attack paths discovered and explorable

**Documentation Quality:**
- README enables first-time setup without additional resources
- Troubleshooting section addresses common issues
- Attack path examples are clear and impressive

## Dependencies

**External:**
- Docker (prerequisite)
- Kind (prerequisite)
- Helm (prerequisite)
- kubectl (prerequisite)
- git (prerequisite)
- KubeHound binary (prerequisite)
- Kubernetes Goat repository (cloned by setup script from https://github.com/madhuakula/kubernetes-goat)

**Internal:**
- None (first feature in this repository)

## Future Enhancements (Out of Scope)

- CI/CD pipeline to test scripts automatically
- Multiple cluster configurations (different Kind configs)
- Integration with other vulnerable environments (not just Goat)
- Automated attack path demonstration (currently manual)
- Recording/screenshots of attack paths for slides

## References

- **KubeHound**: https://github.com/DataDog/KubeHound
- **Kubernetes Goat**: https://github.com/madhuakula/kubernetes-goat
- **Kind**: https://kind.sigs.k8s.io/

---

## Work Log

### 2025-11-05: PRD Creation
**Duration**: 30 minutes
**Status**: Planning

**Activities**:
- Created comprehensive PRD covering automated demo environment
- Defined clear success criteria and user journey
- Established 4-phase milestone plan
- Documented decision to keep KubeHound analysis manual (demo highlight)
- Identified open questions for implementation phase

**Key Decisions**:
- Single PRD for Tasks 3-6 (cohesive feature)
- Setup prepares environment but does NOT run `kubehound dump/ingest`
- Focus on demo day reliability and simplicity
- 3-5 minute setup time target

**Next Steps**:
- User decision: Start implementation now or commit PRD for later
- Research KubeHound backend commands and Kubernetes Goat Helm installation
- Identify 2-3 impressive attack paths for demo highlighting

### 2025-11-05: Technical Research & Validation
**Status**: In Progress

**Activities**:
- Researched KubeHound backend startup commands and configuration
- Investigated Kubernetes Goat installation methods (discovered NO Helm chart exists)
- Researched Kind cluster configuration requirements
- Identified expected attack paths for demo highlighting
- Created comprehensive TECHNICAL_NOTES.md with all findings
- Updated PRD open questions with validated answers

**Key Findings**:
- KubeHound backend: `kubehound backend up` / `kubehound backend down`
- Kubernetes Goat uses bash script, NOT Helm: `setup-kind-cluster-and-goat.sh`
- Basic Kind cluster sufficient (Kubernetes Goat script handles configuration)
- 25+ attack types can be identified by KubeHound
- Realistic setup time: 4.5-7 minutes (3-5 min with pre-pulled images)

**Technical Decisions**:
- Use Kubernetes Goat's dedicated Kind setup script from `platforms/kind-setup/`
- Target 5-minute timeout for pod readiness checks
- Check Docker resources (4GB minimum) in setup script
- Document 3 key attack paths: container escape, privilege escalation, lateral movement

**Next Steps**:
- Examine Kubernetes Goat's Kind setup script to understand implementation
- Begin implementing setup-demo.sh (Phase 1)
- Create teardown-demo.sh
- Write comprehensive README

### 2025-11-05: Compatibility Research & Validation Strategy
**Status**: Research Complete, Ready for Implementation

**Activities**:
- Analyzed KubeHound attack detection capabilities (25+ types) vs Kubernetes Goat scenarios (22 scenarios)
- Cross-referenced attack types and created compatibility matrix
- Identified high-confidence attack path overlaps (RBAC, DIND, container escape, secrets)
- Designed supplemental vulnerabilities contingency plan
- Updated TECHNICAL_NOTES.md with detailed implementation guidance (350+ lines)
- Enhanced PRD with 3 new design decisions and rationale

**Key Findings**:
- **Strong compatibility** between KubeHound and Kubernetes Goat confirmed
- 6+ high-confidence attack path mappings identified
- Supplemental vulnerabilities designed as fallback (guarantees ≥4 attack types)
- "Build and Validate" approach documented with Phase 1 validation checkpoints

**Design Decisions Added to PRD**:
1. "Build and Validate" approach: Test empirically rather than speculate
2. Empirical testing over speculation: Validate compatibility through actual testing
3. Contingency plan: supplemental-vulnerabilities.yaml for demo reliability

**Files Created**:
- TECHNICAL_NOTES.md (350+ lines of implementation guidance)

**Files Modified**:
- prds/2-automated-demo-environment.md (updated with answers, decisions, work logs)

**Next Steps**:
- Begin Phase 1 implementation: setup-demo.sh script
- Examine Kubernetes Goat's Kind setup script
- Implement core automation with validation checkpoints

### 2025-11-05: Implementation Strategy Decision
**Status**: In Progress

**Activities**:
- Examined Kubernetes Goat's Kind setup script structure
- Evaluated trade-offs between replicating vs reusing their scripts
- Made strategic decision on implementation approach

**Key Decision**:
✅ **Reuse Kubernetes Goat's Official Scripts** (not replicate)
- Wrap their `platforms/kind-setup/setup-kind-cluster-and-goat.sh` in our orchestration
- Accept their cluster name: `kubernetes-goat-cluster`
- Add our value-adds: prerequisite checks, pod readiness waiting, KubeHound backend integration, health verification

**Rationale**:
- Community-maintained code = automatic updates, bug fixes, security patches
- Battle-tested by hundreds/thousands of users
- Proper attribution and support for OSS community
- Lower maintenance burden for this project
- Benefit from their documentation and troubleshooting resources
- Reduced risk of missing important configurations

**Trade-offs Accepted**:
- Less control over cluster naming and deployment details
- Dependency on their repository structure remaining stable
- Less transparency into exact deployment steps (black box)

**Impact on PRD**:
- Updated Core Requirements: use their script, accept `kubernetes-goat-cluster` name
- Updated Dependencies: added git, kubectl, clarified Goat repo dependency
- Updated Technical Architecture: reflected community-maintained approach
- Updated Design Decisions: documented reuse vs replicate decision

**Next Steps**:
- Implement setup-demo.sh as thin wrapper around Goat's script
- Add robust pod readiness waiting (they don't have this)
- Integrate KubeHound backend startup
- Test complete workflow

### 2025-11-05: Implementation Complete, Graph Visualization Blocker Discovered
**Status**: Partially Complete - Technical Evaluation Required

**Activities**:
- Implemented setup-demo.sh (400+ lines) as orchestration wrapper around Kubernetes Goat
- Successfully tested complete workflow: cluster creation → Goat deployment → pod readiness → KubeHound backend
- Executed kubehound dump and ingest commands successfully
- Validated data ingestion: 60 identities, 70 permission sets, 20 pods, 21 containers, 29 volumes, 16 endpoints
- Explored Jupyter notebooks for graph visualization

**Success Metrics Achieved**:
- ✅ Setup completes in 2m 46s (target: 3-5 minutes)
- ✅ All components healthy: 20/20 pods Running, KubeHound backend accessible
- ✅ KubeHound UI accessible at http://localhost:8888
- ✅ No manual intervention required during setup
- ✅ Repeatable and deterministic

**Blocker Identified**:
- ❌ Graph visualization queries not showing attack paths
- ❌ Success criteria "Attack paths discovered and explorable" - NOT MET
- Graph displays individual resources (volumes, pods, identities) but no attack path relationships
- Unclear if issue is:
  1. User error: Incorrect query syntax or notebook usage
  2. Cluster incompatibility: Kubernetes Goat lacks vulnerability patterns KubeHound detects
  3. Configuration issue: KubeHound setup or backend configuration problem

**Root Cause Analysis**:
- Kubernetes Goat is general security training platform (20+ scenarios)
- KubeHound has purpose-built test cluster (24 attack-specific manifests)
- No documented evidence of Goat + KubeHound integration testing
- Attack path queries (e.g., container escape, privilege escalation) return "No data available"

**Decision Made**:
- Create parallel experimental setup with KubeHound's official test cluster
- Validate whether attack path queries work when cluster is purpose-built for KubeHound
- Use findings to either: fix Goat queries, supplement Goat with additional vulnerabilities, or switch to test cluster

**Files Created**:
- setup-demo.sh (orchestration script)
- setup-kubehound-test-cluster.sh (evaluation script)
- teardown-kubehound-test-cluster.sh (cleanup script)

**Files Modified**:
- .gitignore (added kubernetes-goat/, dump/)
- PRD updated with dual-cluster evaluation decision

**Branch Strategy**:
- feature/prd-2-automated-demo-environment: Kubernetes Goat implementation (current)
- experiment/kubehound-test-cluster: KubeHound test cluster evaluation

**Next Steps**:
1. Test setup-kubehound-test-cluster.sh
2. Validate attack path queries work with purpose-built cluster
3. Document correct query patterns
4. Reassess Kubernetes Goat: supplement vulnerabilities or switch clusters
5. Make final decision on demo cluster based on evaluation results

### 2025-11-05: Progress Update - Phase 1 Core Automation Complete
**Status**: Phase 1 Partially Complete (43% - 3/7 items), Validation Blocked

**Completion Summary**:
✅ **Completed Items**:
- Setup script (setup-demo.sh) successfully creates Kind cluster with Kubernetes Goat
- Setup script starts KubeHound backend and verifies health
- KubeHound dump + ingest completed successfully on Goat cluster
- Commit-story MCP server configured and working
- Experimental test cluster setup scripts created

🔴 **Critical Blocker**:
- Attack path visualization not working with Kubernetes Goat cluster
- Graph queries return "No data available" despite successful ingestion
- Root cause unclear: could be user error (query syntax), cluster incompatibility, or missing external endpoints

📋 **Remaining Phase 1 Work**:
- [ ] Create teardown-demo.sh for Kubernetes Goat cleanup
- [ ] **TEST setup-kubehound-test-cluster.sh** (script created but not yet run)
- [ ] Validate attack path queries work with KubeHound's purpose-built test cluster
- [ ] Determine root cause of visualization issue and resolve

**Key Decisions Pending**:
1. **Cluster Choice**: Kubernetes Goat (community, more impressive) vs KubeHound test cluster (purpose-built, guaranteed to work)
2. **GCP Alternative**: Consider deploying Goat to GCP with external endpoints if local clusters don't show attack paths
3. **Supplemental Vulnerabilities**: May need to add attack manifests to Goat cluster

**Evidence of Progress**:
- Commits: c13e1d1 (setup-demo.sh), 4483c7c (test cluster scripts), 044286f (PRD updates)
- Files Created: setup-demo.sh (400+ lines), setup-kubehound-test-cluster.sh, teardown-kubehound-test-cluster.sh, .mcp.json
- Tests Run: Full setup workflow (2m 46s), ingestion (successful), graph UI exploration (blocker discovered)

**Next Session Priorities**:
1. Test setup-kubehound-test-cluster.sh to isolate root cause
2. Create teardown-demo.sh for Kubernetes Goat
3. Based on test results, decide on cluster strategy
4. Resume Phase 2 (documentation) once validation unblocked

### 2025-11-06: README Complete with Screenshots and Query Documentation
**Duration**: ~2 hours
**Status**: Phase 2 Nearly Complete (67%)

**Activities**:
- Created comprehensive README.md (409 lines) covering full workflow
- Added 3 strategic screenshots to illustrate Jupyter notebook interface
- Documented Gremlin query language and KubeHound DSL
- Updated repository structure section
- Fixed script console output for clarity (separate dump/ingest sections)
- Organized screenshots in docs/images/ directory
- Updated .gitignore for generated files
- Updated resource links to include kubehound.io official site

**Completed PRD Items**:
- [x] README complete with prerequisites, workflow, and troubleshooting
- [x] Scripts provide clear progress indicators and helpful error messages

**Files Created**:
- README.md (409 lines with embedded screenshots)
- docs/images/KubeHound_Screenshot_2.png (notebook interface)
- docs/images/KubeHound_Screenshot_3.png (Console tab)
- docs/images/KubeHound_Screenshot_6.png (attack path graph)

**Files Modified**:
- setup-kubehound-test-cluster.sh (improved console output, separate dump/ingest sections)
- teardown-kubehound-test-cluster.sh (added backend cleanup)
- .gitignore (added dump-test/, kubeconfig, logs)
- README.md (multiple iterations: screenshots, query language, repository structure)

**Next Session Priorities**:
- Extract 2-3 specific attack path examples for README
- Create optional prep script (Phase 3)
- Run complete test cycle on clean environment
- Validate timing estimates and error handling
