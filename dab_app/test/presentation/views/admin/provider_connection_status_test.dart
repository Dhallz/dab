import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/views/admin/models/provider_connection_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('keeps a successful org test unchanged', () {
    const tested = ProviderConnectionStatus(
      status: ViewStatus.success,
      message: 'ok',
    );

    final merged = tested.preferringConnectedCredential('alice');

    expect(merged.status, ViewStatus.success);
    expect(merged.message, 'ok');
  });

  test('overlays failed and warned org tests with a connected credential', () {
    const failed = ProviderConnectionStatus(
      status: ViewStatus.failure,
      message: 'Live webhook missing',
    );
    const warned = ProviderConnectionStatus(
      status: ViewStatus.warning,
      message: 'unsigned',
    );

    expect(
      failed.preferringConnectedCredential('alice').status,
      ViewStatus.success,
    );
    expect(failed.preferringConnectedCredential('alice').message, 'alice');
    expect(
      warned.preferringConnectedCredential('alice').status,
      ViewStatus.success,
    );
  });

  test('leaves a failed org test red when no credential exists', () {
    const failed = ProviderConnectionStatus(
      status: ViewStatus.failure,
      message: 'Live webhook missing',
    );

    final merged = failed.preferringConnectedCredential(null);

    expect(merged.status, ViewStatus.failure);
    expect(merged.message, 'Live webhook missing');
  });
}
