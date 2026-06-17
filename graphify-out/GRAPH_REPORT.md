# Graph Report - bharatheeyam books  (2026-06-17)

## Corpus Check
- 44 files · ~5,780,846 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 8 nodes · 4 edges · 4 communities (3 shown, 1 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `67bcd569`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]

## God Nodes (most connected - your core abstractions)
1. `timestamp` - 1 edges
2. `conversation_id` - 1 edges
3. `commit_message` - 1 edges
4. `Task List - Admin Website & Firestore Integration` - 1 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Import Cycles
- None detected.

## Communities (4 total, 1 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.50
Nodes (3): commit_message, conversation_id, timestamp

## Knowledge Gaps
- **4 isolated node(s):** `timestamp`, `conversation_id`, `commit_message`, `Task List - Admin Website & Firestore Integration`
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What connects `timestamp`, `conversation_id`, `commit_message` to the rest of the system?**
  _4 weakly-connected nodes found - possible documentation gaps or missing edges._