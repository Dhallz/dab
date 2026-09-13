/// [ARCH: PRESENTATION_MODEL]
/// ROLE: Flattened row used by the Insights details table.
class InsightsDetailRow {
  final InsightsDetailRowKind kind;
  final String label;
  final int count;
  final String share;

  const InsightsDetailRow({
    required this.kind,
    required this.label,
    required this.count,
    required this.share,
  });
}

enum InsightsDetailRowKind { provider, activityType, user }
