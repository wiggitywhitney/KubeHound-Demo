# KubeHound Conference Presentation - Speaker Notes

**Purpose**: This document contains the narrative flow and key messages from the KubeHound conference presentation. The README educational content should align with this proven story arc.

---

## Slide 1: Introduction
Hello! Welcome to KubeHound: Identifying Attack Paths in Kubernetes Clusters at Scale

My name is Whitney Lee, and I'm a senior technical advocate at Datadog.

Let's get straight to the point. What is KubeHound?

---

## Slide 3: What is KubeHound?
KubeHound is an open-source tool that enables the identification and visualization of attack paths in Kubernetes clusters.

It was developed by Datadog, specifically the Adversary Simulation Engineering team. How cool are their job titles?! But what it can do is it builds a graph that shows how an attacker might be able to move around once inside your Kubernetes cluster.

---

## Slide 4: Graph Visualization
Something like this!

To make a graph, KubeHound can "sniff out" Kubernetes misconfigurations in your cluster and work out how an attacker could chain them together.

This helps you to direct your security efforts toward the most vulnerable parts of your cluster.

---

## Slide 5: Understanding Misconfigurations
But what is a 'misconfiguration' in Kubernetes, exactly?

This is any risk you've introduced by the way you've set up your Kubernetes cluster. For example, running a privileged pod. Or making a service account that has cluster admin powers. And honestly, there are tools out there that can find these types of vulnerabilities too.

What sets KubeHound apart is that it doesn't just list the problems, it shows how they connect. It helps you see how misconfigurations can chain together into real attack paths. That way, you can understand whether an attacker could actually reach your critical assets and focus on fixing what truly matters. So, therefore….

---

## Slide 9: Key Insight - Graphs vs Lists
With KubeHound, you can think in GRAPHS, not LISTS! I'll say more about how this works later.

---

## Slide 10: Common Misconfigurations Setup
Right now I want to briefly go over a few examples of common Kubernetes misconfigurations, to help you understand that these are:
(A) perhaps more common than you realize, and that
(B) people with cluster access might introduce these misconfigurations without realizing the risks, and while having the best intentions. Or… at least not bad intentions

Okay. First example…

---

## Slide 11: Example 1 - Over-privileged Service Accounts
**What it is**: A pod running with a service account that has more permissions than it needs — sometimes even full cluster-admin rights.

**Why someone might do this**:
Perhaps a developer hit a frustrating permissions error during deployment, maybe a Helm chart failed, and so they granted their app cluster-admin "just to make it work," intending to fix it later.

---

## Slide 13: Example 2 - HostPath Mounts
**What it is**: A volume mount that maps part of the host filesystem directly into a container, effectively breaking isolation between them.

**Why someone might do this**:
Again, someone might be trying to diagnose an issue and they needed quick access to system logs or container runtime sockets, and to access those they made this shortcut for themselves.

---

## Slide 14: Example 3 - Insecure RBAC Bindings
**What it is**:
An RBAC configuration that gives a user or automation tool more power than intended, often via ClusterRoleBinding to cluster-admin.

**Why someone might do this**:
A CI/CD job was failing with permission errors, so they granted broad access to get it working and moved on to the next fire.

---

## Slide 16: The Critical Question
Let's assume we have a cluster with all of these issues… is this cluster secure?

We don't actually know. Are important assets able to be accessed? I can't tell from looking at this list. Can you? Can anyone?

We need to be able to reason about how (and whether) this list of misconfigurations can be used to access critical resources in our system.

---

## Slide 17: Graph-Based Security Posture
To do this, we can use KubeHound's graph way of thinking to quantify a security posture. Here's how it works:

---

## Slide 18: Attack Primitives Library
KubeHound has an Attack Primitives Library.

This library is a catalog of small attacker moves, called primitives. Each primitive is a single useful action an attacker might be able to do in a Kubernetes cluster — for example "use a service account token" or "exec into a container."

---

## Slide 19: Chaining Primitives into Attack Paths
KubeHound stitches those primitives together into longer chains that represent realistic attack paths

For example public service → compromise pod → steal token → escalate to cluster-admin. Bam!

So, KubeHound tells you how those problems can be used together. By encoding attacker behavior as reusable building blocks, KubeHound can automatically discover real, exploitable paths, understanding how an attacker might get from an initial foothold to critical assets.

So instead of that list of misconfigurations from earlier…

---

## Slide 20: The Big Picture
You can get a big picture of relationships into your cluster. It is a lot!

But KubeHound helps you translate that into what you actually want - a map of where the security failures are and where to put your attention.

KubeHound enables you to process all this information and then pinpoint where you are exposed.

That's really the power of a graph technology BUT you have to be able to cut through the noise

So here's how it works. There are three steps.

---

## Slide 22: Step 1 - Data Collection
First it connects to the Kubernetes API of a target cluster and collects entity data

"Entity data" is the set of Kubernetes objects and their important fields that KubeHound reads from the API so it can build the attack graph.

So not just Pods but container specs, Pod security context, pod volume mounts, pod labels.

Not just Services but service selectors, externalIPs, and nodePorts.

And the same for Nodes, ServiceAccounts, Roles & Role Bindings, Endpoints, Volumes… and on and on

---

## Slide 23: Step 2 - Graph Database Construction
Next KubeHound builds a graph database (using JanusGraph) representing possible attacker movements ("hops") across cluster assets.

JanusGraph is an open-source database designed to store and query information as a graph. It's built to handle massive datasets spread across many machines, making it useful when you need to understand how things are linked rather than just list them.

---

## Slide 24: Raw Data Complexity
The raw data here can be pretty overwhelming.

---

## Slide 25: Step 3 - Query and Visualization
KubeHound supports queries and visualization of attack paths

It does queries with KubeHound's built-in DSL that works with Gremlin query language.

Gremlin is the query language used to explore and analyze those graphs. It lets you describe traversals like "start here, follow these connections, filter by this property, and return the result." It is hard to master though.

That's why KubeHound adds its own simpler layer — a domain-specific language (DSL) — on top of Gremlin so users can ask high-level questions (like "show critical paths") without writing complex Gremlin syntax.

---

## Slide 26: Answering Real Questions
The goal is for defenders to be able to answer real questions such as "What is the shortest exploitable path from a publicly-facing service to cluster admin privileges?"

---

## Slide 27: Demo Repository
[KubeHound Demo Repository](https://github.com/wiggitywhitney/KubeHound-Demo)

---

## Slide 28: Performance at Scale
And, finally, KubeHound handles scale. Ingestion + computation takes "a few seconds for 1,000 pods" and "2 minutes for 10,000 pods" in typical configurations

---

## Slide 29: Beyond Local Demos
But that demo shows how it works in a local KIND cluster.

How can one use KubeHound at a big scale?

---

## Slide 30: KubeHound as a Service
You can run KubeHound at scale with KubeHound as a Service.

This has distributed collectors, centralized ingestion, and one, unified source of truth.

Here is an architecture diagram:

---

## Slide 31: Architecture Details
First we have the collector. A collector runs on each node of the cluster.

You can use a cron job to have it do a dump at a regular interval. At Datadog we do this daily. And then you push the resulting entity data into a data storage like an S3 bucket.

Then we send a signal to the ingestor part to say "hey there is a new dump that is being available, can you ingest it" So it's going to retrieve the dump, do the ingesting and creation on the graph and make it available directly into the UI.

You have like a central point where you can have all ingestion, and results on the other end. You have all the collectors and you can actually spin up as many as you want into your whole kubernetes cluster.

---

## Slide 33: Conclusion
The end! QR code to KubeHound website. Also link to my demo repo

---

## Key Narrative Elements for README

### Story Arc:
1. **Hook**: What is KubeHound? (Attack path identification)
2. **Problem**: Misconfigurations are common and often well-intentioned
3. **Key Insight**: Graphs vs Lists - seeing connections matters more than seeing individual problems
4. **Solution**: Attack Primitives Library + chaining = real attack paths
5. **Process**: Three steps (collect, build graph, query/visualize)
6. **Outcome**: Answer real security questions about your cluster

### Tone:
- Approachable and conversational
- Acknowledges that misconfigurations happen with good intentions
- Emphasizes practical value (directing security efforts where they matter)
- Shows complexity but explains how KubeHound makes it manageable

### Key Messages:
- **Differentiation**: KubeHound shows how problems connect, not just what they are
- **Practicality**: Focus on what truly matters for security
- **Scale**: Works from local demos to production clusters
- **Usability**: DSL layer makes graph queries accessible
