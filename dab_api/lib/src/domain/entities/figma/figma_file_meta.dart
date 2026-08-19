/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Snapshot from Figma `GET /v1/files/:key/meta`.
/// CONTRACT: Optional fields are omitted when the token is missing or the
/// payload has no last-touched person. [folderName] comes from `folder_name`.
class FigmaFileMeta {
  final String fileKey;
  final String? name;
  final String? folderName;
  final String? lastTouchedById;
  final String? lastTouchedByHandle;
  final DateTime? lastTouchedAt;

  const FigmaFileMeta({
    required this.fileKey,
    this.name,
    this.folderName,
    this.lastTouchedById,
    this.lastTouchedByHandle,
    this.lastTouchedAt,
  });
}
