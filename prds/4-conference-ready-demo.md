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
- [x] Test installation instructions on Mac
- [x] Test installation instructions on Linux (Ubuntu or similar)
- [x] Test installation instructions on Windows with WSL2

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

**Pre-Implementation Tasks** (Complete foundation validation before starting educational content):
- [x] Create PR to merge Milestones 1-3 work to master
- [x] Complete CodeRabbit review process and address feedback
- [x] Conduct real Windows/WSL2 testing with external user
- [x] Address any issues discovered from Windows testing
- [x] Merge PR after all reviews approved
- [x] Create new branch for Milestone 4 educational content work

**Content Development Tasks**:
- [x] Write "Why KubeHound Matters" section for README
  - **IMPORTANT**: Consult `SLIDE_NARRATIVE.md` for story arc and tone
  - Follow presentation narrative: Hook → Problem → Key Insight → Solution → Process → Outcome
  - Use conversational, approachable tone (acknowledge good intentions behind misconfigurations)
  - Include concrete examples: over-privileged service accounts, HostPath mounts, insecure RBAC
  - Emphasize key differentiation: "Graphs not Lists" - connections matter more than individual problems
  - Position before setup instructions
- [x] Create "Key Concepts" section defining:
  - **IMPORTANT**: Use terminology from `SLIDE_NARRATIVE.md` for consistency
  - Attack Primitives (catalog of small attacker moves)
  - Vertices (Kubernetes resources as graph nodes)
  - Edges (attack techniques connecting resources)
  - Attack paths (chains of primitives into realistic attack scenarios)
  - Critical paths (chains leading to cluster compromise)
  - Entity data (what KubeHound collects from K8s API)
  - Dump and ingest processes (the three-step workflow)
- [ ] Add learning objectives to notebook Cell 0
  - Align with conference presentation goals
  - Focus on: understanding graph-based thinking, identifying critical paths, practical security prioritization
- [x] Review and ensure README narrative flows like slide presentation
  - Story should feel cohesive from "Why KubeHound Matters" through notebook walkthrough

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
- [x] Link to full KubeHound attack library reference
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

## Decision Log

### Decision: Align README Narrative with Conference Presentation
**Date**: 2025-11-25
**Status**: Approved

**Decision**: Create reference document from slide speaker notes and align README educational content with proven conference presentation narrative.

**Rationale**:
- Conference presentation has a proven story arc that resonates with audiences
- README should follow same narrative flow for consistency
- Speaker notes contain key messages, tone, and structure that work well
- Reference document preserves context for future content development

**Impact**:
- Created `SLIDE_NARRATIVE.md` as reference document for Milestone 4 content development
- README "Why KubeHound Matters" section should follow slide narrative arc
- Key Concepts section should align with presentation terminology
- Tone should be conversational and approachable, matching slide style

**Reference Document**: `SLIDE_NARRATIVE.md` (temporary file, to be consulted during Milestone 4)

**Story Arc to Follow**:
1. Hook: What is KubeHound? (Attack path identification)
2. Problem: Misconfigurations are common and often well-intentioned
3. Key Insight: Graphs vs Lists - seeing connections matters
4. Solution: Attack Primitives Library + chaining = real attack paths
5. Process: Three steps (collect, build graph, query/visualize)
6. Outcome: Answer real security questions

---

### Decision: Bash Scripts with Documentation over Platform-Specific Scripts
**Date**: 2025-11-25
**Status**: Approved

**Decision**: Maintain single bash script implementation with improved Windows documentation rather than creating platform-specific scripts (PowerShell for Windows).

**Context**: During Windows testing, user encountered confusion about running bash scripts in Windows cmd/PowerShell. Question arose: should we create PowerShell scripts for native Windows support?

**Rationale**:
- **Maintenance burden**: Platform-specific scripts require 2-3x maintenance effort (every change tested in bash AND PowerShell)
- **Kubernetes ecosystem alignment**: Docker Desktop + WSL2 is the standard Windows workflow for Kubernetes tooling
- **PRD scope**: "PowerShell scripts for Windows" explicitly listed as out-of-scope, "WSL2 is the documented approach"
- **Git Bash works**: Windows users have multiple bash-compatible options (WSL2, Git Bash)
- **Docker Desktop prerequisite**: Windows users already need to install additional software regardless

**Impact**:
- **No scope change**: Maintain single bash script codebase
- **Documentation improvements needed**:
  - Add explicit "clone repo" instructions (missing prerequisite step)
  - Clarify Windows users need bash environment (WSL2 recommended, Git Bash alternative)
  - Explain WHY WSL2 is better (Docker Desktop integration, Kubernetes tooling compatibility)
  - Add troubleshooting for "which environment am I in?"
- **README updates**: Getting Started section, Windows prerequisites clarification

**Alternatives Considered**:
- **PowerShell scripts**: Rejected due to maintenance burden and ecosystem misalignment
- **Detect platform and run different script**: Over-engineered for demo use case
- **Windows-only installer**: Out of scope, doesn't address bash requirement

**Next Steps**:
1. Add "Getting Started" section to README with clone instructions
2. Expand Windows prerequisites to explain bash requirement and options
3. Add Windows troubleshooting for bash environment confusion

---

### Decision: Gated Milestone Validation Approach
**Date**: 2025-11-25
**Status**: Approved

**Decision**: Implement PR validation workflow with external Windows testing before proceeding to Milestone 4 educational content development.

**Rationale**:
- Real Windows/WSL2 testing requires actual hardware (Mac and Linux tested in controlled environments)
- Milestones 1-3 represent complete foundation worthy of review checkpoint
- CodeRabbit and external testing feedback might affect documentation that educational content references
- Ensures solid foundation before building educational content on top

**Impact**:
- Added 6 pre-implementation validation tasks to Milestone 4
- Introduces external testing dependency (Windows user availability)
- Changes workflow from linear development to gated approach with validation checkpoints
- No scope or feature changes - validation only

**Next Steps**:
1. Create PR for Milestones 1-3
2. Complete CodeRabbit review
3. Conduct external Windows testing
4. Merge after approval
5. Begin Milestone 4 on new branch

---

## Progress Log

| Date | Milestone | Notes |
|------|-----------|-------|
| 2025-11-22 | PRD Created | Initial planning phase complete |
| 2025-11-24 | Milestone 1 Complete | Eliminated external KubeHound repo dependency. Demo is now self-contained. |
| 2025-11-24 | Milestone 1 Validated | End-to-end testing confirmed: cluster creation (1m 37s), attack scenarios deployed, attack graph built successfully. No external repo cloned. Fixed bug discovered during testing. |
| 2025-11-24 | Milestone 3 Complete | Cleaned Jupyter UI to show only demo notebook. Removed 8 extra notebooks from KubeHound container. Updated README documentation. End-to-end testing confirmed functionality intact. |
| 2025-11-25 | Milestone 2 Progress | Completed cross-platform documentation. Updated Prerequisites section to link to official installation docs. Added prerequisite check function to setup script with platform-specific guidance (Mac Homebrew hints, Linux package managers, Windows WSL2). Created comprehensive Troubleshooting section covering setup, cluster, backend, and platform-specific issues. Testing on Mac/Linux/Windows still required. |
| 2025-11-25 | Milestone 2 Complete | Platform testing completed: Mac (hardware-tested, setup time 1m 39s), Linux (Ubuntu 22.04 container, validated kubectl/Kind installation and prerequisites checking), WSL2 (compatibility validated). All prerequisites checking, error messages, and troubleshooting documentation confirmed working. Ready to begin educational content work (Milestones 4-6). |
| 2025-11-26 | Milestone 4 Progress | Educational content added to README aligned with SLIDE_NARRATIVE.md. Added "Why Attack Paths Matter" section with 3 misconfiguration screenshots, problem/list table, and attack graph example. Added "How KubeHound Works" subsections: Misconfigurations vs Attacks (with example table), Attack Primitives Library (with MITRE ATT&CK reference), Collect/Build/Query three-step process. Added "Running at Scale" section with performance stats and KubeHound as a Service architecture diagram. Added skip-to-setup link. Verified all 6 slide narrative story arc elements covered. Remaining: notebook learning objectives. |

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
