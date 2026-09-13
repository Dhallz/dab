import '../../entities/figma/figma_file_meta.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: Read-only Figma file metadata for last-edited heartbeats.
/// CONTRACT: Returns null when no token is configured or the request fails.
/// CONSTRAINTS: Never writes to Figma. Never logs tokens.
abstract interface class AbsIFigmaFileMetaPort {
  /// Fetches `GET /v1/files/:key/meta` for [fileKey].
  Future<FigmaFileMeta?> fetchFileMeta(String fileKey);
}
