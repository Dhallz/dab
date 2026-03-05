import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_transaction_dto.mapper.dart';

@MappableClass()
class PhorgeTransactionDto with PhorgeTransactionDtoMappable {
  final int id;
  final String phid;
  final String objectPHID;
  final String authorPHID;
  final String type;
  final dynamic oldValue;
  final dynamic newValue;
  final String? commentText;
  final DateTime dateCreated;

  const PhorgeTransactionDto({
    required this.id,
    required this.phid,
    required this.objectPHID,
    required this.authorPHID,
    required this.type,
    this.oldValue,
    this.newValue,
    this.commentText,
    required this.dateCreated,
  });

  factory PhorgeTransactionDto.fromConduit(Map<String, dynamic> json) {
    return PhorgeTransactionDto(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      phid: json['phid']?.toString() ?? '',
      objectPHID: json['objectPHID']?.toString() ?? '',
      authorPHID: json['authorPHID']?.toString() ?? 'system',
      type: json['type']?.toString() ?? 'unknown',
      oldValue: json['oldValue'],
      newValue: json['newValue'],
      commentText: _extractComment(json),
      dateCreated: DateTime.fromMillisecondsSinceEpoch(
        (int.tryParse(json['dateCreated']?.toString() ?? '0') ?? 0) * 1000,
      ),
    );
  }

  static String? _extractComment(Map<String, dynamic> json) {
    if (json['type'] != 'comment') return null;
    final comments = json['comments'] as List<dynamic>?;
    if (comments == null || comments.isEmpty) return null;
    final firstComment = comments.first as Map<String, dynamic>?;
    if (firstComment == null) return null;
    final content = firstComment['content'] as Map<String, dynamic>?;
    if (content == null) return null;
    return content['raw']?.toString();
  }
}
