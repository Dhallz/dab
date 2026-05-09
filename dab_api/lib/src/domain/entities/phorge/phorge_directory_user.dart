/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Normalized Phorge directory row for application sync (no Conduit JSON).
/// CONTRACT: Built by infrastructure from wire types; consumed by [SyncPhorgeUsers].
class PhorgeDirectoryUser {
  final String phid;
  final String userName;
  final String? realName;

  const PhorgeDirectoryUser({
    required this.phid,
    required this.userName,
    this.realName,
  });
}
