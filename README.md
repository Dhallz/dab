# DAB (Dev Activity Board)

> **"The Open-Source, Self-Hosted Event Bus for Modern Engineering Teams"**

---

## 🌩️ Stop the "Alt-Tab Tax"
As developers, **Flow State** is our most valuable asset. Yet, it gets fragmented across 5–7 different tools. The mental re-indexing cost of switching between Slack, Jira, Phorge, and Linear is the hidden tax on every engineering team.

**DAB** is the centralized engine that aggregates every signal you need into a single, high-performance interface.

- **Reclaim your flow:** Reclaim your screen real estate by replacing 7+ background applications with one lean dashboard.
- **Noise to Narrative:** Transform fragmented updates into a searchable chronological narrative of your work.
- **Sovereignty by Design:** Private-first infrastructure. All sensitive data is AES-256 encrypted and never leaves your network.

---

## 🛡️ Security & Privacy
DAB is designed as a **Sovereign Infrastructure**, not a SaaS. Your activity data is your most sensitive engineering intellectual property.
- **Zero-Trust Local Storage**: All provider tokens and secrets are AES-256 encrypted at rest.
- **Network Isolation**: Since DAB is self-hosted, your data never leaves your infrastructure. No external pings, no hidden telemetry.
- **Auditable Core**: Being open-source allows your security team to verify every encryption primitive and data-handling routine.
- **JWT Enforcement**: Industry-standard JSON Web Tokens (JWT) protect all API communication, with secure OS-level storage for client-side tokens.

---

## 🗺️ The "Thermal" Roadmap
We prioritize features based on "Thermal Heat" — community demand and developer friction points. Check the **[Provider Roadmap](file:///Users/dhallz/git/dab/doc/overview.md#7-provider-roadmap)** to see what's hot.

- ✅ **Phorge**: Tasks & Differential Revisions.
- 🔜 **Linear**: Issues & Project events.
- 🔜 **Slack**: Webhooks + Huddle transcriptions.
- 🔜 **GitHub/GitLab**: The complete dev cycle.

---

## 📁 Repository Structure

- **[dab_api](file:///Users/dhallz/git/dab/dab_api/)**: The backend hub built on [Relic](https://pub.dev/packages/relic). Handles ingestion, normalization, and WebSocket-first propagation.
- **[dab_app](file:///Users/dhallz/git/dab/dab_app/)**: The cross-platform Flutter client with premium glassmorphism and sub-second real-time updates.
- **[bruno/](file:///Users/dhallz/git/dab/bruno/)**: A git-native, local-first API collection. No cloud dependencies, just pure testing.
- **[doc/](file:///Users/dhallz/git/dab/doc/)**: The single source of truth for our architecture, standards, and roadmap.

---

## 🚀 Getting Started

### 1. Boot the Stack
DAB is fully self-hosted via Docker. Reclaim your environment in minutes:
```bash
cd dab_api
docker-compose up -d  # Starts PostgreSQL, Redis, API, and Swagger
```

**Services now live at:**
- **REST API**: [http://localhost:8080](http://localhost:8080)
- **Swagger UI**: [http://localhost:8081](http://localhost:8081)

### 2. Launch the Client
```bash
cd dab_app
flutter pub get
flutter run
```

### 3. Test the Pulse
Open the **[Bruno Collection](file:///Users/dhallz/git/dab/bruno/)**, select the `local` environment, and run the **Login** request to start seeing activity in real-time.

---

## 🤝 Community & Sovereignty
DAB exists because developers deserve visibility without micro-management. We are open-source and audit-first. Join us in reclaiming the screen.

*Reclaim your screen. Reclaim your focus.*
