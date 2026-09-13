import 'package:dart_mappable/dart_mappable.dart';

part 'user_role.mapper.dart';

@MappableEnum()
enum UserRole { admin, manager, standard }
