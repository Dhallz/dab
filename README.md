# DAB (Dev Activity Board) ⚡

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Stack: Flutter](https://img.shields.io/badge/Client-Flutter-blue?logo=flutter)](https://flutter.dev)
[![Backend: Dart](https://img.shields.io/badge/Backend-Dart-0075b0?logo=dart)](https://dart.dev)
[![Engine: Relic](https://img.shields.io/badge/Engine-Relic-orange)](https://pub.dev/packages/relic)

> **"The Open-Source, Self-Hosted Event Bus for Modern Engineering Teams"**
> *Reclaim your screen. Reclaim your focus.*

---

## 🌩️ Destroy the "Alt-Tab Tax"

As developers, **Flow State** is our most precious currency. Yet, we spend it recklessly on fragmented tools. The mental re-indexing cost of jumping between Slack, Jira, Phorge, and Linear is a hidden tax on every line of code you write.

**DAB** is the centralized nerve center that aggregates every signal into a single, high-performance interface.

| Feature | The Old Way 🐌 | The DAB Way ⚡ |
| :--- | :--- | :--- |
| **Context Switching** | 7+ browser tabs & background apps | One lean, unified dashboard |
| **Visibility** | Fragmented notifications & "Where was that?" | A single, searchable chronological pulse |
| **Privacy** | Your IP living in everyone else's cloud | 100% Self-Hosted. Your data, your rules. |
| **Speed** | Waiting for page refreshes & cloud lag | Sub-second real-time sync via WebSockets |

---

## 🛡️ Sovereignty by Design (Security)

DAB isn't a SaaS; it's **Sovereign Infrastructure**. Your activity data is your team's most sensitive engineering IP. We treat it with appropriate respect.

*   **🔒 Zero-Trust Local Storage**: All provider tokens are AES-256 encrypted at rest.
*   **🌐 Network Isolation**: Your data never leaves your infrastructure. No external pings, no hidden telemetry.
*   **🕵️ Auditable Core**: 100% Open-Source. Verify every encryption primitive yourself.
*   **🔑 JWT Enforcement**: Industry-standard security for all inter-service communication.

---

## 🗺️ The "Thermal" Roadmap

We prioritize integrations based on **Thermal Heat** — community pulse and developer friction points.

*   ✅ **Phorge**: Full Differential & Task lifecycle support.
*   🚀 **Linear**: Issues & Project activity (Coming Soon).
*   💬 **Slack**: Webhook ingestion & Huddle transcriptions (Researching).
*   💻 **The Forge**: GitHub, GitLab, and Bitbucket integrations.

---

## 🏗️ Repository Architecture

| Component | Tech Stack | Responsibility |
| :--- | :--- | :--- |
| **[dab_api](./dab_api)** | Dart + Relic | The Hub. Handles ingestion, normalization, and sync. |
| **[dab_app](./dab_app)** | Flutter | The UI. Real-time [glassmorphism](https://en.wikipedia.org/wiki/Glassmorphism) dashboard. |
| **[bruno/](./bruno)** | Bruno | Automated, git-native API test suite. |
| **[doc/](./doc)** | Markdown | The **Single Source of Truth** for the entire project. |

---

## 🚀 Speed-to-Flow (Getting Started)

### 1️⃣ Boot the Nerve Center
Reclaim your environment in seconds using Docker:
```bash
cd dab_api
docker-compose up -d  # Postgres, Redis, API, and Swagger go live
```
🌐 **Services:** 
- **Core API**: [http://localhost:9080](http://localhost:9080)
- **Swagger Docs**: [http://localhost:9081](http://localhost:9081)

> Default host ports moved off the 808x range to avoid collisions with other local
> APIs. All are env-overridable via `API_PUBLIC_PORT`, `SWAGGER_PUBLIC_PORT`, and
> `DART_VM_PUBLIC_PORT` in `dab_api/.env`. Railway / hosted API:
> **[doc/deployment.md](./doc/deployment.md)**.

### 2️⃣ Launch the Dashboard
```bash
cd dab_app
flutter pub get && flutter run
```

### 3️⃣ Feel the Pulse
Open the **[Bruno Collection](./bruno)**, point to the `local` environment, and run the **Login** request. Your local activity bus is now live.

---

## 🤝 Join the Sovereignty Movement

DAB exists because developers deserve visibility without micro-management. We are built for those who value their focus above all else. 

**Stop searching. Start building.**

