# PRD #7: Prepared Talk Standards Compliance Review

**Status**: Draft
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

- [ ] All content aligns with Datadog Identity (`internal-docs/datadog-identity.md`)
- [ ] Demo provides value for ALL attendees (customers, non-customers, competitors' users)
- [ ] No product pitches, extensive demos, or infomercial content
- [ ] All images properly credited with source URLs
- [ ] All statistics/data properly sourced
- [ ] No buzzwords, management-speak, empty superlatives, or competitor bashing
- [ ] Google Slides deck includes speaker notes and uses official Datadog template
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
- [ ] `README.md` - Review against all checklist items above
- [ ] `KindCluster_Demo_v2.ipynb` - Review against all checklist items above
- [ ] `SLIDE_NARRATIVE.md` - Review for narrative alignment with guidelines
- [ ] Google Slides deck - Review against all checklist items above

**Tasks**:
- [ ] Read guideline documents in `internal-docs/` directory
- [ ] Review `README.md` against checklist
- [ ] Review `KindCluster_Demo_v2.ipynb` against checklist
- [ ] Review `SLIDE_NARRATIVE.md` for narrative alignment
- [ ] Review Google Slides deck against checklist
- [ ] Document all issues found with specific location references
- [ ] Prioritize fixes (critical vs nice-to-have)

**Success Criteria**: Complete audit report with actionable fix list

---

### Milestone 2: Documentation & Attribution
**Goal**: Ensure all images and data are properly credited

**Reference**: See image and data source requirements in `internal-docs/prepared-talks-guidelines.md` and `internal-docs/writing-prepared-talk.md`

**Image Attribution Requirements** (cloud partners are strict):
- [ ] All images in `README.md` have credit/attribution
- [ ] All images in `KindCluster_Demo_v2.ipynb` have credit/attribution
- [ ] All images in Google Slides have credit on slide itself (e.g., "CC-BY SA 2.0")
- [ ] Image source URLs documented in speaker notes (Google Slides)
- [ ] Images without clear origin are replaced with royalty-free alternatives
- [ ] Approved image sources used: Pexels, Pixabay, Unsplash, Noun Project (see `internal-docs/writing-prepared-talk.md`)

**Data Source Requirements**:
- [ ] All statistics in `README.md` cited have source links
- [ ] All statistics in `KindCluster_Demo_v2.ipynb` cited have source links
- [ ] All statistics in Google Slides cited have source links
- [ ] Data sources documented in speaker notes
- [ ] No made-up statistics or unsourced claims
- [ ] Use Datadog's "Approved Stats" when referencing company data

**Tasks**:
- [ ] Audit all images in `README.md` for attribution
- [ ] Audit all images in `KindCluster_Demo_v2.ipynb` for attribution
- [ ] Audit all images in Google Slides for attribution
- [ ] Add credits/licenses where missing
- [ ] Replace images with unclear rights
- [ ] Audit all statistics across all materials for source citations
- [ ] Add source URLs to speaker notes in Google Slides

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
- [ ] Apply tone fixes to `README.md`
- [ ] Apply tone fixes to `KindCluster_Demo_v2.ipynb`
- [ ] Apply tone fixes to Google Slides deck
- [ ] Review `SLIDE_NARRATIVE.md` for tone consistency
- [ ] Validate changes maintain technical accuracy
- [ ] Get peer review on tone improvements (optional but recommended)

**Success Criteria**: All content aligns with `internal-docs/datadog-identity.md` guidelines

---

### Milestone 4: Demo Accessibility & Value
**Goal**: Ensure demo provides value for ALL attendees, not just Datadog customers

**Reference**: Apply "Prepared Talk Goals" from `internal-docs/writing-prepared-talk.md`

**Value for All Attendees**:
- [ ] Demo in `README.md` works standalone (doesn't require Datadog account/product)
- [ ] `KindCluster_Demo_v2.ipynb` provides educational value for users of any observability tool
- [ ] Primary lesson is technology/practice, not Datadog features
- [ ] KubeHound knowledge is transferable and broadly useful

**Avoid Product Pitch** (per `internal-docs/writing-prepared-talk.md`):
- [ ] Demo is not an infomercial for Datadog
- [ ] Datadog mentions are minimal and contextual
- [ ] Demo doesn't depend on Datadog features for value
- [ ] Focus is on security problem and KubeHound solution

**The One Thing** (per `internal-docs/writing-prepared-talk.md`):
- [ ] Primary takeaway is clear and focused in `README.md`
- [ ] `SLIDE_NARRATIVE.md` emphasizes one primary lesson
- [ ] Secondary points support the primary lesson
- [ ] Attendees can articulate what they learned in one sentence
- [ ] Call to action is clear (if applicable)

**Tasks**:
- [ ] Review `README.md` for product pitch red flags
- [ ] Review `KindCluster_Demo_v2.ipynb` for product pitch red flags
- [ ] Review Google Slides deck for product pitch red flags
- [ ] Verify value proposition for non-Datadog users
- [ ] Clarify "The One Thing" in `README.md` and slides
- [ ] Test: "Would this be useful at a non-Datadog conference?"

**Success Criteria**: Demo provides value regardless of attendee's tool choices

---

### Milestone 5: Speaker Enablement
**Goal**: Prepare materials for other speakers to deliver this talk

**Reference**: Follow "Setting up speakers for success" from `internal-docs/writing-prepared-talk.md`

**Google Slides Requirements**:
- [ ] Uses official Datadog Google Slides Template
- [ ] Speaker notes include bullet points for each slide
- [ ] Speaker notes include full talk script
- [ ] Cover slide with modification instructions (if needed)
- [ ] Documentation on how to adapt talk length (30min → 20min, etc.)
- [ ] Image credits in speaker notes (per `internal-docs/writing-prepared-talk.md`)
- [ ] Data source links in speaker notes (per `internal-docs/writing-prepared-talk.md`)

**Additional Documentation**:
- [ ] `README.md` clearly documents demo setup for speakers
- [ ] `KindCluster_Demo_v2.ipynb` has instructional markdown cells
- [ ] Any speaker modifications documented (name, photo, regional units, etc.)
- [ ] Links to external resources (Commonly Used Slides, Customer Assets, etc.)

**Tasks**:
- [ ] Verify Google Slides uses official Datadog template
- [ ] Add/enhance speaker notes with talk script
- [ ] Add cover slide with instructions (if modifications needed)
- [ ] Verify `README.md` documents demo prerequisites clearly
- [ ] Verify `KindCluster_Demo_v2.ipynb` has clear instructions
- [ ] Test: "Could someone unfamiliar with KubeHound deliver this talk?"

**Success Criteria**: Speakers outside Advocacy team can successfully deliver this talk

---

### Milestone 6: Final Validation
**Goal**: Comprehensive checklist review before recording

**Instructions**: Review all previous milestones and materials before proceeding to recording

**Validation Checklist** (all must pass):
- [ ] Content Compliance Audit complete (Milestone 1)
- [ ] Documentation & Attribution complete (Milestone 2)
- [ ] Tone & Messaging Alignment complete (Milestone 3)
- [ ] Demo Accessibility & Value validated (Milestone 4)
- [ ] Speaker Enablement materials ready (Milestone 5)
- [ ] No outstanding compliance issues
- [ ] `README.md` reviewed and approved
- [ ] `KindCluster_Demo_v2.ipynb` reviewed and approved
- [ ] `SLIDE_NARRATIVE.md` aligned with guidelines
- [ ] Google Slides deck reviewed and approved
- [ ] All three guideline documents in `internal-docs/` satisfied
- [ ] Peer review completed (recommended)
- [ ] Dry run completed (recommended)

**Known Limitations Documentation**:
- [ ] Document any intentional exceptions to guidelines
- [ ] Document any areas requiring future improvement
- [ ] Document any platform-specific considerations

**Tasks**:
- [ ] Review all previous milestone completion
- [ ] Perform end-to-end demo walkthrough
- [ ] Validate all checklist items
- [ ] Get peer review from Advocacy team (optional)
- [ ] Mark materials as "ready for recording"

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
Deck location: [To be added when deck is finalized]

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
