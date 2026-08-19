/// [ARCH: DOMAIN]
/// ROLE: Figma REST helpers: allow-lists, file URLs, and auth headers.
/// CONTRACT: Empty [fileKeys] / [teamIds] means no webhook filter (same idea
/// as empty Jira `projectKeys`). Explorer poll still needs explicit file keys,
/// file URLs, or Follow pins — Connect OAuth cannot list a team. Never logs
/// tokens.
library;

/// Figma REST origin.
const kFigmaApiBase = 'https://api.figma.com';

final _figmaFileKeyPattern = RegExp(r'^[A-Za-z0-9_-]{8,128}$');
final _figmaTeamIdPattern = RegExp(r'^[0-9]{5,32}$');
final _figmaFileUrlKeyPattern = RegExp(
  r'(?:figma\.com)/(?:design|file|board|proto|figjam|slides)/([A-Za-z0-9_-]{8,128})',
  caseSensitive: false,
);

/// File key from a bare key or a Figma file URL (`/design/KEY/`, `/file/KEY/`).
String? extractFigmaFileKey(String raw) {
  final text = raw.trim();
  if (text.isEmpty) return null;
  if (_figmaFileKeyPattern.hasMatch(text)) return text;
  final match = _figmaFileUrlKeyPattern.firstMatch(text);
  final key = match?.group(1)?.trim() ?? '';
  if (key.isEmpty) return null;
  return key;
}

/// Parses Admin `fileKeys` (newline or comma separated keys or file URLs).
List<String> parseFigmaFileKeys(dynamic raw) {
  final seen = <String>{};
  final out = <String>[];
  for (final part in _delimitedParts(raw)) {
    final key = extractFigmaFileKey(part);
    if (key == null || !seen.add(key)) continue;
    out.add(key);
  }
  return out;
}

/// Parses Admin `teamIds` (newline or comma separated).
List<String> parseFigmaTeamIds(dynamic raw) =>
    _parseDelimited(raw, _figmaTeamIdPattern);

List<String> _delimitedParts(dynamic raw) {
  if (raw is List) {
    return [
      for (final item in raw)
        if (item.toString().trim().isNotEmpty) item.toString().trim(),
    ];
  }
  final text = (raw ?? '').toString();
  if (text.trim().isEmpty) return const [];
  return [
    for (final part in text.split(RegExp(r'[\n,]+')))
      if (part.trim().isNotEmpty) part.trim(),
  ];
}

List<String> _parseDelimited(dynamic raw, RegExp allowed) {
  return [
    for (final part in _delimitedParts(raw))
      if (allowed.hasMatch(part)) part,
  ];
}

/// True when [fileKey] is allowed. Empty [allowList] means no file filter.
bool figmaFileKeyAllowed(String fileKey, List<String> allowList) {
  if (allowList.isEmpty) return true;
  return allowList.contains(fileKey.trim());
}

/// True when [teamId] is allowed. Empty [allowList] means no team filter.
/// Missing [teamId] cannot be filtered and is allowed.
bool figmaTeamIdAllowed(String? teamId, List<String> allowList) {
  if (allowList.isEmpty) return true;
  final id = (teamId ?? '').trim();
  if (id.isEmpty) return true;
  return allowList.contains(id);
}

/// Public Figma file URL used on live cards.
String figmaFileUrl(String fileKey) =>
    'https://www.figma.com/file/${fileKey.trim()}';

/// Fields from `GET /v1/files/:key/meta`. Figma often wraps them in `file`.
Map<String, dynamic> figmaFileMetaFields(Map<String, dynamic> body) {
  final nested = body['file'];
  if (nested is! Map) return Map<String, dynamic>.from(body);
  return {
    ...body,
    ...Map<String, dynamic>.from(nested),
  };
}

/// Explorer / inbox title: `[folder_name] name`, else the file name, else the key.
String figmaFileTitle({
  String? name,
  String? folderName,
  String? fileKey,
}) {
  final file = (name ?? '').trim();
  final folder = (folderName ?? '').trim();
  if (folder.isNotEmpty && file.isNotEmpty) return '[$folder] $file';
  if (file.isNotEmpty) return file;
  if (folder.isNotEmpty) return '[$folder]';
  return (fileKey ?? '').trim();
}

/// True when [text] is a Figma user id (long numeric), not a handle.
bool looksLikeFigmaUserId(String text) =>
    RegExp(r'^[0-9]{8,}$').hasMatch(text.trim());

/// Handle / display name from Figma user fields. Skips empty values and
/// numeric ids so activity cards never show `948500924847399940` as sender.
String figmaAuthorLabel({
  String? handle,
  String? name,
  String? username,
  String? authorId,
}) {
  final id = (authorId ?? '').trim();
  for (final candidate in [handle, name, username]) {
    final text = (candidate ?? '').trim();
    if (text.isEmpty) continue;
    if (id.isNotEmpty && text == id) continue;
    if (looksLikeFigmaUserId(text)) continue;
    return text;
  }
  return '';
}

/// [figmaAuthorLabel] from a comments `user` object (map or omitted).
String figmaAuthorLabelFromUser(dynamic user, {String? authorId}) {
  if (user is! Map) return '';
  final map = Map<String, dynamic>.from(user);
  return figmaAuthorLabel(
    handle: (map['handle'] ?? '').toString(),
    name: (map['name'] ?? '').toString(),
    username: (map['username'] ?? '').toString(),
    authorId: authorId ?? (map['id'] ?? '').toString(),
  );
}

/// Headers for Figma REST.
///
/// Send **one** scheme: PAT (`figd_…`) uses `X-Figma-Token`; OAuth uses
/// `Authorization: Bearer`. Sending both makes comments return 401
/// `Missing credentials` because Figma treats a non-PAT `X-Figma-Token` as
/// empty while `/meta` may still accept the Bearer header.
Map<String, String> figmaAuthHeaders(String token) {
  final trimmed = token.trim();
  final headers = <String, String>{'Accept': 'application/json'};
  if (trimmed.isEmpty) return headers;
  if (trimmed.startsWith('figd_')) {
    headers['X-Figma-Token'] = trimmed;
  } else {
    headers['Authorization'] = 'Bearer $trimmed';
  }
  return headers;
}
