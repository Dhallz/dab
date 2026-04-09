# 📱 DAB Dashboard (Flutter)

The ultra-lean, sub-second real-time dashboard for DAB. Experience **high-frame-rate insight** through premium [glassmorphism](https://en.wikipedia.org/wiki/Glassmorphism) and strict Clean Architecture.

---

## 🏗️ Layered Architecture

| Layer | Responsibility | Pattern |
| :--- | :--- | :--- |
| **Presentation** | UI & Event Handling | Flutter + Bloc/Cubit |
| **Application** | State Management & Logic | Business Case Cubits |
| **Domain** | Primitive Models & Contracts | Pure Models |
| **Infrastructure** | Local Persistence & API Clients | Drift (SQLite) + Dio |

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

---

## 🛠️ Performance Stack
- **State Engine**: Bloc/Cubit (Predictable State)
- **Fluid Persistence**: Drift/SQLite (Local-First Sync)
- **Injection**: GetIt (Performance-first DI)
- **Visuals**: Material 3 + Custom Glass Shader System

---
*Built for developers who value their pixels.*

