import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/domain/entities/user/user_identity.dart';
import 'package:dab_app/domain/entities/user/user_identity_status.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/views/admin/admin_state.dart';
import 'package:dab_app/presentation/views/admin/models/provider_connection_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('islandBarModel counts active providers and connection health', () {
    const configs = [
      ProviderConfig(
        id: 'a',
        name: 'A',
        baseUrl: 'https://a',
        isActive: true,
        iconUrl: '',
      ),
      ProviderConfig(
        id: 'b',
        name: 'B',
        baseUrl: 'https://b',
        isActive: false,
        iconUrl: '',
      ),
    ];
    final state = AdminState(
      configs: configs,
      connectionStatuses: {
        'a': const ProviderConnectionStatus(status: ViewStatus.success),
      },
    );

    final m = state.islandBarModel;
    expect(m.activeProviders, 1);
    expect(m.totalProviders, 2);
    expect(m.connectionOk, 1);
    expect(m.connectionFailed, 0);
    expect(m.connectionUnknown, 0);
  });

  test('islandBarModel counts unresolved identities', () {
    final identities = [
      UserIdentity(
        id: '1',
        userId: 'u',
        providerId: 'p',
        externalId: 'e',
        status: UserIdentityStatus.pending,
        createdAt: DateTime(2026),
      ),
      UserIdentity(
        id: '2',
        userId: 'u2',
        providerId: 'p',
        externalId: 'e2',
        status: UserIdentityStatus.linked,
        createdAt: DateTime(2026),
      ),
    ];
    final state = AdminState(identities: identities);
    expect(state.islandBarModel.unresolvedIdentities, 1);
  });
}
