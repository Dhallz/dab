---
trigger: glob
description: Rules for Flutter views — hierarchy, naming, BLoC/Cubit, layouts
globs: dab_app/lib/presentation/views/**/*.dart
---

# Views — Presentation Layer Rules

These rules define how all Flutter views, layouts, BLoC/Blocs, events, and states must be structured in `dab_app`. Follow these patterns exactly when creating any new screen or feature area.

---

## 🗂️ Mandatory View Directory Structure

Every screen is a **self-contained folder** under `lib/presentation/views/<feature>/`.

```
views/
└── explorer/                     ← Feature folder — snake_case name
    ├── explorer_view.dart         ← Entry point: BlocProvider + LayoutBuilder only
    ├── explorer_bloc.dart         ← Business logic (extends AbsBloc or Cubit)
    ├── explorer_event.dart        ← Sealed event hierarchy (@MappableClass)
    ├── explorer_state.dart        ← Single state class (@MappableClass)
    ├── explorer_item.dart         ← Optional: local domain models for the view
    ├── layout/
    │   ├── explorer_view_desktop.dart   ← Desktop layout widget
    │   └── explorer_view_mobile.dart    ← Mobile layout widget
    └── widgets/
        ├── activity_card.dart     ← Private local widgets, one per file
        └── ...
```

All files must be named in `snake_case` with the feature prefix.

---

## 📋 File Responsibilities (Non-Negotiable)

| File | Responsibility | What it must NOT do |
|---|---|---|
| `*_view.dart` | Provide `BlocProvider`, dispatch the init event, delegate to `LayoutBuilder` | Contain any business logic or UI code |
| `*_bloc.dart` / `*_cubit.dart` | Handle events, call use cases, emit state | Call HTTP, interact with DB, or build widgets |
| `*_event.dart` | Sealed event hierarchy | Contain any logic |
| `*_state.dart` | Single immutable snapshot of screen state | Contain computed logic — use getters or extensions |
| `*_view_desktop.dart` | Build the desktop layout | Provide BLoC — the parent `_view.dart` already does this |
| `*_view_mobile.dart` | Build the mobile layout | Provide BLoC — same as above |
| `widgets/*.dart` | One small, focused, reusable widget per file | Depend on anything from `infrastructure` |

---

## 🔑 View Entry Point Pattern

The `*_view.dart` does exactly three things:
1. Provides the BLoC/Cubit via `BlocProvider`.
2. Dispatches the initial event (e.g., `ExplorerStarted`).
3. Delegates to `LayoutBuilder` to switch between mobile/desktop layouts.

```dart
// ✅ Correct — explorer_view.dart
class ExplorerView extends StatelessWidget {
  const ExplorerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExplorerBloc(
        sl.activityUseCases,
        sl.userUseCases,
        sl.metadataUseCases,
      )..add(const ExplorerStarted()), // ← dispatch init event here
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 900) return const ExplorerViewDesktop();
          return const ExplorerViewMobile();
        },
      ),
    );
  }
}
```

---

## 🎯 BLoC vs Cubit

- Use **`Bloc<Event, State>`** when the feature has **explicit, discrete user interactions** (e.g., button presses, filters) that must map to named events.
- Use **`Cubit<State>`** for simpler features where state changes are driven by a handful of method calls without complex event logic.
- All Blocs must extend `AbsBloc<E, S>`. All Cubits must extend a base Cubit if one exists.
- **Never use `Bloc` when a `Cubit` is sufficient.** Keep complexity proportional.

---

## ⚡ Event Rules (BLoC only)

Events form a **`sealed` class hierarchy** using `dart_mappable`:

```dart
// ✅ Correct — explorer_event.dart
@MappableClass()
sealed class ExplorerEvent with ExplorerEventMappable {
  const ExplorerEvent();
}

@MappableClass()
class ExplorerStarted extends ExplorerEvent with ExplorerStartedMappable {
  const ExplorerStarted();
}

@MappableClass()
class ExplorerDateChanged extends ExplorerEvent with ExplorerDateChangedMappable {
  final DateTime date;
  const ExplorerDateChanged(this.date);
}
```

- One event class per user action or system trigger.
- Event names use `[Feature][Action]` naming: `ExplorerDateChanged`, `AuthLogoutRequested`.
- Events are **always `const`** — they carry no mutable data.
- Register all event handlers in the Bloc constructor using `on<EventType>(_handler)`.

---

## 🧊 State Rules

State is a **single immutable class** using `dart_mappable`, not a sealed hierarchy:

```dart
// ✅ Correct — explorer_state.dart
enum ExplorerStatus { initial, loading, success, failure }

@MappableClass()
class ExplorerState with ExplorerStateMappable {
  final ExplorerStatus status;
  final List<Activity> items;
  final String? errorMessage;

  const ExplorerState({
    this.status = ExplorerStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  factory ExplorerState.initial() => const ExplorerState();
}
```

- Always include a `status` field using the `[Feature]Status` enum with at minimum: `initial`, `loading`, `success`, `failure`.
- Always provide a `factory [State].initial()` constructor.
- Always include `errorMessage` for the failure case.
- Use `copyWith` (generated) for every state update — never construct a new state from scratch in the Bloc.

---

## 🖥️ Layout Rules

- **Breakpoint**: `> 900px` → desktop layout; `≤ 900px` → mobile layout.
- Layout widgets (`*_view_desktop.dart`, `*_view_mobile.dart`) access the BLoC via `context.read<FeatureBloc>()` or `context.watch<FeatureBloc>()` — they do **not** provide it.
- `BlocBuilder` and `BlocConsumer` must be scoped to the **smallest widget that needs a rebuild**. Never wrap an entire page layout in a `BlocBuilder`.

```dart
// ✅ Correct — scoped to only the widget that needs the data
BlocSelector<ExplorerBloc, ExplorerState, ExplorerStatus>(
  selector: (state) => state.status,
  builder: (context, status) => StatusWidget(status: status),
)

// ❌ Wrong — rebuilds the entire layout on every state change
BlocBuilder<ExplorerBloc, ExplorerState>(
  builder: (context, state) => Scaffold( ... entire page ... ),
)
```

---

## 🏷️ Naming Conventions

| Artifact | Pattern | Example |
|---|---|---|
| View entry | `[Feature]View` | `ExplorerView` |
| BLoC | `[Feature]Bloc` | `ExplorerBloc` |
| Cubit | `[Feature]Cubit` | `AuthCubit` |
| Event base | `[Feature]Event` | `ExplorerEvent` |
| Event subclass | `[Feature][Action]` | `ExplorerDateChanged` |
| State class | `[Feature]State` | `ExplorerState` |
| Status enum | `[Feature]Status` | `ExplorerStatus` |
| Desktop layout | `[Feature]ViewDesktop` | `ExplorerViewDesktop` |
| Mobile layout | `[Feature]ViewMobile` | `ExplorerViewMobile` |

---

## 🚫 What Not to Do

- **Never call use cases or repositories directly from a widget.** All calls go through the BLoC/Cubit.
- **Never `emit()` inside tests manually.** Use `bloc_test`'s `blocTest<>()`.
- **Never use `BuildContext` across async gaps** without checking `mounted` first.
- **Never combine two unrelated feature BLoCs** into one file or one class.
- **Never use a state `sealed` hierarchy** (e.g., `Loading extends State`, `Success extends State`) — use a single class with a `status` enum instead.