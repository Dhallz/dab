import 'package:dart_mappable/dart_mappable.dart';

part 'phorge_transaction_data.mapper.dart';

/// [ARCH: INFRASTRUCTURE_DTO]
/// ROLE: Raw technical representation of a Phorge Transaction (Event).
/// CONTRACT: Corresponds to a `transaction.search` entry in the Phorge API.
/// CONSTRAINTS: Must be serializable (Mappable). Used for status change and comment mapping.
@MappableClass()
class PhorgeTransactionData with PhorgeTransactionDataMappable {
  /// The numeric transaction ID.
  final int id;
  
  /// The Phorge PHID (Global UID) for this transaction.
  final String phid;
  
  /// The PHID of the object this transaction belongs to (e.g., Task PHID).
  final String objectPHID;
  
  /// The PHID of the user who performed this action.
  final String authorPHID;
  
  /// The internal Phorge type code (e.g., 'comment', 'status', 'core:columns').
  final String type;
  
  /// The previous state before this transaction.
  final dynamic oldValue;
  
  /// The new state after this transaction.
  final dynamic newValue;
  
  /// The textual content if this was a comment-type transaction.
  final String? commentText;
  
  /// When this event occurred in Phorge.
  final DateTime dateCreated;

  const PhorgeTransactionData({
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
}
