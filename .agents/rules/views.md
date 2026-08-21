---
trigger: glob
description: Rules for Flutter views — hierarchy, Riverpod notifiers, layouts
globs: dab_app/lib/presentation/views/**/*.dart
---

# Views — Presentation Layer Rules

These rules define how Flutter views, layouts, `Notifier`s, and states are structured in `dab_app`. Follow these patterns when creating or editing screens.

---

## 🗂️ Mandatory View Directory Structure

Every screen is a **self-contained folder** under `lib/presentation/views/<feature>/`.

```
views/
└── explorer/
    ├── explorer_view.dart           ← Entry: post-frame init + LayoutBuilder
    ├── explorer_notifier.dart       ← Riverpod Notifier + provider declaration
    ├── explorer_state.dart          ← Immutable screen state (@MappableClass)
    ├── explorer_item.dart           ← Optional local models for the view
    ├── layouts/
    │   ├── explorer_view_desktop.dart
    │   └── explorer_view_mobile.dart
    ├── widgets/                     ← one public widget class per file
    └── models/
```

When a parent widget needs child widgets, put them in a subfolder named after the parent (for example `widgets/dashboard_follow_search/dashboard_follow_search.dart` and `dashboard_follow_search_menu.dart`). Feature-only widgets stay under that feature’s `widgets/` folder (`dashboard/widgets`, not `core/widgets`).

Do **not** add presentation `*_event.dart` hierarchies; **user actions** are **notifier methods** on the screen’s `Notifier`.

---

## 📋 File Responsibilities

| File | Responsibility | What it must NOT do |
|---|---|---|
| `*_view.dart` | Schedule init (`started(...)`), delegate to `LayoutBuilder` | Own business rules beyond routing glue |
| `*_notifier.dart` | Orchestrate use cases, expose methods for UI actions | Call HTTP or DB directly |
| `*_state.dart` | Single immutable snapshot | Heavy computation — prefer extensions (`OnFooState`) |
| `*_view_desktop.dart` / `*_view_mobile.dart` | Layout only | Extra widget classes; repositories / Dio |
| `widgets/*.dart` | One public widget class (plus its `State` if stateful) | Extra widget classes in the same file |

---

## 🔑 View Entry Point Pattern

1. Root uses **`ProviderScope`** (see `main.dart`).
2. Screen triggers **`ref.read(..notifier).started(...)`** in `addPostFrameCallback` where bootstrap needs layout/context.
3. Layouts are **`ConsumerWidget`** / **`ConsumerStatefulWidget`** and **`ref.watch`** the relevant `…NotifierProvider`.

---

## 🎯 Riverpod Notifier Rules

- Declare providers next to the notifier: `final fooNotifierProvider = NotifierProvider.autoDispose<FooNotifier, FooState>(...)`.
- Notifiers **call use cases only** — never datasources or repositories directly.
- Prefer **`AutoDisposeNotifier`** for screens that should tear down with navigation.
- Replace discrete “events” with **methods** on the notifier (`toggleProvider`, `setDatePreset`, …).
- For **`ProviderContainer`** tests, **`listen`** autoDispose providers during async work so they are not disposed mid-await.

---

## 🧊 State Rules

- Single **`@MappableClass` state** with `ViewStatus`, `errorMessage`, and feature fields.
- **`factory FooState.initial()`** where applicable.
- Derived UI projections live in **`extension OnFooState on FooState`** in the same library file as state when they help widgets stay dumb.

---

## 🖥️ Layout Rules

- **Breakpoint**: `> 900px` → desktop; `≤ 900px` → mobile (unless a feature overrides).
- Scope **`ref.watch`** / **`Consumer`** to the smallest subtree that needs rebuilds.

---

## 🏷️ Naming Conventions

| Artifact | Pattern | Example |
|---|---|---|
| View entry | `[Feature]View` | `ExplorerView` |
| Notifier | `[Feature]Notifier` | `ExplorerNotifier` |
| Provider | `[feature]NotifierProvider` | `explorerNotifierProvider` |
| State class | `[Feature]State` | `ExplorerState` |
| Desktop layout | `[Feature]ViewDesktop` | `ExplorerViewDesktop` |

---

## 🚫 What Not to Do

- No business logic in widgets beyond wiring `ref` / navigation.
- No use cases or repositories imported from `layouts/` widgets — only notifiers via `ref`.
- Notifier tests use **`ProviderContainer`** + overrides + **`listen`** for autoDispose — no manual `emit`.
- No `BuildContext` across async gaps without `mounted` / lifecycle awareness.
