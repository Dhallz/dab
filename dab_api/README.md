# DAB API Server

The backend ecosystem for DAB, built on Clean Architecture and powered by the **Relic** framework.

## 🏗️ Architecture
This package handles the **Domain** (Entities/Interfaces) and **Infrastructure** (Postgres, Redis, Connectors) layers. For a deep dive into the API structure, see:
- **[API Reference](file:///Users/dhallz/git/dab/doc/api.md)**
- **[Infrastructure & Database](file:///Users/dhallz/git/dab/doc/infrastructure.md)**

## 🚀 Getting Started Locally

1. **Install Dependencies**:
   ```bash
   dart pub get
   ```

2. **Start Infrastructure**:
   ```bash
   docker-compose up -d db redis  # Starts Postgres and Redis
   ```

3. **Run Dev Server**:
   ```bash
   dart run --enable-vm-service bin/dab_api.dart
   ```
   *Note: Relic supports hot reload when an IDE debugger is attached.*

## 🧪 Testing
We use **Bruno** for API testing. The collection is located at the project root:
- **[Bruno Collection](file:///Users/dhallz/git/dab/bruno/)**

## 🐳 Docker Production Build
To build a Native AOT production image:
```bash
docker build -t dab_api:latest .
```
