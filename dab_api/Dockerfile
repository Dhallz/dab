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
RUN dart compile exe bin/dab_api.dart -o bin/server

# Build minimal serving image from AOT-compiled `/server`
# and the pre-compiled AOT runtime.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/server
COPY --from=build /app/migrations /app/migrations

# Start server.
WORKDIR /app
EXPOSE 8080
CMD ["/app/server"]
