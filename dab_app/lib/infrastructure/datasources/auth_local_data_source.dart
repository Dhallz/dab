import '../../objectbox.g.dart';
import '../core/local/objectbox_store.dart';
import '../core/local/records/auth_credential_record.dart';
import '../core/local/records/user_record.dart';

class AuthLocalDataSource {
  final Box<UserRecord> _userBox;
  final Box<AuthCredentialRecord> _credentialBox;

  AuthLocalDataSource(ObjectBoxStore store)
    : _userBox = store.store.box<UserRecord>(),
      _credentialBox = store.store.box<AuthCredentialRecord>();

  void saveUser(UserRecord user) {
    final existing = _userBox
        .query(UserRecord_.remoteId.equals(user.remoteId))
        .build()
        .findFirst();

    if (existing != null) {
      user.id = existing.id;
    }
    _userBox.put(user);
  }

  UserRecord? getUser() {
    return _userBox.query().build().findFirst();
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
