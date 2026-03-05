# Client-Side Vegas Sync Implementation 📱 🔄

Synchronize the DAB Flutter application with the new Redis-backed infrastructure, implementing the **Vegas Sync Pattern** and the **Envelope Pattern** for response parsing.

## Proposed Changes

### 🗄️ Persistence Layer
- **[MODIFY] [app_settings_record.dart](file:///Users/dhallz/git/dab/dab_app/lib/infrastructure/core/local/records/app_settings_record.dart)**: Add `syncToken` field (String) to track the global version clock.
- **[MODIFY] [app_settings.dart](file:///Users/dhallz/git/dab/dab_app/lib/domain/entities/system/app_settings.dart)**: Update domain entity to include `syncToken`.

---

### 📡 Networking Layer
- **[NEW] `VegasInterceptor`**: 
    - Incoming: Extract `meta.syncToken` from responses and update local storage.
    - Outgoing: Inject `X-Sync-Token` header into every request using the stored value.
    - Status Handling: Handle `304 Not Modified` globally to prevent redundant UI rebuilds.
- **[MODIFY] [rest_api_client.dart](file:///Users/dhallz/git/dab/dab_app/lib/infrastructure/core/remote/rest_api_client.dart)**: Register the `VegasInterceptor`.

---

### ⛩️ Infrastructure Layer
- **[MODIFY] [activity_repository.dart](file:///Users/dhallz/git/dab/dab_app/lib/infrastructure/repositories/activity_repository.dart)**: 
    - Update `getRecentActivities` to parse the **Envelope Pattern** (`response.data['data']`).
    - Integrate the local `syncToken` from `SystemLocalDataSource`.

---

### 📖 Documentation
- **[MODIFY] [dab_client.md](file:///Users/dhallz/.gemini/antigravity/brain/fdd8dea3-1d8a-45a4-a54b-0ced8a3d9025/dab_client.md)**: Update the blueprint with Vegas Sync specifications.

## Verification Plan

### Automated Tests
- Integration tests verifying that `X-Sync-Token` is sent in headers.
- Unit tests for Envelope parsing logic.

### Manual Verification
- Verify that activities still load correctly with the new response structure.
- Check logs to confirm `304` responses are received when data is fresh.
