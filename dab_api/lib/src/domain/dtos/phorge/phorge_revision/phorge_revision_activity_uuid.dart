import 'package:uuid/uuid.dart';

final _phorgeRevisionActivityUuidGenerator = const Uuid();

/// [ARCH: DOMAIN_DTO]
/// ROLE: Stable v5 IDs for synthetic [`Activity`] rows built from revision DTOs.
String phorgeRevisionActivityUuid(String source) => _phorgeRevisionActivityUuidGenerator
    .v5(Namespace.url.value, source);
