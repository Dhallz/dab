import 'package:dart_mappable/dart_mappable.dart';

part 'admin_section.mapper.dart';

@MappableEnum()
enum AdminSection { providers, identities, security }

extension OnAdminSection on AdminSection {
  String get title => switch (this) {
    AdminSection.providers => 'Provider Config',
    AdminSection.identities => 'Identity Management',
    AdminSection.security => 'System Security',
  };

  String get subtitle => switch (this) {
    AdminSection.providers => 'Define and manage external service connections.',
    AdminSection.identities => 'Resolve and link platform identities to users.',
    AdminSection.security => 'Manage user roles and deployment security.',
  };
}
