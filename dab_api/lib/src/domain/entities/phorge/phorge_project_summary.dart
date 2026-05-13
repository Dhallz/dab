/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Phorge project/tag row surfaced from Conduit after sprint-scoped enrichment.
/// CONTRACT: Mirrors `project.search` display fields relevant to UI filters and metadata.
class PhorgeProjectSummary {
  final int id;
  final String phid;
  final String name;
  final String? color;
  final String? icon;

  const PhorgeProjectSummary({
    required this.id,
    required this.phid,
    required this.name,
    this.color,
    this.icon,
  });
}
