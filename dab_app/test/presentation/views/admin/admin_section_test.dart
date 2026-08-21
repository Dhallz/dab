import 'package:dab_app/presentation/views/admin/models/admin_section.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('individual Admin nav omits Identities and leads with Security', () {
    expect(adminSectionsFor(isIndividual: true), [
      AdminSection.security,
      AdminSection.providers,
    ]);
    expect(
      adminSectionsFor(isIndividual: true),
      isNot(contains(AdminSection.identities)),
    );
  });

  test('managed Admin nav keeps Providers, Identities, and Security', () {
    expect(adminSectionsFor(isIndividual: false), [
      AdminSection.providers,
      AdminSection.identities,
      AdminSection.security,
    ]);
  });
}
