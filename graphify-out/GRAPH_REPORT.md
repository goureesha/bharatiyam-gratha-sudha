# Graph Report - bharatheeyam books  (2026-06-17)

## Corpus Check
- 44 files · ~5,781,311 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 43 nodes · 43 edges · 8 communities (7 shown, 1 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `fd09e4e7`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]

## God Nodes (most connected - your core abstractions)
1. `ScriptureService` - 2 edges
2. `StotraService` - 2 edges
3. `auth` - 1 edges
4. `db` - 1 edges
5. `State` - 1 edges
6. `CATEGORIES` - 1 edges
7. `App` - 1 edges
8. `timestamp` - 1 edges
9. `conversation_id` - 1 edges
10. `commit_message` - 1 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Import Cycles
- None detected.

## Communities (8 total, 1 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.50
Nodes (3): commit_message, conversation_id, timestamp

### Community 4 - "Community 4"
Cohesion: 0.15
Nodes (12): int get, List, ../models/stotra.dart, allCategories, _extrasCategories, getCategory, getStotra, init (+4 more)

### Community 5 - "Community 5"
Cohesion: 0.17
Nodes (11): bool get, dart:convert, ../models/scripture.dart, package:cloud_firestore/cloud_firestore.dart, package:flutter/material.dart, package:flutter/services.dart, _books, getBook (+3 more)

### Community 6 - "Community 6"
Cohesion: 0.29
Nodes (5): App, auth, CATEGORIES, db, State

### Community 7 - "Community 7"
Cohesion: 0.67
Nodes (3): ChangeNotifier, ScriptureService, StotraService

## Knowledge Gaps
- **23 isolated node(s):** `auth`, `db`, `State`, `CATEGORIES`, `App` (+18 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `StotraService` connect `Community 7` to `Community 4`?**
  _High betweenness centrality (0.019) - this node is a cross-community bridge._
- **Why does `ScriptureService` connect `Community 7` to `Community 5`?**
  _High betweenness centrality (0.013) - this node is a cross-community bridge._
- **What connects `auth`, `db`, `State` to the rest of the system?**
  _23 weakly-connected nodes found - possible documentation gaps or missing edges._