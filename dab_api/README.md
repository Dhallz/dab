# dab_api

A web server built with the [Relic](https://pub.dev/packages/relic) framework.

## Getting Started Locally

1. Ensure you have the dependencies installed:
   ```bash
   dart pub get
   ```

2. Start the Postgres database via Docker Compose:
   ```bash
   docker-compose up -d db
   ```

3. Run the development server with hot reload:
   ```bash
   dart run --enable-vm-service bin/dab_api.dart
   ```
   *Note: Relic will automatically re-configure your internal routes when your IDE (like VS Code or IntelliJ) triggers a Hot Reload.*

## Docker Development Setup (Hot Reloading)

This API is configured to run entirely inside a Docker container for development while still providing instant Hot Reload via your IDE.

**1. Run the Development Container**
Use the provided `docker-compose.yml` to spin up both your Postgres database and the Relic API:
```bash
docker-compose up -d api
```

**2. Attach for Hot Reloading**
The container targets your local directory (`.:/app`) and exposes the Dart VM service on port `8181`.
To get hot reload working inside the container:
- Open your code editor (e.g., VS Code or IntelliJ).
- Attach your IDE's debugger to the Dart VM running at `ws://127.0.0.1:8181/ws`.
- Modify your route handlers or controllers.
- When you hit save, your IDE will send a Hot Reload signal to the container, and Relic will magically update the routes without restarting the API!

*If you change the core server startup logic inside `main()`, you must restart the container:*
```bash
docker-compose restart api
```

## Production Deployment

A `Dockerfile` is provided for production deployment. When you trigger a `docker build` without targeting the development stage, Docker will orchestrate a multi-stage process that compiles your API down to an ultra-fast Native AOT executable.

**1. Build the Production Image**
```bash
docker build -t dab_api:latest .
```

**2. Run the Production Image**
You can deploy your built `dab_api:latest` image to your preferred hosting provider, orchestrator, or simply run it directly:
```bash
docker run -p 8081:8081 -e DB_HOST=your_host -e DB_PASSWORD=your_password dab_api:latest
```
