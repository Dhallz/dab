/// [ARCH: PRESENTATION_MODEL]
/// ROLE: Internal model for provider configuration fields in the Admin view.
class AdminConfigField {
  final String key;
  final String label;
  final bool isSecret;

  AdminConfigField({required this.key, required this.label, this.isSecret = false});
}
