# DAB (Dev Activity Board)

Welcome to the DAB project. This repository contains both the API server and the Flutter client application, following Clean Architecture principles.

## 📁 Project Structure

- **[dab_api](file:///Users/dhallz/git/dab/dab_api/)**: The backend server built with the [Relic](https://pub.dev/packages/relic) framework.
- **[dab_app](file:///Users/dhallz/git/dab/dab_app/)**: The cross-platform Flutter client application.
- **[artifacts](file:///Users/dhallz/git/dab/artifacts/)**: Project architecture, coding standards, and implementation plans.

## 🚀 Getting Started

### 1. Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Latest Stable)
- [Dart SDK](https://dart.dev/get-dart)
- [Docker](https://www.docker.com/products/docker-desktop/) (for API & Database)

### 2. Backend Setup (`dab_api`)
Navigate to the `dab_api` directory:
```bash
cd dab_api
docker-compose up -d  # Starts Postgres and the Relic API
```
For more details, see the [DAB API README](file:///Users/dhallz/git/dab/dab_api/README.md).

### 3. Client Setup (`dab_app`)
Navigate to the `dab_app` directory:
```bash
cd dab_app
flutter pub get
flutter run
```
For more details, see the [DAB App README](file:///Users/dhallz/git/dab/dab_app/README.md).

## 🏗️ Architecture & Standards
The project strictly follows **Clean Architecture**. For detailed documentation on our standards and patterns, please refer to the `artifacts` folder:
- [Client Architecture](file:///Users/dhallz/git/dab/artifacts/client_architecture.md)
- [Code Conventions](file:///Users/dhallz/git/dab/artifacts/code_conventions.md)
- [Presentation Hierarchy](file:///Users/dhallz/git/dab/artifacts/presentation_hierarchy.md)

## 🛠️ Development Workflow
- **Code Generation**: Both projects use `build_runner`. Use `flutter pub run build_runner build` in the respective folders to sync generated files.
- **Hot Reload**: Relic API supports hot reload inside Docker when attached to the Dart VM.

---
*Powered by Clean Architecture & Relic.*
