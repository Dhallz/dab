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
   docker compose up -d db redis  # Postgres & Redis only (manual API on host)
   # Or full stack including API in Docker (VM service on host :9181):
   docker compose up -d
   ```

3. **Ignite the Server** (on host, or use Docker + IDE attach — see below):
   ```bash
   dart run --enable-vm-service bin/dab_api.dart
   ```
   *Note: Relic supports hot reload when an IDE debugger is attached.*

4. **Debug API in Docker**: From the repo root, run **DAB API (Docker + Attach)**
   (`.vscode/launch.json`) — starts compose and attaches the debugger. Start
   **DAB App (Debug)** separately when you want the client. See
   **[Infrastructure Guide](../doc/infrastructure.md)** → *Debugging*.

---

## 🧪 Testing with Bruno
We use **Bruno** for Git-native, local-first API exploration. The collection is located in the root `/bruno` folder.
👉 **[Open Bruno Collection](../bruno/)**

---

## 🐳 Production image

```bash
docker build -t dab_api:latest .
```

AOT `scratch` image (Drift migrates in process; there is no `migrations/`
folder). Local Compose vs Railway env, TLS, and the Flutter `--dart-define`
are in **[deployment.md](../doc/deployment.md)**.

