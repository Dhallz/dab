import 'package:dab_api/src/domain/entities/provider/provider_connectivity_report.dart';
import 'package:test/test.dart';

ProviderSectionResult _section(ConnectivitySectionStatus status) {
  return ProviderSectionResult(status: status, message: status.name);
}

void main() {
  group('ProviderConnectivityReport.computeAggregate', () {
    test('both live and polling success yields success', () {
      expect(
        ProviderConnectivityReport.computeAggregate(
          live: _section(ConnectivitySectionStatus.success),
          polling: _section(ConnectivitySectionStatus.success),
        ),
        ConnectivitySectionStatus.success,
      );
    });

    test('live ok and polling fail yields warning', () {
      expect(
        ProviderConnectivityReport.computeAggregate(
          live: _section(ConnectivitySectionStatus.success),
          polling: _section(ConnectivitySectionStatus.failure),
        ),
        ConnectivitySectionStatus.warning,
      );
    });

    test('live fail and polling ok yields warning', () {
      expect(
        ProviderConnectivityReport.computeAggregate(
          live: _section(ConnectivitySectionStatus.failure),
          polling: _section(ConnectivitySectionStatus.success),
        ),
        ConnectivitySectionStatus.warning,
      );
    });

    test('both fail yields failure', () {
      expect(
        ProviderConnectivityReport.computeAggregate(
          live: _section(ConnectivitySectionStatus.failure),
          polling: _section(ConnectivitySectionStatus.failure),
        ),
        ConnectivitySectionStatus.failure,
      );
    });
  });

  group('ProviderConnectivityReport.summarize', () {
    test('success summary mentions live and polling', () {
      final message = ProviderConnectivityReport.summarize(
        aggregate: ConnectivitySectionStatus.success,
        live: _section(ConnectivitySectionStatus.success),
        polling: _section(ConnectivitySectionStatus.success),
      );
      expect(message, contains('Live and polling'));
    });
  });
}
