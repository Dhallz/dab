/// [ARCH: DOMAIN_SERVICE]
/// ROLE: Encapsulates pure business logic for Phorge-specific organization.
/// CONTRACT: Provides deterministic calculation of sprint identifiers.
/// CONSTRAINTS: Must remain side-effect free (pure function of time).
/// 
/// This service is placed in the Domain layer because the concept of a 
/// "Sprint Tag" is a business rule shared across Mappers and UI, 
/// independent of any specific API or database implementation.
class PhorgeSprintService {
  /// Calculates the current Phorge sprint tag (e.g. "DS2026-10").
  /// 
  /// Logic: uses ISO-8601 week numbers prefixed with 'DS' and the year.
  /// Handles year-boundary edge cases where the first week of a year 
  /// might belong to the previous year's numbering.
  String getCurrentSprintTag([DateTime? now]) {
    final date = now ?? DateTime.now();
    int dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays + 1;
    int woy = ((dayOfYear - date.weekday + 10) / 7).floor();

    int isoWeekNumber(DateTime d) {
      int doy = d.difference(DateTime(d.year, 1, 1)).inDays + 1;
      int w = ((doy - d.weekday + 10) / 7).floor();
      return w;
    }

    if (woy < 1) {
      woy = isoWeekNumber(DateTime(date.year - 1, 12, 31));
    } else if (woy > 52) {
      int lastDayOfYear = DateTime(date.year, 12, 31).weekday;
      if (lastDayOfYear < DateTime.thursday) {
        woy = 1;
      }
    }

    int year = date.year;
    if (date.month == 1 && woy > 50) year--;
    if (date.month == 12 && woy == 1) year++;

    return 'DS$year-${woy.toString().padLeft(2, '0')}';
  }
}
