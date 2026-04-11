import 'package:dart_mappable/dart_mappable.dart';

part 'user_identity_status.mapper.dart';

@MappableEnum()
enum UserIdentityStatus { linked, pending, failed }
