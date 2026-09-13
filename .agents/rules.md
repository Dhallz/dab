---
trigger: always_on
glob: "**/*"
description: Main entry point for DAB project agent rules
---

# DAB Project — Rule Manifest

This is the primary entry point for AI agent rules in the DAB repository. To maintain manageable file sizes and clear boundaries, rules are organized into modular files within the `.agents/rules/` directory.

**Cursor:** The same rules are mirrored for Cursor as `.mdc` files under `.cursor/rules/` (see `dab-manifest.mdc` for the index). Edit here if you treat `.agents/` as source; re-copy or sync to `.cursor/rules/` when you change content.

## 📋 Rule Hierarchy

### 1. Global Project Rules
These apply to all packages and establish core architectural and behavioral standards.
- **[Global Project Rules](rules/global.md)**: Clean Architecture mapping, tech stack constraints (Dart/Flutter), and general agent behavior.

### 2. Pattern Rules
Detailed prescriptive patterns that must be followed when writing specific types of code. These apply across both packages.
- **[Functional Programming](rules/functional-programming.md)**: `Either`, `fpdart`, `AppFailure`, `guardedCall` — never throw as control flow.
- **[Data Classes](rules/data-classes.md)**: Entity anatomy, `dart_mappable`, immutability, sealed classes, `build_runner`.
- **[Views](rules/views.md)**: View hierarchy, Riverpod notifier/state patterns, layout breakpoints, naming.

### 3. Maintenance Rules
Specific guidelines for keeping supporting artifacts in sync with codebase changes.
- **[Documentation Maintenance](rules/doc-maintenance.md)**: Rules for updating `doc/*.md` files.
- **[Bruno Collection Maintenance](rules/bruno-maintenance.md)**: Rules for updating the API collection in `bruno/`.
- **[Git commits](rules/commit.md)**: Commit only when the user explicitly asks; one commit per request; issue-key subjects when applicable (e.g. DAB-40); no AI/tool attribution in commit messages.

### 4. Package-Specific Rules
Each major package contains its own refined rules in its local `.agents/` folder.
- **[DAB API Rules](../dab_api/.agents/rules.md)**: Relic, Drift, and server-side patterns.
- **[DAB App Rules](../dab_app/.agents/rules.md)**: Riverpod, go_router, ObjectBox, and custom `ServiceLocator`.

---

> [!TIP]
> **Always refer to the Global Project Rules first** before applying package-specific supplements. If you find an inconsistency, prioritize the Global rules and flag the deviation.
