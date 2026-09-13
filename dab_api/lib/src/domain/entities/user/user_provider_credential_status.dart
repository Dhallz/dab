import 'package:dart_mappable/dart_mappable.dart';

part 'user_provider_credential_status.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Lifecycle of a per-user provider credential.
@MappableEnum()
enum UserProviderCredentialStatus { connected, failed }
