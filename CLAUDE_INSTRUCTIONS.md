# Instructions for Claude Code: KubeHound Demo Project

## Context

Whitney is preparing a presentation about KubeHound (a Kubernetes attack path analysis tool by Datadog). She wants a streamlined demo environment that can be spun up quickly and reliably on presentation day.

## Key Decisions Already Made

1. **Environment**: Use Kind (local Kubernetes), NOT GCP
   - Reasoning: No internet dependency, fast setup (~3-5 min total), zero cloud costs, deterministic

2. **Vulnerable Cluster**: Use Kubernetes Goat, NOT custom vulnerabilities or Spider Rainbows
   - Kubernetes Goat: Industry-standard vulnerable K8s environment with 22 security scenarios
   - URL: https://github.com/madhuakula/kubernetes-goat
   - Deploys with Helm, has pre-built attack surface for KubeHound to analyze

3. **Additional Tools**: Include dotai MCP server and slash commands from Spider Rainbows repo
   - Spider Rainbows location: `/Users/whitney.lee/Documents/Repositories/spider-rainbows`
   - Copy MCP and Claude Code configurations from there

## Current Repository State

- Directory: `/Users/whitney.lee/Documents/Repositories/KubeHound-Demo/`
- Git: Initialized but no commits yet
- Contents: Just a README.md file (placeholder)
- GitHub: Not yet created

## Your Tasks

### Task 1: Initial Git Setup
1. Create initial commit with the README
2. Create GitHub repository using `gh` tool (Whitney has this available)
3. Push to GitHub
4. Repository should be public (good for sharing demo resources)

### Task 2: Copy MCP and Slash Command Config
1. Look in `/Users/whitney.lee/Documents/Repositories/spider-rainbows/` for:
   - `.mcp/` directory or MCP configuration
   - `.claude/` directory for slash commands
2. Copy relevant configs to this repo
3. May need to adapt paths/settings for this project

### Task 3: Create Demo Setup Script (`setup-demo.sh`)

**What the script must do:**
```bash
#!/bin/bash
# Complete one-command demo setup

1. Check prerequisites (Docker, Kind, Helm, kubehound)
   - Exit with helpful error if missing

2. Create Kind cluster named "kubehound-demo"
   - Use appropriate config if needed

3. Deploy Kubernetes Goat
   - Clone/use helm chart from https://github.com/madhuakula/kubernetes-goat
   - Install in cluster
   - Wait for all pods to be Ready

4. Start KubeHound backend stack
   - Needs JanusGraph, MongoDB, UI (check KubeHound docs)
   - Command: kubehound backend up (or similar)

5. Run KubeHound analysis
   - kubehound dump (collect cluster data)
   - kubehound ingest (analyze and build attack graph)

6. Print success message with URLs:
   - KubeHound UI: http://localhost:8000 (or whatever port)
   - Kubernetes Goat UI: http://127.0.0.1:1234
   - kubectl context info
```

**Important notes:**
- Make it idempotent where possible
- Add error checking after each major step
- Time estimates: Kind ~30s, Goat ~2 min, KubeHound ~2 min

### Task 4: Create Teardown Script (`teardown-demo.sh`)

**What the script must do:**
```bash
#!/bin/bash
# Clean up all demo resources

1. Stop KubeHound backend (kubehound backend down)
2. Delete Kind cluster (kind delete cluster --name kubehound-demo)
3. Clean up any temp files
4. Print confirmation message
```

### Task 5: Create Comprehensive README

**Include:**
- Project overview and purpose
- Prerequisites with install commands
- Quick start: `./setup-demo.sh`
- What gets created
- Demo day workflow
- 2-3 example attack paths to highlight (research KubeHound + Goat integration)
- Troubleshooting tips
- Cleanup: `./teardown-demo.sh`

### Task 6: Optional - Pre-Demo Prep Script (`prep-demo.sh`)
- Pre-pull all Docker images
- Verify prerequisites
- Do a test run and cleanup
- Ensures no surprises on demo day

## Reference Resources

1. **KubeHound**: https://github.com/DataDog/KubeHound
   - Main docs for setup, configuration, usage

2. **Kubernetes Goat**: https://github.com/madhuakula/kubernetes-goat
   - Installation instructions
   - 22 scenarios documentation

3. **Spider Rainbows** (for MCP/slash config): `/Users/whitney.lee/Documents/Repositories/spider-rainbows/`

## User Preferences (from CLAUDE.md)

- Create new PR to merge to main when there are codebase additions
- Don't squash git commits
- Make a new branch for new features
- Never reference task management systems in code/docs

## Demo Goals

**Maximum impact, minimum effort:**
- One command setup: `./setup-demo.sh`
- Impressive visual: KubeHound's attack graph UI
- Show 2-3 attack paths that are easy to explain
- Demonstrate one path live to prove it's real
- Everything runs locally, no cloud dependencies

## Success Criteria

When you're done, Whitney should be able to:
1. Run `./setup-demo.sh` and wait 3-5 minutes
2. See "Demo ready!" message with URLs
3. Open browser to KubeHound UI
4. See attack graph with multiple paths through Kubernetes Goat vulnerabilities
5. Execute one attack path manually to demonstrate
6. Run `./teardown-demo.sh` to clean up

## Next Steps After Your Work

Whitney will:
- Test the demo setup
- Practice the presentation
- Possibly refine which attack paths to highlight
- May ask for documentation improvements

---

**Start with Tasks 1-2**, then pause and confirm the approach before building the scripts. Make sure you understand the KubeHound workflow from their docs before writing setup-demo.sh.
