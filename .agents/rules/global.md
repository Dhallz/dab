---
trigger: always_on
description: Core project architecture and behavioral rules
---

# DAB Project — Global AI Agent Rules

These rules apply to **every folder** in the DAB workspace. 
Folder-specific rules in each sub-package's `.agents/rules.md` **supplement** these global rules — they do not override them.

---

## 🏛️ Architecture: Clean Architecture is Non-Negotiable

The entire DAB project follows **Clean Architecture** with strict, one-directional layer dependencies:

```
Domain  →  Application  →  Infrastructure  →  Presentation
```

| Layer | Role | Key Constraint |
|---|---|---|
| **Domain** | Business entities, interfaces, mappers | **Zero** imports from any other layer |
| **Application** | Use cases, service orchestration | No direct DB/HTTP knowledge |
| **Infrastructure** | DB repos, HTTP sources, connectors | Implements Domain contracts only |
| **Presentation** | REST controllers, Flutter widgets/cubits | Delegates to use cases — no business logic |

**Never violate layer import rules.** If a proposed change requires importing a higher-level concern into a lower-level layer, the design is wrong — refactor the abstraction instead.

---

## 🧰 Technology Constraints

| Concern | Canonical Tool | Never Use |
|---|---|---|
| Dart SDK | `^3.9.2` (both packages) | — |
| Serialization | `dart_mappable` (`@MappableClass`) | `json_serializable`, manual `toJson` |
| Functional errors | `fpdart` (`Either<Failure, T>`) | `throw` as control flow |
| DI — API | `GetIt` via `sl<T>()` in `service_locator.dart` | Manual instantiation in business logic |
| DI — App | Custom `ServiceLocator` | Manual instantiation in business logic |
| Testing | `mocktail` + `test` / Riverpod `ProviderContainer` | `mockito`, inline anonymous mocks |
| Test data | Object Mother / Factory (`TestData` class) | Inline entity construction in test bodies |
| Code generation | `build_runner` | Manual editing of generated files |

---

## 📝 Dart Code Style

- **Doc-comments** use `///`, not `//`, on all public APIs.
- Public APIs must document **role, contract, and constraints** — not just what a field is.
- Annotate classes with `[ARCH: LAYER_NAME]` (e.g., `[ARCH: DOMAIN]`) so layer ownership is always explicit.
- Prefer `final` fields and immutable data classes everywhere.
- Use `sealed class` for exhaustive discriminated unions (e.g., `Failure`, `ActivityProvider`).
- **Relative URLs only** in business logic. Full URL construction lives at the client or config layer.
- One public class / entity / use case per file. Never combine unrelated concerns.

---

## 🧪 Testing Rules

- Every new **service**, **use case**, or **repository** must have a corresponding unit test file.
- Use the **Object Mother / Factory** pattern (`TestData` class) for all test fixtures.
- Mock at the **interface / repository boundary** — never on concrete classes.
- Tests must be **deterministic**: no real network calls, no `DateTime.now()` without injection.
- After adding or changing a test, run the full test suite for the affected package before declaring work done.

---

## 🔒 Security & Data Integrity

- DAB is a **read-only observer**. Write operations to external provider systems are **strictly forbidden** inside any activity stream or sync logic.
- Never log sensitive values (tokens, passwords, PII) in any layer.
- Auth tokens must be handled exclusively through `TokenStorage` / `FlutterSecureStorage`.
- Provider credentials must never appear in plaintext in version-controlled files.

---

## 🤖 Agent Behaviour Rules

1. **Read before writing.** Inspect existing patterns in the layer you are modifying before creating new files.
2. **Run the analyzer before declaring done.** After any Dart change run `dart analyze` (API) or `flutter analyze` (App). Zero errors is the bar.
3. **Run `build_runner` after schema changes.** Any modification to `@MappableClass`, Drift tables, or ObjectBox entities requires:  
   `dart run build_runner build --delete-conflicting-outputs`
4. **Never modify generated files** (`*.mapper.dart`, `*.g.dart`, `objectbox.g.dart`). Regenerate them.
5. **Propose before deleting.** If removing a file or entity seems necessary, flag it to the user first.
6. **One concern per file.** Do not combine unrelated entities or use cases in the same Dart file.
7. **Check folder-specific rules.** Before working in `dab_api/` or `dab_app/`, read that package's `.agents/rules.md`.
8. **Update documentation when changing behaviour.** The `doc/` folder at the project root is the single source of truth for all documentation. See `.agents/rules/doc-maintenance.md` for details.
9. **Update the Bruno collection when changing the API.** The `bruno/` folder contains the canonical API collection. See `.agents/rules/bruno-maintenance.md` for details.
10. **Git commits.** **Never** commit unless the user explicitly asks. When they ask, follow `.agents/rules/commit.md`: **one commit per explicit request**, subject lines that include the active issue key when applicable (e.g. `DAB-40: …`), and **no** Cursor/AI attribution or meta footers in the message.

---

## 📖 Documentation Reference

All project documentation lives in `doc/` at the repo root.

| File | Contents |
|---|---|
| `doc/overview.md` | What DAB is and the problem it solves |
| `doc/architecture.md` | Layer map, entities, data flow, shared patterns |
| `doc/api.md` | Backend controllers, patterns, DI, provider roadmap |
| `doc/app.md` | Flutter client layers, Riverpod, routing, design system |
| `doc/infrastructure.md` | PostgreSQL, Redis, WebSocket, Docker |
| `doc/conventions.md` | Naming rules, tech stack, code style |