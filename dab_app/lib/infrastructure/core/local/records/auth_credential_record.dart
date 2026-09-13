import 'package:objectbox/objectbox.dart';

@Entity()
class AuthCredentialRecord {
  @Id()
  int id = 0;
  final String email;
  final String password;

  AuthCredentialRecord({
    this.id = 0,
    required this.email,
    required this.password,
  });
}
