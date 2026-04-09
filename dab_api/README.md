# ⚙️ DAB API Engine

The high-performance backend ecosystem for DAB. Built with **Clean Architecture** and powered by the [Relic](https://pub.dev/packages/relic) framework for low-latency, WebSocket-first activity propagation.

---

## 🏗️ Architecture Stack

| Layer | Responsibility | Tech |
| :--- | :--- | :--- |
| **Domain** | Business Logic & Entities | Pure Dart |
| **Application** | Use Cases & Flow Control | Relic Business Logic |
| **Infrastructure** | Persistence & External Auth | PostgreSQL + Redis |
| **Presentation** | REST & WebSocket Endpoints | [Relic Native Server](https://pub.dev/packages/relic) |

> [!IMPORTANT]
> For a deep dive into the API structure, see the **[API Reference](../doc/api.md)** and **[Infrastructure Guide](../doc/infrastructure.md)**.

---

## 🚀 Getting Started (Dev)

1. **Install Gear**:
   ```bash
   dart pub get
   ```

2. **Boot Infrastructure**:
   ```bash
   docker-compose up -d db redis  # Postgres & Redis only (use for manual API runs)
   ```

3. **Ignite the Server**:
   ```bash
   dart run --enable-vm-service bin/dab_api.dart
   ```
   *Note: Relic supports hot reload when an IDE debugger is attached.*

---

## 🧪 Testing with Bruno
We use **Bruno** for Git-native, local-first API exploration. The collection is located in the root `/bruno` folder.
👉 **[Open Bruno Collection](../bruno/)**

---

## 🐳 Production Deployment
To build a Native AOT optimized Docker image:
```bash
docker build -t dab_api:latest .
```

