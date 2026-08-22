import 'registry.dart';
import 'types.dart';

/// Convert a Gregorian [DateTime] to a Hijri date.
///
/// Uses the UAQ (Umm al-Qura) calendar by default. Pass
/// `ConversionOptions(calendar: 'fcna')` or any registered calendar name
/// via [options] to use a different engine.
///
/// Returns null if the date is out of range for the selected engine.
HijriDate? toHijri(DateTime date, {ConversionOptions? options}) {
  return getCalendar(options?.calendar ?? 'uaq').toHijri(date);
}

/// Convert a Hijri date to a Gregorian [DateTime] (UTC).
///
/// Uses the UAQ calendar by default.
///
/// Returns null if the input is invalid or out of range.
DateTime? toGregorian(int hy, int hm, int hd, {ConversionOptions? options}) {
  return getCalendar(options?.calendar ?? 'uaq').toGregorian(hy, hm, hd);
}

/// Check whether a Hijri date is valid for the given calendar engine.
bool isValidHijriDate(int hy, int hm, int hd, {ConversionOptions? options}) {
  return getCalendar(options?.calendar ?? 'uaq').isValid(hy, hm, hd);
}

/// Return the number of days in a given Hijri month (29 or 30).
///
/// Throws [RangeError] if the month or year is out of range.
int daysInHijriMonth(int hy, int hm, {ConversionOptions? options}) {
  return getCalendar(options?.calendar ?? 'uaq').daysInMonth(hy, hm);
}
