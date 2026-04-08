import 'package:dab_app/domain/entities/user.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class UserRecord {
  @Id()
  int id = 0;

  @Unique()
  final String remoteId;
  final String email;
  final String? name;
  final String role;

  UserRecord({
    required this.remoteId,
    required this.email,
    required this.role,
    this.name,
  });
}

extension OnUserRecord on UserRecord {
  User get toDomain =>
      User(id: remoteId, name: name ?? 'Unknown', email: email, role: role);
}
