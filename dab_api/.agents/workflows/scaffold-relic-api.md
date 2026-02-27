---
description: Scaffold a new Relic API with Docker and Postgres support. Takes API name and port.
---
# Scaffold Relic API

This workflow will initialize a new Dart project and configure it with the Relic web framework, PostgreSQL, and a multi-stage Docker environment optimized for both local hot-reload and production AOT compilation.

**Instructions for the Assistant:** 
Before starting, ensure the user has provided the `{API_NAME}` and `{PORT}` they want to use. If they have not, ask them for these values.
Once you have the `{API_NAME}` and `{PORT}`, execute the following steps, replacing all instances of `{API_NAME}` and `{PORT}` in the commands and file contents with the provided values.

// turbo-all

1. Create a basic console Dart project:
```bash
dart create -t console --force {API_NAME}
```

2. Add the necessary dependencies:
```bash
cd {API_NAME} && dart pub add relic postgres
```

3. Replace the `bin/{API_NAME}.dart` entrypoint with the Relic server boilerplate.
Create `bin/{API_NAME}.dart`:
```bash
cd {API_NAME} && cat << 'EOF' > bin/{API_NAME}.dart
import 'dart:io';
import 'package:relic/io_adapter.dart';
import 'package:relic/relic.dart';

Future<void> main() async {
  final app = RelicApp()
    ..get('/hello/:name', _helloHandler)
    ..use('/', logRequests())
    ..fallback = respondWith(
      (_) => Response.notFound(
        body: Body.fromString("Not Found\n"),
      ),
    );

  // Bind to 0.0.0.0 for Docker compatibility
  await app.serve(address: InternetAddress.anyIPv4, port: {PORT});
}

Response _helloHandler(final Request req) {
  final name = req.pathParameters.raw[#name];
  return Response.ok(
    body: Body.fromString('Hello, $name!\n'),
  );
}
EOF
```

4. Create the development and production `docker-compose.yml`:
```bash
cd {API_NAME} && cat << 'EOF' > docker-compose.yml
services:
  db:
    image: postgres:16-alpine
    container_name: postgres
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: {API_NAME}_db
    ports:
      - "5433:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data

  api:
    container_name: {API_NAME}
    build:
      context: .
      target: build
    ports:
      - "{PORT}:{PORT}"
      - "8181:8181"
    volumes:
      - .:/app
      - /app/.dart_tool
    command: sh -c "dart pub get && dart run --enable-vm-service=8181/0.0.0.0 bin/{API_NAME}.dart"
    environment:
      - DB_HOST=postgres
      - DB_PORT=5433
      - DB_USER=user
      - DB_PASSWORD=password
      - DB_NAME={API_NAME}_db
    depends_on:
      - db

volumes:
  pgdata:
EOF
```

5. Create the optimized `Dockerfile` for production:
```bash
cd {API_NAME} && cat << 'EOF' > Dockerfile
# Use latest stable channel SDK.
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code.
COPY . .
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
RUN dart compile exe bin/{API_NAME}.dart -o bin/server

# Build minimal serving image from AOT-compiled `/server`
# and the pre-compiled AOT runtime.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

# Start server.
EXPOSE {PORT}
CMD ["/app/bin/server"]
EOF
```
