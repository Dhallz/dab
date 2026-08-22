# 📱 DAB Dashboard (Flutter)

The ultra-lean, sub-second real-time dashboard for DAB. Experience **high-frame-rate insight** through premium [glassmorphism](https://en.wikipedia.org/wiki/Glassmorphism) and strict Clean Architecture.

---

## 🏗️ Layered Architecture

| Layer | Responsibility | Pattern |
| :--- | :--- | :--- |
| **Presentation** | UI & screen state | Flutter + Riverpod (`Notifier`) |
| **Domain** | Models, use cases & contracts | Pure Dart + `Either` |
| **Infrastructure** | Local persistence & API clients | ObjectBox + Dio |
| **Composition** | Wiring | `ServiceLocator` (`sl`) |

> [!TIP]
> Dive deep into the mobile world: **[App Documentation](../doc/app.md)** and **[Design Conventions](../doc/conventions.md)**.

---

## 🚀 Ignition Checklist

1. **Gear Up**:
   ```bash
   flutter pub get
   ```

2. **Generate Native Bindings**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Launch the Experience**:
   ```bash
   flutter run
   ```

4. **Debug API in Docker** (optional): From the repo root, run **DAB API (Docker + Attach)** in `.vscode/launch.json`, then start **DAB App (Debug)** when the API is healthy.

---

## 🛠️ Performance Stack
- **State:** Riverpod notifiers + immutable `@MappableClass` states
- **Persistence:** ObjectBox (local-first explorer cache)
- **DI:** Custom `ServiceLocator` (`sl`) — not GetIt
- **Visuals:** Material 3 + custom glass design tokens

---
*Built for developers who value their pixels.*
