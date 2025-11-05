---
issue: 2
title: Automated Demo Environment for KubeHound Presentation
status: Open
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

### Phase 1: Core Automation
- [ ] Setup script creates Kind cluster and deploys Kubernetes Goat successfully
- [ ] Setup script starts KubeHound backend and verifies health
- [ ] Teardown script cleanly removes all resources

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
✅ **Use Kind (not GCP)**: Local, fast, deterministic, no cloud costs
✅ **Use Kubernetes Goat**: Industry-standard vulnerable environment with 22 scenarios
✅ **Manual KubeHound analysis**: `dump` and `ingest` run live during demo (not in setup script)
✅ **One PRD**: Tasks 3-6 are cohesive "demo environment" feature

### Questions to Resolve During Implementation
- What Kind cluster configuration is needed? (extra mounts, ports, etc.)
- Which Helm repository/chart for Kubernetes Goat? (official madhuakula repo)
- What are the exact KubeHound backend commands? (`kubehound backend up`?)
- Which 2-3 attack paths are most impressive for demo? (research during implementation)
- What timeouts are appropriate for pod readiness? (5 min?)
- Should setup script check for sufficient Docker resources? (memory, CPU)

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
