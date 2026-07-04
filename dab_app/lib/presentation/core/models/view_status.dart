import 'package:dart_mappable/dart_mappable.dart';

part 'view_status.mapper.dart';

/// [ARCH: PRESENTATION_MODEL]
/// ROLE: Generic status for views and asynchronous operations.
/// CONTRACT: Immutable enum serializable via [ViewStatusMappable].
@MappableEnum()
enum ViewStatus {
  initial,
  loading,
  success,
  warning,
  failure;

  bool get isInitial => this == ViewStatus.initial;
  bool get isLoading => this == ViewStatus.loading;
  bool get isSuccess => this == ViewStatus.success;
  bool get isWarning => this == ViewStatus.warning;
  bool get isFailure => this == ViewStatus.failure;
}
