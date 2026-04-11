import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'provider_connection_status.mapper.dart';

@MappableClass()
class ProviderConnectionStatus with ProviderConnectionStatusMappable {
  final ViewStatus status;
  final String? message;
  final DateTime? lastCheck;

  const ProviderConnectionStatus({
    this.status = ViewStatus.initial,
    this.message,
    this.lastCheck,
  });
}
