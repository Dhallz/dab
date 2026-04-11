import 'package:dab_app/domain/entities/user/user.dart';
import 'package:dab_app/domain/entities/user/user_role.dart';
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
  User get toDomain => User(
        id: remoteId,
        name: name ?? 'Unknown',
        email: email,
        role: UserRole.values.firstWhere(
          (e) => e.name == role,
          orElse: () => UserRole.standard,
        ),
      );
}
