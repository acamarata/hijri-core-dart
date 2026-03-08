import 'engines/fcna.dart';
import 'engines/uaq.dart';
import 'registry.dart';
import 'types.dart';

// Register built-in engines at first access.
bool _registered = false;

void _ensureRegistered() {
  if (!_registered) {
    registerCalendar('uaq', uaqEngine);
    registerCalendar('fcna', fcnaEngine);
    _registered = true;
  }
}

/// Convert a Gregorian [DateTime] to a Hijri date.
///
/// Uses the UAQ (Umm al-Qura) calendar by default. Pass
/// `ConversionOptions(calendar: 'fcna')` or any registered calendar name
/// via [options] to use a different engine.
///
/// Returns null if the date is out of range for the selected engine.
HijriDate? toHijri(DateTime date, {ConversionOptions? options}) {
  _ensureRegistered();
  return getCalendar(options?.calendar ?? 'uaq').toHijri(date);
}

/// Convert a Hijri date to a Gregorian [DateTime] (UTC).
///
/// Uses the UAQ calendar by default.
///
/// Returns null if the input is invalid or out of range.
DateTime? toGregorian(int hy, int hm, int hd, {ConversionOptions? options}) {
  _ensureRegistered();
  return getCalendar(options?.calendar ?? 'uaq').toGregorian(hy, hm, hd);
}

/// Check whether a Hijri date is valid for the given calendar engine.
bool isValidHijriDate(int hy, int hm, int hd, {ConversionOptions? options}) {
  _ensureRegistered();
  return getCalendar(options?.calendar ?? 'uaq').isValid(hy, hm, hd);
}

/// Return the number of days in a given Hijri month (29 or 30).
///
/// Throws [RangeError] if the month or year is out of range.
int daysInHijriMonth(int hy, int hm, {ConversionOptions? options}) {
  _ensureRegistered();
  return getCalendar(options?.calendar ?? 'uaq').daysInMonth(hy, hm);
}
