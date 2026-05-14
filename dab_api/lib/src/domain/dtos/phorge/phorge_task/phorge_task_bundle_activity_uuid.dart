import 'package:uuid/uuid.dart';

final _phorgeTaskBundleActivityUuid = const Uuid();

/// [ARCH: DOMAIN_DTO]
/// ROLE: Stable v5 IDs for synthetic [`Activity`] rows from Phorge task transactions.
String phorgeTaskBundleActivityUuid(String source) => _phorgeTaskBundleActivityUuid
    .v5(Namespace.url.value, source);
