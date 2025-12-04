# PRD #6: Jupyter Notebook Usability for Beginners

**Status**: Complete
**Priority**: Medium
**GitHub Issue**: [#6](https://github.com/wiggitywhitney/KubeHound-Demo/issues/6)
**Created**: 2025-11-26

---

## Problem Statement

Users unfamiliar with Jupyter notebooks find the KubeHound demo confusing and difficult to navigate. Specific pain points identified through user testing:

1. **Don't understand Jupyter interface basics**: How to run cells, what Shift+Enter does, cell execution order
2. **Can't find graph visualization**: Results default to Console tab, users miss the Graph tab entirely
3. **Generic graph labels unhelpful**: Graph shows "Pod", "Container" labels instead of actual resource names, making it hard to understand which specific resources are vulnerable

**User Impact**: Beginners abandon the demo before seeing KubeHound's value. The impressive graph visualizations go undiscovered because users don't know to click the Graph tab.

---

## Solution Overview

Make the notebook self-documenting for Jupyter beginners through:

1. **In-notebook instructions**: Add beginner-friendly markdown cell at the top explaining Jupyter basics
2. **Visual aids in README**: Screenshots showing cell anatomy, how to run cells, and where to find Graph tab
3. **Custom label query example**: Add final query demonstrating how to show meaningful resource names on graphs

These improvements allow beginners to successfully navigate the demo without prior Jupyter experience.

---

## Success Criteria

- [ ] A Jupyter beginner can successfully run the notebook without external help
- [ ] Users discover and use the Graph tab visualization
- [ ] Users understand how to customize graph labels to show resource names
- [ ] Reduced confusion/questions from demo testers about "how to use this"

---

## Scope

### In Scope
- Adding instructional markdown cell to notebook
- Creating 2-3 annotated screenshots for README
- Adding example query showing custom labels
- Documentation updates

### Out of Scope
- Modifying Jupyter extension behavior (e.g., default tab preferences)
- Video tutorials or GIFs (may add in future if screenshots prove insufficient)
- Deep Gremlin query tutorial (focus on usability, not query language education)

---

## Milestones

### Milestone 1: Add Beginner Instructions to Notebook
**Goal**: Make the notebook self-explanatory for Jupyter beginners

**Tasks**:
- [x] Add markdown cell at very top of `KindCluster_Demo_v2.ipynb` with:
  - "First time using Jupyter? Here's how to use this notebook"
  - How to run cells (click cell, press Shift+Enter)
  - Run cells in order from top to bottom
  - Where to find results (tabs: Console/Graph/Query Metadata)
  - Tip: Click "Graph" tab to see visual attack paths
- [x] For "What are we looking at?" section (cell 2): Add reminder to click Graph tab to see colored dots representing different resource types
- [x] For "Identify the vulnerable services" section (cell 6): Clarify that this query returns table/JSON output only, no graph visualization
- [x] Test with someone unfamiliar with Jupyter

**Success Criteria**: Jupyter beginner can start using notebook without reading external docs

---

### Milestone 2: Add Visual Aids to README
**Goal**: Provide visual reference for confused users

**Tasks**:
- [x] Take screenshot of Jupyter cell showing anatomy (code area, run button, output area)
- [x] Take screenshot showing Shift+Enter action or result
- [x] Take screenshot with arrow/annotation pointing to Graph tab location
- [x] Add new "Jupyter Quick Start" section to README with screenshots
- [x] Keep it brief - 3 images maximum with short captions

**Success Criteria**: README visually demonstrates how to navigate Jupyter interface

---

### Milestone 3: Add Custom Label Query Example
**Goal**: Show users how to display meaningful resource names instead of generic types

**Tasks**:
- [x] Add new cell at end of notebook (after "Congratulations!")
- [x] Add markdown cell explaining: "Want to see actual pod/container names? Customize labels like this:"
- [x] Add query cell demonstrating `-d name` flag to show resource names
- [x] Test query works and displays helpful labels
- [x] Add brief explanation of what the query modification does

**Example Query**:
```gremlin
%%gremlin -d name -g class -le 50 -p inv,oute
kh.endpoints().not(has("serviceEndpoint","kube-dns"))
    .repeat(outE().inV().simplePath())
    .until(hasLabel("Node").or().loops().is(5))
    .hasLabel("Node")
    .path()
    .by(values("name"))  // Show resource names instead of types
    .limit(100)
```

**Success Criteria**: Users can see which specific pods/containers are vulnerable by name

---

## Technical Considerations

### Jupyter Tab Behavior Research
**Question**: Can we make Graph tab the default instead of Console tab?

**Finding**: Not feasible without modifying the underlying graph-notebook Jupyter extension
- Technology: AWS graph-notebook open-source extension
- Current behavior: Console tab always appears first
- Configuration: No documented way to change default tab
- Would require: Forking and modifying the extension's JavaScript UI code

**Decision**: Exclude from scope. Address through visual aids (screenshots with arrows) instead.

**Sources**:
- [Using magics in Amazon Neptune notebooks](https://docs.aws.amazon.com/neptune/latest/userguide/notebooks-magics.html)
- [GitHub - aws/graph-notebook](https://github.com/aws/graph-notebook)
- [Visualizing graph data in Amazon Neptune notebooks](https://docs.aws.amazon.com/neptune/latest/userguide/notebooks-visualization.html)

---

## Dependencies

- None - all changes are documentation/notebook content additions

---

## Risks & Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| Screenshots become outdated with UI changes | Medium | Use simple, timeless screenshots; avoid version-specific UI elements |
| Users still skip instructions | Low | Place instructions prominently at top; make them concise and scannable |
| Query example doesn't work with all resources | Low | Test thoroughly; document any limitations in the query explanation |

---

## Decision Log

### Decision: Exclude Graph Tab Default Configuration
**Date**: 2025-11-26
**Status**: Approved

**Problem**: Users miss the Graph tab because Console tab appears first by default.

**Options Considered**:
1. Configure graph-notebook to show Graph tab first
2. Add visual aids pointing users to Graph tab

**Decision**: Option 2 - Use screenshots/annotations instead of technical configuration

**Rationale**:
- graph-notebook extension has no configuration option for default tab
- Modifying extension requires forking/maintaining custom JavaScript code
- Out of scope for demo repository improvements
- Visual aids achieve same goal with zero maintenance burden

**Next Steps**:
- Add screenshot with arrow pointing to Graph tab in Milestone 2
- Add callout in notebook cell: "💡 Tip: Click the Graph tab to see visualization"

---

## Timeline & Effort Estimate

- **Milestone 1** (Notebook instructions): 30 minutes
- **Milestone 2** (README screenshots): 1 hour (screenshot capture, annotation, README updates)
- **Milestone 3** (Custom label query): 30 minutes

**Total**: ~2 hours

---

## Progress Log

### 2025-12-04: Implementation Complete
**All 3 milestones completed.**

**Milestone 1 - Notebook Instructions:**
- Added "First Time Using Jupyter? Start Here!" cell at top of notebook (cell-0)
- Added Graph tab reminder to "What are we looking at?" section (cell-4)
- Added Console tab note for table-output query (cell-12)

**Milestone 2 - README Screenshots:**
- Added 3 screenshots to `docs/images/`:
  - `Jupyter_Cells_Console.png` - Cell anatomy with code and output
  - `Jupyter_Cells_Tabs.png` - Result tabs highlighting Graph tab
  - `Jupyter_Cells_Visualization.png` - Graph visualization example
- Integrated screenshots into existing "Understanding the Notebook Interface" section

**Milestone 3 - Custom Label Query:**
- Added "See which specific resources are vulnerable" section (cells 19-20)
- Demonstrates `-d name` flag vs `-d label` for showing actual resource names
- Researched and documented that `-d` is an AWS graph-notebook magic command flag, not KubeHound DSL

**Technical Discovery:**
- The `-d` flag controls display labels and is part of AWS graph-notebook's `%%gremlin` magic command
- `-d label` shows resource types (Pod, Container); `-d name` shows actual names (nginx-pod, worker-node-1)

**Next Steps:**
- Validate success criteria with real Jupyter beginners
- Close GitHub issue #6 after user validation

### 2025-12-03: Additional Feedback Captured
- Added task: "Click Graph tab" reminder for "What are we looking at?" section
- Added task: Clarify which queries return table output vs graph visualization
- Milestone 3 already covers showing container names instead of generic labels
- **Open question**: Should we mention that experienced security professionals can skip the progressive filtering walkthrough and write direct queries? (framing consideration for intro text)

### 2025-11-26: PRD Created
- Created GitHub issue #6
- Documented problem based on Windows tester feedback
- Researched Jupyter tab configuration feasibility
- Defined 3 milestones focused on documentation improvements
- Excluded infeasible technical modifications (default tab behavior)

---

## References

- **User Feedback Source**: Windows tester + KubeHound beginner (2025-11-26)
- **Current Notebook**: `KindCluster_Demo_v2.ipynb`
- **README Section**: "Exploring Attack Paths with Jupyter Notebook" (lines 132-287)
- **Graph Notebook Docs**: [AWS Neptune Visualization Guide](https://docs.aws.amazon.com/neptune/latest/userguide/notebooks-visualization.html)
