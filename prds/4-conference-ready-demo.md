# PRD: Conference-Ready KubeHound Demo

**Status**: In Progress
**Priority**: High
**GitHub Issue**: [#4](https://github.com/wiggitywhitney/KubeHound-Demo/issues/4)
**Created**: 2025-11-22
**Last Updated**: 2025-11-24

---

## Problem Statement

The KubeHound demo repository is intended for use as a **prepared talk** in Datadog's conference presentation library. When Datadog sponsors events and receives speaking slots, any engineer in that region should be able to:

1. Pick up this demo with zero prior KubeHound knowledge
2. Understand it well enough to present it confidently
3. Deliver a compelling conference talk

Additionally, audience members who attend the talk should be able to:

1. Visit the repository
2. Run through the demo on their own machine
3. Gain a solid understanding of what KubeHound does and why it matters

**Current gaps preventing this goal:**

- **Platform compatibility unclear**: Setup instructions show Mac-specific installation (`brew install`). Scripts are bash-only. No guidance for Linux or Windows users.
- **External dependencies**: Requires cloning the entire KubeHound repository (~100MB, 30+ seconds) just to use 2 YAML files and a cluster creation script.
- **Cluttered notebook experience**: Users accessing the Jupyter UI see 9 notebooks from the KubeHound repo, but only 1 is relevant to this demo. This creates confusion about which notebook to use.
- **Missing educational content**: The demo shows HOW to use KubeHound but doesn't explain WHY attack paths matter or WHAT to do about them. Critical concepts like "attack paths," "critical paths," and attack type abbreviations (CE_PRIV_MOUNT, TOKEN_STEAL, etc.) are undefined.
- **No newcomer onboarding**: Someone with zero KubeHound knowledge can run the demo but won't understand the security implications or how to interpret results.

---

## Success Criteria

This PRD is complete when:

1. ✅ The demo repository is self-contained (no external repo cloning required)
2. ✅ Setup instructions clearly document requirements for Mac, Linux, and Windows
3. ✅ Jupyter UI shows only the relevant demo notebook
4. ✅ README and notebook include educational content explaining:
   - Why attack paths matter (risk narrative)
   - What core KubeHound concepts mean (vertices, edges, critical paths)
   - How to interpret attack types (CE_PRIV_MOUNT, TOKEN_STEAL, etc.)
   - How to read attack path graphs
   - What to do with discovered vulnerabilities
5. ✅ A newcomer with Kubernetes knowledge but zero KubeHound experience can complete the demo and understand:
   - What KubeHound analyzes
   - Why attack path analysis matters for security
   - How to interpret results
   - Basic remediation approaches
6. ✅ Human evaluation: Whitney approves the experience as conference-ready

---

## Proposed Solution

Transform the KubeHound demo into a **self-contained, cross-platform, educational experience** suitable for repeated use as a conference prepared talk.

### Key Changes

1. **Eliminate External Dependencies**
   - Copy necessary YAML files from KubeHound repo into this repo
   - Replace `manage-cluster.sh` dependency with direct `kind create cluster` commands
   - Remove git clone step from setup script

2. **Cross-Platform Support**
   - Document platform-specific installation for Mac, Linux, Windows
   - For Windows: document WSL2 as requirement (standard for Kubernetes work)
   - Test setup on all three platforms

3. **Clean Notebook Experience**
   - Modify setup script to remove irrelevant notebooks from Jupyter container
   - Ensure users see only KindCluster_Demo.ipynb when accessing UI

4. **Educational Content Improvements**
   - Add risk narrative explaining why attack paths matter
   - Create attack type glossary with definitions and remediation examples
   - Expand graph interpretation guide with annotated examples
   - Define core terminology (vertices, edges, paths, critical paths) upfront
   - Add learning objectives to notebook
   - Include remediation guidance in notebook

5. **Documentation Enhancements**
   - Restructure README to support newcomer learning journey
   - Add troubleshooting section for common issues
   - Standardize terminology throughout

---

## Milestones

### Milestone 1: Eliminate External Dependencies

**Goal**: Make the demo self-contained by removing the KubeHound repository clone requirement.

**Tasks**:
- [x] Copy `cluster.yaml` from KubeHound repo to `cluster-config/kind-cluster.yaml`
- [x] Copy `ENDPOINT_EXPLOIT.yaml` from KubeHound repo to `attacks/ENDPOINT_EXPLOIT.yaml`
- [x] Modify `setup-kubehound-test-cluster.sh` to use local YAML files
- [x] Replace `manage-cluster.sh` dependency with direct `kind create cluster` command
- [x] Remove repository cloning code from setup script
- [x] Update teardown script to reflect removed clone step
- [x] Test that setup works without cloning external repo

**Success Criteria**: Setup completes successfully without cloning KubeHound repository. All functionality works as before.

---

### Milestone 2: Cross-Platform Support Documentation

**Goal**: Provide clear installation instructions for Mac, Linux, and Windows platforms.

**Tasks**:
- [x] Document Mac prerequisites with `brew install` commands
- [x] Document Linux prerequisites with package manager options (apt, yum, dnf)
- [x] Document Windows prerequisites using WSL2
- [x] Add platform-specific notes for Docker Desktop installation
- [x] Create troubleshooting section for platform-specific issues
- [ ] Test installation instructions on Mac
- [ ] Test installation instructions on Linux (Ubuntu or similar)
- [ ] Test installation instructions on Windows with WSL2

**Success Criteria**: Engineers on Mac, Linux, and Windows can follow documented instructions to successfully run the demo.

---

### Milestone 3: Clean Jupyter Notebook Experience

**Goal**: Remove clutter from Jupyter UI so users see only the relevant demo notebook.

**Tasks**:
- [x] Identify which notebooks from KubeHound repo appear in Jupyter UI
- [x] Modify setup script to remove unwanted notebooks after container startup
- [x] Verify that KindCluster_Demo.ipynb is still accessible and functional
- [x] Test that removed notebooks don't break any container functionality
- [x] Update README to reflect simplified notebook experience

**Success Criteria**: When users access http://localhost:8888 and navigate to `kubehound_presets/`, they see only KindCluster_Demo.ipynb.

---

### Milestone 4: Risk Narrative and Core Concepts

**Goal**: Help users understand WHY attack paths matter and define key terminology.

**Tasks**:
- [ ] Write "Why KubeHound Matters" section for README
  - Include concrete attack scenario (endpoint → container → node compromise)
  - Explain business impact and security implications
  - Position before setup instructions
- [ ] Create "Key Concepts" section defining:
  - Vertices (Kubernetes resources as graph nodes)
  - Edges (attack techniques connecting resources)
  - Attack paths (chains of attack techniques)
  - Critical paths (chains leading to cluster compromise)
  - Dump and ingest processes
- [ ] Add learning objectives to notebook Cell 0
- [ ] Review and ensure risk narrative connects to notebook walkthrough

**Success Criteria**: A newcomer reading the README understands why attack path analysis matters before starting the demo. Core terminology is defined and referenced consistently.

---

### Milestone 5: Attack Type Glossary and Graph Interpretation

**Goal**: Demystify attack type abbreviations and teach users how to read visual attack graphs.

**Tasks**:
- [ ] Create attack type reference table with columns:
  - Attack type abbreviation (CE_PRIV_MOUNT, TOKEN_STEAL, etc.)
  - Plain English explanation
  - Why it matters for security
  - Example remediation
- [ ] Include at least: CE_PRIV_MOUNT, VOLUME_ACCESS, TOKEN_STEAL, ROLE_BIND, IDENTITY_ASSUME, ENDPOINT_EXPLOIT
- [ ] Link to full KubeHound attack library reference
- [ ] Expand "Understanding Attack Path Graphs" section:
  - Add step-by-step guide for reading graphs (left to right, follow arrows)
  - Include annotated example showing attack chain interpretation
  - Explain what to do when finding specific attack types
- [ ] Add examples of good vs bad findings

**Success Criteria**: Users encountering attack type abbreviations in results can look them up and understand what they mean. Users viewing graph visualizations can interpret the attack chains.

---

### Milestone 6: Remediation Guidance and Learning Outcomes

**Goal**: Connect discovered vulnerabilities to actionable remediation steps.

**Tasks**:
- [ ] Add remediation guidance cell to notebook (before congratulations section)
- [ ] Include remediation examples for common findings:
  - Exposed endpoints with critical paths → network policies
  - Privileged containers → security contexts
  - Excessive RBAC permissions → least privilege principle
- [ ] Add "What to do next" section to README
- [ ] Include links to Kubernetes security best practices
- [ ] Add troubleshooting section for common setup issues
- [ ] Ensure notebook conclusion reinforces learning objectives

**Success Criteria**: After completing the demo, users understand not just WHAT vulnerabilities exist but WHAT TO DO about them. The learning journey has clear beginning, middle, and end.

---

### Milestone 7: Documentation Polish and Validation

**Goal**: Ensure all documentation is clear, consistent, and complete.

**Tasks**:
- [ ] Review README for terminology consistency
- [ ] Standardize use of terms: "attack scenarios" vs "attacks", "dump" vs "data collection"
- [ ] Add glossary if needed
- [ ] Ensure all links work (KubeHound docs, GitHub repo, external references)
- [ ] Add troubleshooting section with common failure modes:
  - Docker not running
  - Jupyter UI timeout
  - Backend health check failures
  - Cluster creation issues
- [ ] Proofread all content for clarity and accuracy
- [ ] Test complete flow end-to-end on fresh machine
- [ ] Validate newcomer experience with someone unfamiliar with KubeHound
- [ ] Get final approval from Whitney

**Success Criteria**: Documentation is polished, consistent, and complete. Newcomer testing validates that learning objectives are met. Whitney approves the demo as conference-ready.

---

## User Experience Flow (Target State)

### For a Conference Presenter

1. **Discovery**: Find KubeHound demo in Datadog's prepared talk library
2. **Learning**: Read README to understand what KubeHound does and why it matters
3. **Setup**: Follow platform-specific instructions to install prerequisites
4. **Practice**: Run setup script, complete notebook walkthrough
5. **Understanding**: Grasp key concepts well enough to present confidently
6. **Delivery**: Present at conference with demo as visual aid

**Time investment**: 1-2 hours to understand and practice

### For a Conference Attendee

1. **Discovery**: Visit GitHub repo after conference talk
2. **Prerequisites**: Install Docker, Kind, kubectl, KubeHound CLI
3. **Setup**: Run one-command setup script (`./setup-kubehound-test-cluster.sh`)
4. **Exploration**: Open Jupyter UI, navigate to notebook, run cells sequentially
5. **Learning**: Understand attack path concepts through progressive filtering approach
6. **Interpretation**: Read attack type glossary and graph interpretation guide to understand results
7. **Action**: Learn basic remediation approaches for discovered vulnerabilities

**Time investment**: 30-60 minutes for complete demo

---

## Technical Approach

### Self-Contained Repository Structure

```
KubeHound-Demo/
├── README.md                          # Enhanced with educational content
├── setup-kubehound-test-cluster.sh    # Modified to use local files
├── teardown-kubehound-test-cluster.sh # Updated cleanup
├── KindCluster_Demo_v2.ipynb          # Existing demo notebook
├── cluster-config/
│   └── kind-cluster.yaml              # Copied from KubeHound repo
├── attacks/
│   └── ENDPOINT_EXPLOIT.yaml          # Copied from KubeHound repo
├── scripts/
│   └── common.sh                      # Existing shared utilities
└── prds/
    └── 4-conference-ready-demo.md     # This file
```

### Key Implementation Details

**Setup Script Changes**:
```bash
# OLD: Clone repo and use manage-cluster.sh
cd "$KUBEHOUND_REPO/test/setup"
CLUSTER_NAME="$CLUSTER_NAME" bash manage-cluster.sh create 2>/dev/null || true

# NEW: Direct Kind cluster creation
kind create cluster \
  --name "$CLUSTER_NAME" \
  --config "$SCRIPT_DIR/cluster-config/kind-cluster.yaml"
kind get kubeconfig --name "$CLUSTER_NAME" > "$REPO_ROOT/$KUBECONFIG_FILE"
```

**Notebook Cleanup**:
```bash
# After backend startup, remove unwanted notebooks
docker exec kubehound-release-ui-jupyter-1 bash -c \
  "cd /kubehound/notebooks/kubehound_presets && \
   find . -name '*.ipynb' ! -name 'KindCluster_Demo.ipynb' -delete"
```

**Platform Documentation Structure**:
```markdown
## Prerequisites

### macOS
```bash
brew install docker kind kubectl
# Install KubeHound CLI
```

### Linux (Ubuntu/Debian)
```bash
sudo apt-get install docker.io kubectl
# Install Kind
# Install KubeHound CLI
```

### Windows (WSL2)
```bash
# Enable WSL2 and install Ubuntu
# Follow Linux instructions inside WSL2
```
```

---

## Dependencies

**External Tools** (user must install):
- Docker Desktop (or Docker Engine on Linux)
- Kind (Kubernetes in Docker)
- kubectl
- KubeHound CLI

**External Repositories** (referenced, not cloned):
- KubeHound documentation (linked for reference)
- Kubernetes security best practices (linked)

**Internal Dependencies**:
- None (self-contained after copying YAML files)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|-----------|------------|
| KubeHound attack YAML changes upstream | Demo breaks | Low | Test periodically; YAMLs are stable test fixtures |
| Platform-specific setup failures | Poor user experience | Medium | Thorough testing on all platforms; detailed troubleshooting docs |
| Jupyter container changes break notebook cleanup | Notebooks reappear | Low | Test after KubeHound backend updates |
| Educational content becomes outdated | Confusion | Low | Review when KubeHound releases major versions |
| WSL2 requirement too complex for Windows users | Reduced Windows adoption | Medium | Document clearly; WSL2 is standard for Kubernetes work |

---

## Out of Scope

The following are explicitly **not** part of this PRD:

- **Presenter materials**: Speaker notes, talking points, slide decks (separate effort)
- **Additional attack scenarios**: Only ENDPOINT_EXPLOIT is included (other 23 scenarios can be added later)
- **Video tutorial**: Screencast or video walkthrough (may be added later)
- **CI/CD integration**: Automated testing of demo setup (nice-to-have for future)
- **Advanced KubeHound features**: Focus is on basics; advanced queries are out of scope
- **Custom attack scenarios**: Using clusters other than KubeHound's test cluster
- **Multi-cluster demos**: Single cluster only for simplicity
- **PowerShell scripts for Windows**: WSL2 is the documented approach

---

## Open Questions

None at this time. All decisions have been made.

---

## Progress Log

| Date | Milestone | Notes |
|------|-----------|-------|
| 2025-11-22 | PRD Created | Initial planning phase complete |
| 2025-11-24 | Milestone 1 Complete | Eliminated external KubeHound repo dependency. Demo is now self-contained. |
| 2025-11-24 | Milestone 1 Validated | End-to-end testing confirmed: cluster creation (1m 37s), attack scenarios deployed, attack graph built successfully. No external repo cloned. Fixed bug discovered during testing. |
| 2025-11-24 | Milestone 3 Complete | Cleaned Jupyter UI to show only demo notebook. Removed 8 extra notebooks from KubeHound container. Updated README documentation. End-to-end testing confirmed functionality intact. |
| 2025-11-25 | Milestone 2 Progress | Completed cross-platform documentation. Updated Prerequisites section to link to official installation docs. Added prerequisite check function to setup script with platform-specific guidance (Mac Homebrew hints, Linux package managers, Windows WSL2). Created comprehensive Troubleshooting section covering setup, cluster, backend, and platform-specific issues. Testing on Mac/Linux/Windows still required. |

---

## References

- [KubeHound Official Documentation](https://kubehound.io/)
- [KubeHound GitHub Repository](https://github.com/DataDog/KubeHound)
- [KubeHound Attack Library Reference](https://kubehound.io/reference/attacks/)
- [Kind Documentation](https://kind.sigs.k8s.io/)
- [Kubernetes Security Best Practices](https://kubernetes.io/docs/concepts/security/)

---

## Notes

This PRD focuses on making the demo **conference-ready** for repeated use in Datadog's prepared talk library. The emphasis is on:

1. **Self-service**: Any engineer can pick it up and present it
2. **Educational**: Audience members learn KubeHound fundamentals
3. **Reliable**: Works consistently across platforms
4. **Self-contained**: No complex external dependencies

The prepared talk model means this demo will be used multiple times by different presenters. Therefore, clarity, completeness, and ease of use are paramount.
