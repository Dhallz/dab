import '../../objectbox.g.dart';
import '../core/local/objectbox_store.dart';
import '../core/local/records/user_record.dart';

class AuthLocalDataSource {
  final Box<UserRecord> _box;

  AuthLocalDataSource(ObjectBoxStore store)
    : _box = store.store.box<UserRecord>();

  void saveUser(UserRecord user) {
    _box.put(user, mode: PutMode.put);
  }

  UserRecord? getUser() {
    return _box.query().build().findFirst();
  }

  void clear() {
    _box.removeAll();
  }
}
