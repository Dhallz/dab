extension OnDateTime on DateTime {
  /// [ARCH: DOMAIN_EXTENSION]
  /// ROLE: Phorge-oriented sprint marker (e.g. `DS2026-10`): `DS{year}-{ww}` from ISO-ish week logic.
  /// CONSTRAINTS: Depends only on **`this`** calendar instant; callers use `DateTime.now()` explicitly for “today”.
  String get phorgeSprintTag {
    final date = this;
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
