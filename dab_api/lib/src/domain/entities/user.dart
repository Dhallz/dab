import 'package:dart_mappable/dart_mappable.dart';

part 'user.mapper.dart';

@MappableClass()
class User with UserMappable {
  final String id;
  final String name;
  final String email;
  final String passwordHash;
  final String role; // 'Admin' or 'Standard'
  final String? phorgePhid;
  final String? phorgeUsername;
  final DateTime createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    this.role = 'Standard',
    this.phorgePhid,
    this.phorgeUsername,
    required this.createdAt,
    this.updatedAt,
  });
}
