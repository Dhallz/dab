import '../entities/user/user_role.dart';

/// [ARCH: DOMAIN]
/// ROLE: Named screenshot teammate used by [SeedDemoDay] team mode.
/// CONTRACT: [handle] is the email local-part; ids are v5 of
/// `demo-user|{handle}|{domain}`.
class DemoTeammateSpec {
  final String name;
  final String handle;
  final UserRole role;

  const DemoTeammateSpec({
    required this.name,
    required this.handle,
    this.role = UserRole.standard,
  });
}

/// Ingest ids Directory tiles treat as connected for screenshot teammates.
const kDemoLinkedProviderIds = <String>[
  'github',
  'gitlab',
  'bitbucket',
  'jira',
  'linear',
  'phorge',
  'slack',
  'discord',
  'figma',
];

/// Twenty named people so Explorer / Insights look like a team, not one inbox.
const kDemoTeamRoster = <DemoTeammateSpec>[
  DemoTeammateSpec(name: 'Maya Chen', handle: 'maya', role: UserRole.manager),
  DemoTeammateSpec(name: 'Rio Patel', handle: 'rio'),
  DemoTeammateSpec(name: 'Kenji Mori', handle: 'kenji'),
  DemoTeammateSpec(name: 'Sofia Alvarez', handle: 'sofia'),
  DemoTeammateSpec(name: 'Noah Berg', handle: 'noah'),
  DemoTeammateSpec(name: 'Priya Shah', handle: 'priya'),
  DemoTeammateSpec(name: 'Luca Rossi', handle: 'luca'),
  DemoTeammateSpec(name: 'Amina Diallo', handle: 'amina'),
  DemoTeammateSpec(name: 'Jonah Reed', handle: 'jonah'),
  DemoTeammateSpec(name: 'Hana Kim', handle: 'hana'),
  DemoTeammateSpec(name: 'Omar Haddad', handle: 'omar'),
  DemoTeammateSpec(name: 'Elise Moreau', handle: 'elise'),
  DemoTeammateSpec(name: 'Theo Nguyen', handle: 'theo'),
  DemoTeammateSpec(name: 'Grace Okonkwo', handle: 'grace'),
  DemoTeammateSpec(name: 'Mateo Silva', handle: 'mateo'),
  DemoTeammateSpec(name: 'Yuki Tanaka', handle: 'yuki'),
  DemoTeammateSpec(name: 'Ingrid Holm', handle: 'ingrid'),
  DemoTeammateSpec(name: 'Samir Khan', handle: 'samir'),
  DemoTeammateSpec(name: 'Claire Dubois', handle: 'claire'),
  DemoTeammateSpec(name: 'Ben Ortiz', handle: 'ben'),
];
