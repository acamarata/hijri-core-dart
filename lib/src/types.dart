/// A Hijri calendar date with year, month, and day.
class HijriDate {
  /// Hijri year.
  final int hy;

  /// Hijri month (1-12).
  final int hm;

  /// Hijri day (1-30).
  final int hd;

  const HijriDate({required this.hy, required this.hm, required this.hd});

  @override
  bool operator ==(Object other) =>
      other is HijriDate && hy == other.hy && hm == other.hm && hd == other.hd;

  @override
  int get hashCode => Object.hash(hy, hm, hd);

  @override
  String toString() => 'HijriDate(hy: $hy, hm: $hm, hd: $hd)';
}

/// A row in the Umm al-Qura reference table.
class HijriYearRecord {
  /// Hijri year.
  final int hy;

  /// Days-per-month bitmask. Bit i (0-indexed) corresponds to month i+1:
  /// 1 = 30 days, 0 = 29 days.
  final int dpm;

  /// Gregorian year of 1 Muharram.
  final int gy;

  /// Gregorian month of 1 Muharram (1-based).
  final int gm;

  /// Gregorian day of 1 Muharram.
  final int gd;

  const HijriYearRecord({
    required this.hy,
    required this.dpm,
    required this.gy,
    required this.gm,
    required this.gd,
  });
}

/// Any calendar engine must implement this interface.
abstract class CalendarEngine {
  /// Unique identifier for this engine (e.g. 'uaq', 'fcna').
  String get id;

  /// Convert a Gregorian [DateTime] (UTC) to a Hijri date.
  /// Returns null for out-of-range input.
  /// Throws [ArgumentError] for invalid input.
  HijriDate? toHijri(DateTime date);

  /// Convert a Hijri date to a Gregorian [DateTime] (UTC).
  /// Returns null for invalid or out-of-range input.
  DateTime? toGregorian(int hy, int hm, int hd);

  /// Check whether a Hijri date is valid for this engine.
  bool isValid(int hy, int hm, int hd);

  /// Return the number of days in a given Hijri month (29 or 30).
  /// Throws [RangeError] if the month or year is out of range.
  int daysInMonth(int hy, int hm);
}

/// Options for selecting which calendar engine to use.
class ConversionOptions {
  /// Calendar engine name. Defaults to 'uaq'.
  final String? calendar;

  const ConversionOptions({this.calendar});
}
