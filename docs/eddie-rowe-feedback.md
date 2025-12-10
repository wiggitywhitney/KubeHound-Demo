# Demo Feedback from Eddie Rowe

**Date Received**: December 2025
**Reviewer**: Eddie Rowe (Datadog colleague)
**Status**: To be addressed in PRD #10

---

## Overall Impressions

> Great stuff - the demo was awesome! I've never actually run a Jupyter notebook before, so that was really cool.
>
> Time to put Kubernetes security expert on my resume :P

---

## Feedback Items

### 1. README Restructuring (Smart Brevity)

**Recommendation**: Adopt an outline that gives users immediate action followed by context:

1. Title & Value Prop (1 paragraph)
2. Quick Start (Give those users that dopamine hit immediately)
3. What You Just Built (Brief architecture summary - and they can skim while it builds)
4. How to Use the Notebook and the other "doing" stuff
5. Concept: Why KubeHound? (Moved from top to bottom based on Smart Brevity axioms)
6. Deep Dive: Architecture & Troubleshooting

**Additional**: Slash the theory - remove the "Example: Over-privileged Service Account" and related images. Link to the official KubeHound docs for theory. Or to other docs you have in a docs/ folder.

- [ ] Addressed

---

### 2. Reduce Prerequisite Friction

**Option A**: Include the prerequisite installation commands in the `./setup-kubehound-test-cluster.sh`
- For example: (If kind doesn't exist, brew install kind, Y)

**Option B**: Include the Mac and Windows command variants so users don't have to navigate to a different page:
- For example: `brew install kubehound`
- Could use `<details>` tags for each OS to save space.

- [x] Addressed

---

### 3. Setup Script Output Improvements

> Once the prerequisites are in place, the ./setup-kubehound-test-cluster.sh worked great!
>
> This script is fire to the max.. I love next steps in an output!

**Suggestion**: Modify the output:

1. **Remove this section**:
```
🌐 KubeHound UI: http://localhost:8888
   Password: admin
```

2. **Modify Next Steps to include password inline**:
```
📋 Next Steps:
   1. Open http://localhost:8888
   2. Input the password 'admin' and click 'Login'
   3. Navigate to kubehound_presets/
   4. Open KindCluster_Demo.ipynb
   5. Follow Jupyter notebook instructions
```

- [x] Addressed

---

### 4. README/Notebook Deduplication

> I love the progressive disclosure design in the Jupyter Notebook - nicely done!

**Recommendation**: Once they're in the Notebook you can explain how to run it there and remove the "Understanding the Notebook Interface" and other Notebook-centric sections from the README to remove any redundant information.

- [ ] Addressed

---

### 5. Notebook Conclusion

> When I got to the last step of the Jupyter notebook, I didn't completely understand how kubehound helped add value or what I was supposed to do next.

**Recommendation**: A final text block that summarized what the user did and what the next steps could be now that the user has these paths in hand would go far.

- [ ] Addressed

---

## Notes

- This document will be deleted once all feedback has been addressed
- All changes tracked in PRD #10
