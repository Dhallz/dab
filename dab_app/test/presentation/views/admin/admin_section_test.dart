import 'package:dab_app/presentation/views/admin/models/admin_section.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('personal Admin nav omits Identities and leads with Security', () {
    expect(
      adminSectionsFor(isPersonal: true),
      [AdminSection.security, AdminSection.providers],
    );
    expect(
      adminSectionsFor(isPersonal: true),
      isNot(contains(AdminSection.identities)),
    );
  });

  test('organization Admin nav keeps Providers, Identities, and Security', () {
    expect(
      adminSectionsFor(isPersonal: false),
      [
        AdminSection.providers,
        AdminSection.identities,
        AdminSection.security,
      ],
    );
  });
}
