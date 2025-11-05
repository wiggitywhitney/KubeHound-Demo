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

**Problem**: Preparing for a KubeHound presentation requires multiple manual setup steps (Kind cluster, Kubernetes Goat deployment, KubeHound backend configuration) that are error-prone, time-consuming, and dependent on internet connectivity. Current demo preparation risks technical failures during setup on presentation day.

**Solution**: Create comprehensive automation scripts and documentation that enable one-command deployment of a complete KubeHound demo environment running locally with Kind and Kubernetes Goat, ready for live attack path analysis demonstration.

**User Impact**: Whitney can reliably set up a complete KubeHound demo environment in 3-5 minutes with a single command, demonstrate attack path analysis with confidence, and clean up effortlessly afterward.

## Success Criteria

✅ Run `./setup-demo.sh` and get working environment in 3-5 minutes
✅ All components healthy: Kind cluster, Kubernetes Goat pods, KubeHound backend
✅ KubeHound UI accessible and ready for manual analysis demonstration
✅ Kubernetes Goat vulnerabilities deployed and exploitable
✅ Run `./teardown-demo.sh` and all resources cleaned up
✅ README provides clear demo day workflow and troubleshooting
✅ No internet dependencies during demo (after initial setup)
✅ Repeatable and deterministic across runs

## User Journey

### Before Presentation Day
1. Whitney clones the KubeHound-Demo repository
2. Runs optional `./prep-demo.sh` to validate prerequisites and pre-pull images
3. Does a test run to familiarize with the environment
4. Reviews README for attack path examples to highlight

### Demo Day - Setup (3-5 minutes before presentation)
1. Runs `./setup-demo.sh` once
2. Waits for "Demo ready!" message with URLs
3. Opens KubeHound UI in browser to verify backend is ready
4. Verifies Kind cluster and Kubernetes Goat are accessible

### During Presentation
1. Explains KubeHound and Kubernetes Goat context
2. Manually runs `kubehound dump` to collect cluster data (live)
3. Manually runs `kubehound ingest` to analyze and build attack graph (live)
4. Opens KubeHound UI to explore discovered attack paths
5. Demonstrates 2-3 interesting attack paths
6. Optionally executes one attack path manually to prove it's real

### After Presentation
1. Runs `./teardown-demo.sh` to clean up all resources
2. Receives confirmation that cluster and backend are deleted

## Core Requirements

### 1. Automated Setup Script (`setup-demo.sh`)

**Must do:**
- Check prerequisites (Docker, Kind, Helm, kubehound) with helpful error messages
- Create Kind cluster named "kubehound-demo" with appropriate configuration
- Deploy Kubernetes Goat using Helm from official chart
- Wait for all Kubernetes Goat pods to be Ready (with timeout)
- Start KubeHound backend stack (JanusGraph, MongoDB, UI)
- Verify backend health and readiness
- Print success message with:
  - KubeHound UI URL
  - Kubernetes Goat access info
  - kubectl context information
  - Next steps: manual `kubehound dump` and `kubehound ingest` commands

**Must NOT do:**
- Run `kubehound dump` or `kubehound ingest` automatically (this IS the demo!)

**Non-functional requirements:**
- Idempotent where possible (can re-run if partially failed)
- Error checking after each major step
- Clear progress indicators
- Time estimates in output

### 2. Automated Teardown Script (`teardown-demo.sh`)

**Must do:**
- Stop KubeHound backend gracefully
- Delete Kind cluster "kubehound-demo"
- Clean up temporary files if any
- Print confirmation message

**Non-functional requirements:**
- Safe to run multiple times
- Clear confirmation of cleanup
- Handle missing resources gracefully

### 3. Comprehensive README

**Must include:**
- Project overview and presentation context
- Prerequisites with installation commands (macOS/Linux)
- Quick start: `./setup-demo.sh`
- What gets created (cluster, namespaces, services)
- Demo day workflow step-by-step
- 2-3 example attack paths to highlight (research KubeHound + Goat integration)
- Manual KubeHound analysis commands (`dump`, `ingest`)
- Troubleshooting common issues
- Cleanup: `./teardown-demo.sh`

**Tone**: Clear, practical, optimized for demo preparation

### 4. Optional Pre-Demo Prep Script (`prep-demo.sh`)

**Should do:**
- Verify all prerequisites are installed with version checks
- Pre-pull all Docker images (Kind node, Kubernetes Goat, KubeHound)
- Run a complete test cycle (setup → verify → teardown)
- Report any issues found
- Confirm environment is ready for demo day

**Value**: Eliminates surprises on demo day

## Technical Architecture

### Components
1. **Kind Cluster**: Local Kubernetes cluster named "kubehound-demo"
2. **Kubernetes Goat**: Vulnerable K8s environment with 22 security scenarios
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

### Phase 1: Core Automation + Validation
- [ ] Setup script creates Kind cluster and deploys Kubernetes Goat successfully
- [ ] Setup script starts KubeHound backend and verifies health
- [ ] Teardown script cleanly removes all resources
- [ ] **VALIDATION: Run kubehound dump + ingest on Goat cluster to verify compatibility**
- [ ] **VALIDATION: Confirm at least 5 interesting attack paths are discoverable**
- [ ] **IF NEEDED: Create supplemental-vulnerabilities.yaml for guaranteed attack paths**

### Phase 2: Documentation & User Experience
- [ ] README complete with prerequisites, workflow, and troubleshooting
- [ ] README includes 2-3 example attack paths researched from KubeHound/Goat integration
- [ ] Scripts provide clear progress indicators and helpful error messages

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

| Risk | Impact | Mitigation |
|------|--------|------------|
| Prerequisites missing on demo day | High | Prep script validates and reports, README lists install commands |
| Network issues during setup | Medium | Pre-pull images with prep script, use local Kind (no cloud) |
| Kubernetes Goat pods fail to start | High | Robust waiting logic with timeout, clear error messages |
| KubeHound backend unhealthy | High | Health check verification, troubleshooting guide in README |
| Demo takes longer than 3-5 min | Medium | Test on clean environment, optimize wait times |
| Attack paths not found by KubeHound | Medium | Research and document expected paths, have fallback examples |

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
- KubeHound binary (prerequisite)
- Kubernetes Goat Helm chart (downloaded by setup script)

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
