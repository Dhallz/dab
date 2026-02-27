import 'package:dart_mappable/dart_mappable.dart';

part 'user.mapper.dart';

@MappableClass()
class User with UserMappable {
  final String id;
  final String email;

  const User({required this.id, required this.email});
}

extension OnUser on User {
  // Add entity-specific getters or mappers here
}
