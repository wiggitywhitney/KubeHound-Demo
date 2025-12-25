# PRD #7: Prepared Talk Standards Compliance Review

**Status**: In Progress (Milestones 1-6 complete, ready for recording)
**Priority**: Low (Target: before 2024-12-23)
**GitHub Issue**: [#7](https://github.com/wiggitywhitney/KubeHound-Demo/issues/7)
**Created**: 2025-11-26

---

## Problem Statement

The KubeHound demo repository will be central to a prepared talk at Datadog. Before submission to the Prepared Talks Catalog, all materials must be validated against Datadog's internal standards:

1. **Content Guidelines** - Modern tech, value for all attendees, no product pitches
2. **Datadog Identity** - Tone, messaging, brand alignment
3. **Speaker Enablement** - Documentation and resources for other speakers

**Current State**: Demo is functionally complete but hasn't been validated against prepared talk standards.

**Risk**: Non-compliant content could require extensive rework after recording, presentation submission, or catalog addition.

---

## Solution Overview

Conduct comprehensive compliance review of all demo materials against three internal guideline documents:
- `internal-docs/writing-prepared-talk.md` - Content creation guidelines
- `internal-docs/prepared-talks-guidelines.md` - Reviewing and refreshing process
- `internal-docs/datadog-identity.md` - Brand voice and personality

**Materials to Review**:
- `README.md` - Primary documentation
- `KindCluster_Demo_v2.ipynb` - Jupyter notebook with demo walkthrough
- `SLIDE_NARRATIVE.md` - Conference presentation speaker notes (reference for narrative alignment)
- Google Slides deck (external, link TBD)

Fix any compliance issues found, then record presentation as final validation artifact.

---

## Success Criteria

- [x] All content aligns with Datadog Identity (`internal-docs/datadog-identity.md`)
- [x] Demo provides value for ALL attendees (customers, non-customers, competitors' users)
- [x] No product pitches, extensive demos, or infomercial content
- [x] All images properly credited with source URLs
- [x] All statistics/data properly sourced
- [x] No buzzwords, management-speak, empty superlatives, or competitor bashing
- [x] Google Slides deck includes speaker notes and uses official Datadog template
- [ ] Presentation recorded and ready for speaker reference
- [ ] Materials ready for Prepared Talks Catalog submission

---

## Scope

### In Scope
- Content compliance audit (README, Jupyter notebook, Google Slides)
- Image and data attribution verification
- Tone and messaging alignment fixes
- Speaker enablement documentation
- Final validation checklist
- Presentation recording (after all other milestones complete)

### Out of Scope
- Major feature additions or demo changes (handled in other PRDs)
- Actual submission process to EPCAT catalog (process TBD)
- Translation or internationalization (handled by Datadog teams for specific events)

---

## Review Process: Collaborative Slide-by-Slide Workflow

**IMPORTANT**: Read this section before executing the milestones below.

### Prerequisites: Read Internal Guidelines First

Before starting the slide-by-slide review, Claude must read and understand all three internal guideline documents:

1. **Read `internal-docs/writing-prepared-talk.md`** - Content creation guidelines
   - Prepared talk goals (value for ALL attendees, modern tech, help attendees succeed)
   - What to avoid (product pitches, extensive demos, idioms/jokes, buzzwords)
   - Speaker enablement requirements (cover slide with instructions, script in notes, image/data credits)
   - "The One Thing" - focus on one primary takeaway

2. **Read `internal-docs/prepared-talks-guidelines.md`** - Review and refresh process
   - Branding/messaging alignment checks
   - Freshness and relevance criteria
   - Image attribution requirements
   - Demo/screenshot currency

3. **Read `internal-docs/datadog-identity.md`** - Brand voice and personality
   - Tone guidelines (enthusiastic but humble, treats users as peers)
   - Language to avoid (buzzwords, empty superlatives, competitor bashing)
   - Authentic voice characteristics

**Why this matters**: The guidelines contain specific requirements (e.g., cover slide format, placeholder conventions, attribution rules) that inform feedback during slide review. Without reading them first, Claude may miss compliance issues or give incorrect guidance.

### Slide-by-Slide Review Process

Milestones 1-5 (Content Audit through Speaker Enablement) are executed together in a single collaborative pass, not as separate sequential phases.

**How it works:**

1. **For each slide**, human pastes:
   - Current speaker notes text
   - Screenshot of the slide visual

2. **Claude and human discuss:**
   - PRD compliance (tone, buzzwords, attribution, accessibility)
   - Speaker notes polish (clarity, flow, timing)
   - Any issues from the Milestone 1-5 checklists that apply to this slide

3. **Human makes edits** directly in Google Slides

4. **Move to next slide** once satisfied

**Key principles:**
- **Discussion-based**: Claude provides feedback and suggestions; human decides what to change
- **No unilateral changes**: Claude does not edit files without explicit approval
- **Google Slides is source of truth**: SLIDE_NARRATIVE.md updated once at end, not during review
- **All compliance checks combined**: Rather than separate audit/fix cycles, issues are identified and resolved per-slide

**Why this approach:**
- More efficient than batch audit → batch fix cycles
- Human maintains creative control over speaker voice
- Issues resolved in context rather than as abstract checklist items
- Natural stopping points (per-slide) for multi-session work

**Milestone checklists below**: Use these as reference during slide-by-slide review, not as sequential phases.

---

## Milestones

### Milestone 1: Content Compliance Audit
**Goal**: Identify all compliance issues across demo materials

**Instructions for Implementation**:
1. Read all three guideline documents in `internal-docs/`:
   - `internal-docs/writing-prepared-talk.md`
   - `internal-docs/prepared-talks-guidelines.md`
   - `internal-docs/datadog-identity.md`
2. Review each material against the checklist below
3. Document issues with specific file locations (e.g., "README.md line 45")

**Review Checklist**:

**Guidelines from `internal-docs/writing-prepared-talk.md`**:
- [ ] Demo provides value for ALL attendees (not just Datadog customers)
- [ ] Uses modern technologies and practices (current K8s security tools)
- [ ] Avoids product pitches and infomercials
- [ ] Avoids extensive Datadog-specific demos (keep light/appropriate)
- [ ] No idioms, puns, or jokes (international accessibility)
- [ ] No buzzwords or management-speak
- [ ] One clear primary takeaway ("The One Thing")
- [ ] Logical flow without unnecessary agenda/introduction overhead

**Guidelines from `internal-docs/prepared-talks-guidelines.md`**:
- [ ] Aligns with Datadog's current branding and messaging
- [ ] Content is fresh and relevant (no obsolete tech/practices)
- [ ] Demos and screenshots show current tool state
- [ ] References better/newer Datadog solutions if available
- [ ] No references to current events, pop culture that translate poorly
- [ ] Images have credit or attribution
- [ ] Demos and screenshots of Datadog are up-to-date

**Guidelines from `internal-docs/datadog-identity.md`**:
- [ ] Tone is enthusiastic but humble
- [ ] Treats users as peers (not pushing/selling)
- [ ] Friendly and inclusive language (no clique words)
- [ ] Authentic and human (not cutesy/macho)
- [ ] Precise and thorough (answers questions)
- [ ] No empty superlatives ("the best", "game-changing", etc.)
- [ ] No competitor bashing
- [ ] Focuses on useful over cool, substance over image

**Materials to Review**:
- [x] `README.md` - Review against all checklist items above
- [x] `KindCluster_Demo_v2.ipynb` - Review against all checklist items above
- [x] `SLIDE_NARRATIVE.md` - Review for narrative alignment with guidelines
- [x] Google Slides deck - Review against all checklist items above

**Tasks**:
- [x] Read guideline documents in `internal-docs/` directory
- [x] Review `README.md` against checklist
- [x] Review `KindCluster_Demo_v2.ipynb` against checklist
- [x] Review `SLIDE_NARRATIVE.md` for narrative alignment
- [x] Review Google Slides deck against checklist
- [x] Document all issues found with specific location references
- [x] Prioritize fixes (critical vs nice-to-have)

**Success Criteria**: Complete audit report with actionable fix list

---

### Milestone 2: Documentation & Attribution
**Goal**: Ensure all images and data are properly credited

**Reference**: See image and data source requirements in `internal-docs/prepared-talks-guidelines.md` and `internal-docs/writing-prepared-talk.md`

**Image Attribution Requirements** (cloud partners are strict):
- [x] All images in `README.md` have credit/attribution
- [x] All images in `KindCluster_Demo_v2.ipynb` have credit/attribution (no images in notebook)
- [x] All images in Google Slides have credit on slide itself (e.g., "CC-BY SA 2.0")
- [x] Image source URLs documented in speaker notes (Google Slides)
- [x] Images without clear origin are replaced with royalty-free alternatives
- [x] Approved image sources used: Pexels, Pixabay, Unsplash, Noun Project (see `internal-docs/writing-prepared-talk.md`)

**Data Source Requirements**:
- [x] All statistics in `README.md` cited have source links
- [x] All statistics in `KindCluster_Demo_v2.ipynb` cited have source links (no statistics in notebook)
- [x] All statistics in Google Slides cited have source links
- [x] Data sources documented in speaker notes
- [x] No made-up statistics or unsourced claims
- [x] Use Datadog's "Approved Stats" when referencing company data

**Tasks**:
- [x] Audit all images in `README.md` for attribution
- [x] Audit all images in `KindCluster_Demo_v2.ipynb` for attribution
- [x] Audit all images in Google Slides for attribution
- [x] Add credits/licenses where missing
- [x] Replace images with unclear rights
- [x] Audit all statistics across all materials for source citations
- [x] Add source URLs to speaker notes in Google Slides

**Success Criteria**: Every image and statistic has documented source/attribution

---

### Milestone 3: Tone & Messaging Alignment
**Goal**: Fix any Datadog Identity violations found in audit

**Reference**: Apply guidelines from `internal-docs/datadog-identity.md` to all content

**Tone Fixes** (based on `internal-docs/datadog-identity.md`):
- [ ] Replace buzzwords with precise technical language
- [ ] Remove management-speak and empty superlatives
- [ ] Ensure humble tone (no bragging, treats users as peers)
- [ ] Remove any competitor bashing or negative comparisons
- [ ] Verify authentic/human voice (not cutesy/folksy or macho/bravado)
- [ ] Check for enthusiastic but not pushy language
- [ ] Ensure friendly and inclusive language (no clique words)

**Messaging Fixes**:
- [ ] Ensure "forward thinking" positioning with modern tech
- [ ] Focus on solving problems at scale
- [ ] Emphasize simplification and usability
- [ ] Highlight customer empathy and listening
- [ ] Remove any "sales pitch" language

**Tasks**:
- [x] Apply tone fixes to `README.md` (no fixes needed - passed review)
- [x] Apply tone fixes to `KindCluster_Demo_v2.ipynb` (fixed 2 idioms)
- [x] Apply tone fixes to Google Slides deck
- [x] Review `SLIDE_NARRATIVE.md` for tone consistency
- [x] Validate changes maintain technical accuracy

**Success Criteria**: All content aligns with `internal-docs/datadog-identity.md` guidelines

---

### Milestone 4: Demo Accessibility & Value
**Goal**: Ensure demo provides value for ALL attendees, not just Datadog customers

**Reference**: Apply "Prepared Talk Goals" from `internal-docs/writing-prepared-talk.md`

**Value for All Attendees**:
- [x] Demo in `README.md` works standalone (doesn't require Datadog account/product)
- [x] `KindCluster_Demo_v2.ipynb` provides educational value for users of any observability tool
- [x] Primary lesson is technology/practice, not Datadog features
- [x] KubeHound knowledge is transferable and broadly useful

**Avoid Product Pitch** (per `internal-docs/writing-prepared-talk.md`):
- [x] Demo is not an infomercial for Datadog
- [x] Datadog mentions are minimal and contextual
- [x] Demo doesn't depend on Datadog features for value
- [x] Focus is on security problem and KubeHound solution

**The One Thing** (per `internal-docs/writing-prepared-talk.md`):
- [x] Primary takeaway is clear and focused in `README.md`
- [x] `SLIDE_NARRATIVE.md` emphasizes one primary lesson
- [x] Secondary points support the primary lesson
- [x] Attendees can articulate what they learned in one sentence
- [x] Call to action is clear (if applicable)

**Tasks**:
- [x] Review `README.md` for product pitch red flags
- [x] Review `KindCluster_Demo_v2.ipynb` for product pitch red flags
- [x] Review Google Slides deck for product pitch red flags
- [x] Verify value proposition for non-Datadog users
- [x] Clarify "The One Thing" in `README.md` and slides
- [x] Test: "Would this be useful at a non-Datadog conference?"

**Success Criteria**: Demo provides value regardless of attendee's tool choices

---

### Milestone 5: Speaker Enablement
**Goal**: Prepare materials for other speakers to deliver this talk

**Reference**: Follow "Setting up speakers for success" from `internal-docs/writing-prepared-talk.md`

**Google Slides Requirements**:
- [x] Uses official Datadog Google Slides Template
- [x] Speaker notes include bullet points for each slide
- [x] Speaker notes include full talk script
- [x] Cover slide with modification instructions (if needed)
- [x] Documentation on how to adapt talk length (30min → 20min, etc.)
- [x] Image credits in speaker notes (per `internal-docs/writing-prepared-talk.md`)
- [x] Data source links in speaker notes (per `internal-docs/writing-prepared-talk.md`)

**Additional Documentation**:
- [x] `README.md` clearly documents demo setup for speakers
- [x] `KindCluster_Demo_v2.ipynb` has instructional markdown cells
- [x] Any speaker modifications documented (name, photo, regional units, etc.)
- [x] Links to external resources (Commonly Used Slides, Customer Assets, etc.)

**Tasks**:
- [x] Verify Google Slides uses official Datadog template
- [x] Add/enhance speaker notes with talk script
- [x] Add cover slide with instructions (if modifications needed)
- [x] Verify `README.md` documents demo prerequisites clearly
- [x] Verify `KindCluster_Demo_v2.ipynb` has clear instructions
- [x] Test: "Could someone unfamiliar with KubeHound deliver this talk?"

**Success Criteria**: Speakers outside Advocacy team can successfully deliver this talk

---

### Milestone 6: Final Validation
**Goal**: Comprehensive checklist review before recording

**Instructions**: Review all previous milestones and materials before proceeding to recording

**Validation Checklist** (all must pass):
- [x] Content Compliance Audit complete (Milestone 1)
- [x] Documentation & Attribution complete (Milestone 2)
- [x] Tone & Messaging Alignment complete (Milestone 3)
- [x] Demo Accessibility & Value validated (Milestone 4)
- [x] Speaker Enablement materials ready (Milestone 5)
- [x] No outstanding compliance issues
- [x] `README.md` reviewed and approved
- [x] `KindCluster_Demo_v2.ipynb` reviewed and approved
- [x] `SLIDE_NARRATIVE.md` aligned with guidelines
- [x] Google Slides deck reviewed and approved
- [x] All three guideline documents in `internal-docs/` satisfied

**Known Limitations Documentation**:
- [x] Document any intentional exceptions to guidelines (none needed)
- [x] Document any areas requiring future improvement (none identified)
- [x] Document any platform-specific considerations (none needed)

**Tasks**:
- [x] Review all previous milestone completion
- [x] Perform end-to-end demo walkthrough
- [x] Validate all checklist items
- [x] Mark materials as "ready for recording"

**Success Criteria**: All compliance requirements met, ready for final recording

---

### Milestone 7: Record Presentation
**Goal**: Create reference recording for other speakers

**IMPORTANT**: Only proceed after Milestones 1-6 are 100% complete. Recording should be the very last step to avoid re-recording due to compliance fixes.

**Recording Requirements** (per `internal-docs/prepared-talks-guidelines.md`):
- [ ] Deliver full presentation as if at conference
- [ ] Record with clear audio and video
- [ ] Upload recording for speaker reference
- [ ] Add recording link to EPCAT (when submitting to catalog)
- [ ] Update "Last Update" field with recording date

**Post-Recording**:
- [ ] Review recording for quality
- [ ] Verify all speaker notes align with delivered content
- [ ] Add recording to demo repository documentation (if appropriate)

**Tasks**:
- [ ] Set up recording environment
- [ ] Deliver and record presentation
- [ ] Upload to appropriate location
- [ ] Update EPCAT record with recording link

**Success Criteria**: High-quality recording available for speakers' reference

---

## Technical Considerations

### Internal Documents Reference
Three internal guideline documents saved locally in `internal-docs/` directory (gitignored):
- `internal-docs/writing-prepared-talk.md` - Content creation guidelines
- `internal-docs/prepared-talks-guidelines.md` - Reviewing and refreshing process
- `internal-docs/datadog-identity.md` - Brand voice and personality

**IMPORTANT**: These documents are private Datadog internal documentation and are NOT committed to the public repository. They are gitignored.

### Materials Under Review
All materials to be reviewed are in the repository root:
- `README.md` - Primary demo documentation
- `KindCluster_Demo_v2.ipynb` - Interactive demo notebook
- `SLIDE_NARRATIVE.md` - Conference presentation speaker notes (gitignored reference)
- Google Slides deck - External (link TBD when deck finalized)

### Google Slides Location
Deck location: https://docs.google.com/presentation/d/16KHfx-AcHmi7j6CATfOvCsb7a_W-oR5jc0tR9G65tM8/edit?usp=sharing

### EPCAT Submission
Process for adding to Prepared Talks Catalog (per `internal-docs/prepared-talks-guidelines.md`):
- Set "Prepared Talk" field to true
- Fill fields: Topic Tags, Abstract, Deck, Recording, Last Update
- Check "Includes a demo?" field
- Upload first slide screenshot to Cover field
- [Details TBD - to be documented when submission occurs]

---

## Dependencies

- **PRD #4 (Conference-Ready Demo)**: Milestone 4 (narrative alignment) should be complete
- **PRD #6 (Jupyter Usability)**: Completion helpful but not blocking
- **Google Slides Deck**: Must be in reasonable draft state before Milestone 1

---

## Risks & Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| Recording before compliance complete | High - requires re-recording | Move recording to very last milestone (after validation) |
| Google Slides deck major changes | Medium - invalidates audit work | Wait for deck to be reasonably stable before starting |
| Unclear EPCAT submission process | Low - doesn't block content readiness | Document process when encountered, focus on content quality first |
| Peer review reveals major issues | Medium - requires rework | Build in peer review at Milestone 6 before recording |
| International translation concerns | Low - handled by regional teams | Focus on avoiding idioms/jokes per `internal-docs/writing-prepared-talk.md` |

---

## Timeline & Effort Estimate

- **Milestone 1** (Content Audit): 2 hours (thorough review of all materials against `internal-docs/` guidelines)
- **Milestone 2** (Attribution): 1-2 hours (depends on image sourcing needs)
- **Milestone 3** (Tone Fixes): 2-3 hours (writing improvements per `internal-docs/datadog-identity.md`)
- **Milestone 4** (Accessibility): 1 hour (validation and minor adjustments)
- **Milestone 5** (Speaker Enablement): 2-3 hours (speaker notes, documentation)
- **Milestone 6** (Final Validation): 1 hour (checklist review, dry run)
- **Milestone 7** (Recording): 1-2 hours (setup, record, upload)

**Total**: 10-14 hours spread over multiple sessions

**Target Completion**: Before 2024-12-23 (4 weeks available)

---

## Progress Log

### 2025-11-26: PRD Created
- Created GitHub issue #7
- Saved three internal guideline documents to `internal-docs/` (gitignored)
- Added `SLIDE_NARRATIVE.md` to gitignore (working reference)
- Defined 7 milestones for comprehensive compliance review
- Identified all materials for review with explicit file paths
- Set recording as final milestone to avoid rework
- Added explicit file path references throughout for future Claude instances

### 2025-12-23: Story Arc Review & Process Decisions
- Reviewed overall narrative structure with Claude - validated learning-journey approach
- Streamlined intro (slides 1-5) to remove repetition of value proposition
- Added MITRE ATT&CK section (slides 19-21) to explain attack primitives framework
- Established collaborative review process: human edits in Google Slides, pastes notes + screenshots for discussion
- Decision: SLIDE_NARRATIVE.md updated at end, not during review process
- Added Google Slides deck link to PRD
- Ready to begin slide-by-slide compliance review

### 2025-12-24: Complete Slide-by-Slide Compliance Review
- **Completed full review of all 49 slides** in Google Slides deck
- Reviewed each slide against internal guidelines (writing-prepared-talk.md, prepared-talks-guidelines.md, datadog-identity.md)
- Added BULLETS + SCRIPT format to all slides for speaker enablement
- Added click cues for all animated slides (17, 34, 45, 46)
- Verified image attributions (kubehound.io, attack.mitre.org) in speaker notes
- Verified statistic sources (kubehound.io for performance data)
- Verified MITRE ATT&CK trademark noted where applicable
- Added cover slide (Slide 1) with speaker customization instructions
- Fixed typo: "Kubehoud" → "KubeHound" in slide 46 title
- Improved closing (Slide 48) to reinforce key takeaway: "Think in graphs, not lists"
- Added bonus slide (Slide 49) with QR code for demo repo
- **Updated SLIDE_NARRATIVE.md** with complete final script (all 49 slides)
- Story arc validated: newcomer can go from zero to understanding the value
- Strong transitions and callbacks throughout (especially "graphs not lists" theme)
- **Milestones 1-5 complete for Google Slides deck**
- Remaining: README.md and Jupyter notebook reviews, final validation, recording

### 2025-12-25: Slide Images for README Evaluation

Evaluated whether slide presentation images should be added to README.md.

**Images Reviewed:**

*GIFs (3):*
- `KubeHound Graph View.gif` - JanusGraph visualization with colored nodes showing attack paths
- `KubeHound Ingest.gif` - Terminal showing `kubehound ingest local` command execution
- `KubeHound Collect Cluster Data.gif` - Terminal showing `kubehound dump local` command execution

*PNGs (8):*
- `fast_path_to_critical.png` - Graph showing Node → Container → Endpoints with attack edge labels
- `Gremlin_kh_query.png` - Gremlin magic command syntax in Jupyter cell
- `hostpath_mount.png` - Slide: "Kubernetes Vulnerability: Hostpath mount" with YAML + MITRE ATT&CK
- `insecure_rbac.png` - Slide: "Kubernetes Vulnerability: Insecure RBAC binding" with YAML + MITRE ATT&CK
- `kubehound-architecture.png` - KubeHound 4-step workflow diagram (from kubehound.io/architecture)
- `over-privledge.png` - Slide: "Kubernetes Vulnerability: Over-privileged service account" with YAML + MITRE ATT&CK
- `query_breakdown.png` - Annotated breakdown of Gremlin query components

**Analysis:**

| Image | Assessment | Reason |
|-------|------------|--------|
| `kubehound-architecture.png` | Skip | Shows 4 steps; slides use 3 steps - would create confusing discrepancy |
| `hostpath_mount.png`, `insecure_rbac.png`, `over-privledge.png` | Skip | README already has cleaner misconfiguration images; slide versions designed for verbal context |
| `fast_path_to_critical.png` | Skip | Duplicates existing `attack-graph-example.png` in README |
| `Gremlin_kh_query.png` | Skip | Just shows query text already present in README |
| Terminal GIFs (Ingest, Collect) | Skip | README explains these commands well in text; GIFs add file size without adding understanding |
| `KubeHound Graph View.gif` | Skip | Static image may be more useful for documentation (readers can study it) |
| `query_breakdown.png` | Skip | README already has inline comments explaining query parts (lines 252-258) |

**Story Comparison:**

Compared SLIDE_NARRATIVE.md script against README "Why Attack Paths Matter" section (lines 333-378):
- Both capture "graphs, not lists" key insight
- Both explain misconfigurations created with good intentions
- Both have the "Is this cluster secure?" tension moment
- Both show same 3 misconfiguration examples
- Script optimized for verbal delivery; README optimized for scannable reading
- No significant insights missing from README that script provides

**Decisions:**
- No images added to README
- No narrative content added from script to README
- README images and content are appropriate as-is

### 2025-12-25: README and Jupyter Notebook Compliance Review

Completed systematic compliance review of README.md and KindCluster_Demo_v2.ipynb against all three internal guideline documents.

**README.md Review:**
- Reviewed against all Milestone 1-5 checklists
- Found 1 issue: Two images from kubehound.io lacked attribution
  - `attack-graph-example.png` (line 374)
  - `kubehound-as-a-service-architecture.png` (line 473)
- Fixed: Added attribution captions with source URLs (lines 376, 477)
- All other checks passed (tone, accessibility, no product pitch, clear takeaway)

**Jupyter Notebook Review:**
- Reviewed against all Milestone 1-5 checklists
- Found 2 issues (idioms that don't translate well internationally):
  - "Game over." in cell-16 → Changed to "The cluster is compromised."
  - "where the magic happens" in cell-0 → Changed to direct language
- No images in notebook (attribution N/A)
- All other checks passed

**Milestones 1-6 now complete for all materials:**
- Google Slides deck (completed 2025-12-24)
- SLIDE_NARRATIVE.md (completed 2025-12-24)
- README.md (completed 2025-12-25)
- KindCluster_Demo_v2.ipynb (completed 2025-12-25)

**Ready for Milestone 7: Recording**

---

## Decision Log

| Date | Decision | Rationale | Impact |
|------|----------|-----------|--------|
| 2025-11-26 | PRD created | Initial structure for compliance review | - |
| 2025-12-23 | Keep learning-journey story arc | Current structure was written while learning KubeHound, naturally builds concepts in order audience needs them. Hooks that front-load context don't land without setup. | No major restructure needed; validates existing approach |
| 2025-12-23 | Add MITRE ATT&CK section | KubeHound's attack primitives map to MITRE ATT&CK framework - adds credibility and shared vocabulary. Placed after Attack Primitives Library intro (new slides 19-21). | Added 3 slides to deck; strengthens "why trust these categories" |
| 2025-12-23 | Streamlined intro (slides 1-5) | Original had value proposition repeated 3 times across slides 2, 4, 5. Consolidated to single explanation in slide 5 after context is established. | Tighter intro, less repetition |
| 2025-12-23 | Slide-by-slide collaborative review | Human makes edits in Google Slides, pastes speaker notes + screenshots for discussion with Claude. Discussion-based, not Claude making unilateral changes. | Review process defined |
| 2025-12-23 | Don't sync SLIDE_NARRATIVE.md during review | Google Slides is source of truth during editing. Maintaining parallel doc creates overhead. Update SLIDE_NARRATIVE.md once at end when satisfied. | Simpler workflow during review |
| 2025-12-23 | Don't use Google Drive API for Slides | Even with gdrive MCP, Slides format wouldn't give useful speaker notes. Paste workflow (notes + screenshots) provides exactly what's needed for review. | No tooling changes needed |
| 2025-12-23 | Add instructions cover slide | Per `writing-prepared-talk.md`: prepared talks need a cover slide listing all speaker customizations (name, title, units, etc.) | New slide 0 with modification instructions |
| 2025-12-23 | Use placeholders for speaker-specific content | Speaker notes should use `[SPEAKER NAME]`, `[SPEAKER TITLE]` etc. so any speaker can deliver | Update slide 1 and any other speaker-specific slides |
| 2025-12-23 | Claude must read internal guidelines before review | Guidelines contain specific requirements (cover slide format, attribution rules, placeholder conventions) that inform compliance feedback | Added prerequisites section to Review Process |
| 2025-12-25 | Don't add slide images to README | Reviewed 11 images (3 GIFs, 8 PNGs). Each was either: redundant with existing README content, designed for verbal presentation context, or would create inconsistency (4-step vs 3-step architecture). | No README changes needed |
| 2025-12-25 | Don't add script narrative to README | Compared SLIDE_NARRATIVE.md against README "Why Attack Paths Matter" section. README already captures key insights ("graphs not lists", misconfiguration empathy, tension moment). Script optimized for verbal delivery; README optimized for scannable reading. | No README changes needed |

---

## References

- **Internal Guidelines** (in `internal-docs/` directory, gitignored):
  - `internal-docs/writing-prepared-talk.md` - Content creation standards
  - `internal-docs/prepared-talks-guidelines.md` - Review and refresh process
  - `internal-docs/datadog-identity.md` - Brand voice and personality
- **Materials to Review** (repository root):
  - `README.md` - Primary demo documentation
  - `KindCluster_Demo_v2.ipynb` - Interactive demo notebook
  - `SLIDE_NARRATIVE.md` - Speaker notes reference (gitignored)
  - Google Slides deck (external, link TBD)
- **Datadog Resources** (internal, referenced in `internal-docs/writing-prepared-talk.md`):
  - Official Datadog Google Slides Template
  - Commonly Used Slides deck
  - Customer Marketing Assets Knowledge Base
  - Approved Stats
  - Logos and Press Kit
