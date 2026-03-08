// UAQ engine: Umm al-Qura calendar (official Saudi Arabian Islamic calendar).
//
// Conversions are table-driven. The reference table covers Hijri years 1318-1500
// (Gregorian 1900-2076). Each entry records the Gregorian date of 1 Muharram and
// a 12-bit days-per-month bitmask. Dates outside that window return null.

import '../constants.dart';
import '../data.dart';
import '../types.dart';

/// Binary search for a Hijri year entry in the UAQ table.
///
/// Returns the entry whose [hy] matches exactly, or null if the year is not
/// present in the table. The table covers Hijri years 1318 through 1501
/// (the final entry is a sentinel with dpm == 0).
HijriYearRecord? _findYearEntry(int hy) {
  int lo = 0;
  int hi = hDatesTable.length - 1;

  while (lo <= hi) {
    final mid = (lo + hi) >>> 1;
    final midHy = hDatesTable[mid].hy;
    if (midHy == hy) return hDatesTable[mid];
    if (midHy < hy) {
      lo = mid + 1;
    } else {
      hi = mid - 1;
    }
  }
  return null;
}

/// Compute UTC milliseconds since epoch for a Gregorian date.
int _dateUtcMs(int year, int month, int day) {
  return DateTime.utc(year, month, day).millisecondsSinceEpoch;
}

HijriDate? _uaqToHijri(DateTime date) {
  final inputUtc = _dateUtcMs(date.year, date.month, date.day);

  // Binary search: find the last table entry whose Gregorian start date <= input.
  int lo = 0;
  int hi = hDatesTable.length - 1;
  int found = -1;

  while (lo <= hi) {
    final mid = (lo + hi) >>> 1;
    final entry = hDatesTable[mid];
    final entryUtc = _dateUtcMs(entry.gy, entry.gm, entry.gd);

    if (entryUtc <= inputUtc) {
      found = mid;
      lo = mid + 1;
    } else {
      hi = mid - 1;
    }
  }

  // dpm == 0 is the sentinel entry (hy 1501) marking the upper bound.
  if (found == -1 || hDatesTable[found].dpm == 0) return null;

  final record = hDatesTable[found];
  final startUtc = _dateUtcMs(record.gy, record.gm, record.gd);
  int remaining = ((inputUtc - startUtc) / msPerDay).round();
  int hijriMonth = 0;

  for (int i = 0; i < monthsPerYear; i++) {
    final dim = (record.dpm >> i) & 1 == 1 ? 30 : 29;
    if (remaining < dim) {
      hijriMonth = i + 1;
      break;
    }
    remaining -= dim;
  }

  if (hijriMonth == 0) return null;

  return HijriDate(hy: record.hy, hm: hijriMonth, hd: remaining + 1);
}

DateTime? _uaqToGregorian(int hy, int hm, int hd) {
  if (!_uaqIsValid(hy, hm, hd)) return null;

  final record = _findYearEntry(hy);
  if (record == null) return null;

  int totalDays = 0;
  for (int i = 0; i < hm - 1; i++) {
    totalDays += (record.dpm >> i) & 1 == 1 ? 30 : 29;
  }
  totalDays += hd - 1;

  return DateTime.fromMillisecondsSinceEpoch(
    _dateUtcMs(record.gy, record.gm, record.gd) + totalDays * msPerDay,
    isUtc: true,
  );
}

bool _uaqIsValid(int hy, int hm, int hd) {
  if (hm < 1 || hm > monthsPerYear || hd < 1) return false;

  final record = _findYearEntry(hy);
  if (record == null || record.dpm == 0) return false;

  final dim = (record.dpm >> (hm - 1)) & 1 == 1 ? 30 : 29;
  return hd <= dim;
}

int _uaqDaysInMonth(int hy, int hm) {
  if (hm < 1 || hm > monthsPerYear) {
    throw RangeError('month must be 1-12, got $hm');
  }

  final record = _findYearEntry(hy);
  if (record == null || record.dpm == 0) {
    throw RangeError(
      'Hijri year $hy is outside the UAQ table range (1318-1500).',
    );
  }
  return (record.dpm >> (hm - 1)) & 1 == 1 ? 30 : 29;
}

/// The Umm al-Qura calendar engine.
final CalendarEngine uaqEngine = _UaqEngine();

class _UaqEngine extends CalendarEngine {
  @override
  String get id => 'uaq';

  @override
  HijriDate? toHijri(DateTime date) => _uaqToHijri(date);

  @override
  DateTime? toGregorian(int hy, int hm, int hd) => _uaqToGregorian(hy, hm, hd);

  @override
  bool isValid(int hy, int hm, int hd) => _uaqIsValid(hy, hm, hd);

  @override
  int daysInMonth(int hy, int hm) => _uaqDaysInMonth(hy, hm);
}
