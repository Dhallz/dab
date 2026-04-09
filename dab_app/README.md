# DAB App (Flutter Client)

The cross-platform client for the Dev Activity Board, built with Flutter and following strict Clean Architecture principles.

## 🏗️ Architecture
The app uses **Cubit** for state management and follows the `Presentation -> Application -> Domain` hierarchy. For a deep dive into the client structure, see:
- **[App Reference](file:///Users/dhallz/git/dab/doc/app.md)**
- **[Code Conventions](file:///Users/dhallz/git/dab/doc/conventions.md)**

## 🚀 Getting Started

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run Code Generation**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Launch the App**:
   ```bash
   flutter run
   ```

## 🛠️ Tech Stack
- **State Management**: Bloc/Cubit
- **Persistence**: Drift (SQLite)
- **Dependency Injection**: GetIt
- **UI Components**: Material 3 / Custom Design System

*Powered by Clean Architecture.*
