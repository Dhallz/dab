import '../../objectbox.g.dart';
import '../core/local/objectbox_store.dart';
import '../core/local/records/auth_credential_record.dart';
import '../core/local/records/user_record.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Persistence layer for User profile and saved Credentials using ObjectBox.
/// CONTRACT: Provides synchronous CRUD operations for local data [Box]es.
/// CONSTRAINTS: Must only handle [Record] types. Responsibility for Domain mapping lies with the Repository.
class AuthLocalDataSource {
  final Box<UserRecord> _userBox;
  final Box<AuthCredentialRecord> _credentialBox;

  AuthLocalDataSource(ObjectBoxStore store)
    : _userBox = store.store.box<UserRecord>(),
      _credentialBox = store.store.box<AuthCredentialRecord>();

  void saveUser(UserRecord user) {
    // Keep exactly one active user identity in local session storage.
    // This avoids stale users being returned by getUser() after account switches.
    _userBox.removeAll();
    _userBox.put(user);
  }

  UserRecord? getUser() {
    return _userBox
        .query()
        .order(UserRecord_.id, flags: Order.descending)
        .build()
        .findFirst();
  }

  void saveCredentials(String email, String password) {
    _credentialBox.removeAll();
    _credentialBox.put(AuthCredentialRecord(email: email, password: password));
  }

  AuthCredentialRecord? getSavedCredentials() {
    return _credentialBox.query().build().findFirst();
  }

  void clearCredentials() {
    _credentialBox.removeAll();
  }

  void clear() {
    _userBox.removeAll();
    _credentialBox.removeAll();
  }
}
