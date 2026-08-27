/// [ARCH: DOMAIN]
/// ROLE: Named screenshot Directory group used by [SeedDemoDay].
/// CONTRACT: [handle] seeds a stable id `demo-group|{handle}|{domain}`.
/// Members resolve from [kDemoTeamRoster] handles so Explorer and Insights
/// share the same groups.
class DemoGroupSpec {
  final String name;
  final String handle;
  final List<String> memberHandles;

  const DemoGroupSpec({
    required this.name,
    required this.handle,
    required this.memberHandles,
  });
}

/// Same custom groups on every Directory (Engineering / Product / Design / Leadership).
const kDemoTeamGroups = <DemoGroupSpec>[
  DemoGroupSpec(
    name: 'Engineering',
    handle: 'engineering',
    memberHandles: [
      'maya',
      'rio',
      'kenji',
      'sofia',
      'noah',
      'priya',
      'luca',
      'theo',
      'mateo',
      'yuki',
    ],
  ),
  DemoGroupSpec(
    name: 'Product',
    handle: 'product',
    memberHandles: ['maya', 'sofia', 'jonah', 'elise', 'claire'],
  ),
  DemoGroupSpec(
    name: 'Design',
    handle: 'design',
    memberHandles: ['hana', 'amina', 'grace', 'ingrid', 'ben'],
  ),
  DemoGroupSpec(
    name: 'Leadership',
    handle: 'leadership',
    memberHandles: ['maya', 'rio', 'omar', 'samir'],
  ),
];
