// FCNA engine: Fiqh Council of North America / ISNA calendar.
//
// The FCNA criterion: if the new moon conjunction occurs before 12:00 noon UTC
// on day D, the new Hijri month begins at midnight starting day D+1. If at or
// after 12:00 UTC, the month begins at midnight starting day D+2.
//
// New moon times come from Jean Meeus, Astronomical Algorithms (2nd ed.),
// Chapter 49, accurate to within a few minutes for 1000-3000 CE.

import 'dart:math' as math;

import '../constants.dart';
import '../data.dart';
import '../types.dart';

// ---- Constants ----

const double _synodic = 29.530588861; // Mean synodic month (days)
const double _jde0 =
    2451550.09766; // Meeus k=0 (2nd ed. Ch.49: 2451550.09765; 0.864 s diff)
const double _jdeUnix = 2440587.5; // JDE of Unix epoch 1970-01-01 00:00 UTC
const double _toRad = math.pi / 180;

// Approximate k index of 1 Muharram 1 AH in Meeus numbering.
// Islamic epoch JDE ~1948438.5 -> k ~= (1948438.5 - _jde0) / _synodic ~= -17037.
const int _kEpoch = -17037;

// ---- Meeus Chapter 49: corrected new moon JDE ----

double _newMoonJDE(double k) {
  final t = k / 1236.85;
  final t2 = t * t;
  final t3 = t2 * t;
  final t4 = t3 * t;

  double jde =
      _jde0 +
      _synodic * k +
      0.00015437 * t2 -
      0.00000015 * t3 +
      0.00000000073 * t4;

  final m = (2.5534 + 29.1053567 * k - 0.0000014 * t2 - 0.00000011 * t3) % 360;

  final mprime =
      (201.5643 +
          385.81693528 * k +
          0.0107582 * t2 +
          0.00001238 * t3 -
          0.000000058 * t4) %
      360;

  final f =
      (160.7108 +
          390.67050284 * k -
          0.0016118 * t2 -
          0.00000227 * t3 +
          0.000000011 * t4) %
      360;

  final omega =
      (124.7746 - 1.56375588 * k + 0.0020672 * t2 + 0.00000215 * t3) % 360;

  final e = 1 - 0.002516 * t - 0.0000074 * t2;
  final e2 = e * e;

  final mRad = m * _toRad;
  final mpRad = mprime * _toRad;
  final fRad = f * _toRad;
  final oRad = omega * _toRad;

  jde +=
      -0.4072 * math.sin(mpRad) +
      0.17241 * e * math.sin(mRad) +
      0.01608 * math.sin(2 * mpRad) +
      0.01039 * math.sin(2 * fRad) +
      0.00739 * e * math.sin(mpRad - mRad) -
      0.00514 * e * math.sin(mpRad + mRad) +
      0.00208 * e2 * math.sin(2 * mRad) -
      0.00111 * math.sin(mpRad - 2 * fRad) -
      0.00057 * math.sin(mpRad + 2 * fRad) +
      0.00056 * e * math.sin(2 * mpRad + mRad) -
      0.00042 * math.sin(3 * mpRad) +
      0.00042 * e * math.sin(mRad + 2 * fRad) +
      0.00038 * e * math.sin(mRad - 2 * fRad) -
      0.00024 * e * math.sin(2 * mpRad - mRad) -
      0.00017 * math.sin(oRad) -
      0.00007 * math.sin(mpRad + 2 * mRad) +
      0.00004 * math.sin(2 * mpRad - 2 * fRad) +
      0.00004 * math.sin(3 * mRad) +
      0.00003 * math.sin(mpRad + mRad - 2 * fRad) +
      0.00003 * math.sin(2 * mpRad + 2 * fRad) -
      0.00003 * math.sin(mpRad + mRad + 2 * fRad) +
      0.00003 * math.sin(mpRad - mRad + 2 * fRad) -
      0.00002 * math.sin(mpRad - mRad - 2 * fRad) -
      0.00002 * math.sin(3 * mpRad + mRad) +
      0.00002 * math.sin(4 * mpRad);

  final a1 = (299.77 + 0.107408 * k - 0.009173 * t2) * _toRad;
  final a2 = (251.88 + 0.016321 * k) * _toRad;
  final a3 = (251.83 + 26.651886 * k) * _toRad;
  final a4 = (349.42 + 36.412478 * k) * _toRad;
  final a5 = (84.66 + 18.206239 * k) * _toRad;
  final a6 = (141.74 + 53.303771 * k) * _toRad;
  final a7 = (207.14 + 2.453732 * k) * _toRad;
  final a8 = (154.84 + 7.30686 * k) * _toRad;
  final a9 = (34.52 + 27.261239 * k) * _toRad;
  final a10 = (207.19 + 0.121824 * k) * _toRad;
  final a11 = (291.34 + 1.844379 * k) * _toRad;
  final a12 = (161.72 + 24.198154 * k) * _toRad;
  final a13 = (239.56 + 25.513099 * k) * _toRad;
  final a14 = (331.55 + 3.592518 * k) * _toRad;

  jde +=
      0.000325 * math.sin(a1) +
      0.000165 * math.sin(a2) +
      0.000164 * math.sin(a3) +
      0.000126 * math.sin(a4) +
      0.00011 * math.sin(a5) +
      0.000062 * math.sin(a6) +
      0.00006 * math.sin(a7) +
      0.000056 * math.sin(a8) +
      0.000047 * math.sin(a9) +
      0.000042 * math.sin(a10) +
      0.00004 * math.sin(a11) +
      0.000037 * math.sin(a12) +
      0.000035 * math.sin(a13) +
      0.000023 * math.sin(a14);

  return jde;
}

// ---- JDE / UTC conversion ----

double _jdeToUtcMs(double jde) {
  return (jde - _jdeUnix) * msPerDay;
}

double _utcMsToKApprox(double ms) {
  final jde = ms / msPerDay + _jdeUnix;
  return (jde - _jde0) / _synodic;
}

// ---- Find nearest corrected new moon ----

// Searches k0-2 through k0+2 to handle any estimation error.
double _nearestNewMoonMs(double anchorMs) {
  final k0 = _utcMsToKApprox(anchorMs).round();
  double bestMs = 0;
  double bestDist = double.infinity;

  for (int k = k0 - 2; k <= k0 + 2; k++) {
    final ms = _jdeToUtcMs(_newMoonJDE(k.toDouble()));
    final dist = (ms - anchorMs).abs();
    if (dist < bestDist) {
      bestDist = dist;
      bestMs = ms;
    }
  }

  return bestMs;
}

// ---- FCNA criterion ----

// Returns the midnight UTC ms that starts the new FCNA Hijri month.
double _fcnaCriterionMs(double conjMs) {
  final midnight = (conjMs / msPerDay).floor() * msPerDay;
  final noon = midnight + 12 * 3600000;
  return (conjMs < noon ? midnight + msPerDay : midnight + 2 * msPerDay)
      .toDouble();
}

// ---- UAQ anchor ----

// Returns the UTC ms of the UAQ month start for (hy, hm).
// In-range years (1318-1500 H): binary-search table, sum dpm day counts.
// Out-of-range years: estimate from Islamic epoch + mean synodic month count.
double _uaqAnchorMs(int hy, int hm) {
  int lo = 0;
  int hi = hDatesTable.length - 1;
  int found = -1;

  while (lo <= hi) {
    final mid = (lo + hi) >>> 1;
    final midHy = hDatesTable[mid].hy;
    if (midHy == hy) {
      found = mid;
      break;
    } else if (midHy < hy) {
      lo = mid + 1;
    } else {
      hi = mid - 1;
    }
  }

  if (found != -1 && hDatesTable[found].dpm != 0) {
    final r = hDatesTable[found];
    int days = 0;
    for (int i = 0; i < hm - 1; i++) {
      days += (r.dpm >> i) & 1 == 1 ? 30 : 29;
    }
    return (DateTime.utc(r.gy, r.gm, r.gd).millisecondsSinceEpoch +
            days * msPerDay)
        .toDouble();
  }

  final monthsFromEpoch = (hy - 1) * monthsPerYear + (hm - 1);
  final kApprox = _kEpoch + monthsFromEpoch;
  return _jdeToUtcMs(_newMoonJDE(kApprox.toDouble()));
}

// ---- FCNA month start ----

double _fcnaMonthStartMs(int hy, int hm) {
  final anchor = _uaqAnchorMs(hy, hm);
  final conjMs = _nearestNewMoonMs(anchor);
  return _fcnaCriterionMs(conjMs);
}

// ---- FCNA month length ----

int _fcnaDaysInMonth(int hy, int hm) {
  if (hm < 1 || hm > monthsPerYear) {
    throw RangeError('month must be 1-12, got $hm');
  }
  final thisStart = _fcnaMonthStartMs(hy, hm);
  final nextHy = hm < monthsPerYear ? hy : hy + 1;
  final nextHm = hm < monthsPerYear ? hm + 1 : 1;
  final nextStart = _fcnaMonthStartMs(nextHy, nextHm);
  return ((nextStart - thisStart) / msPerDay).round();
}

// ---- FCNA Gregorian -> Hijri ----

HijriDate? _fcnaToHijri(DateTime date) {
  // FCNA criterion is UTC-based, so UTC date components ensure correct round-trips.
  final inputMs =
      DateTime.utc(
        date.year,
        date.month,
        date.day,
      ).millisecondsSinceEpoch.toDouble();

  final kApprox = _utcMsToKApprox(inputMs - 15 * msPerDay);
  final k0 = kApprox.floor();

  for (int ki = k0 - 1; ki <= k0 + 1; ki++) {
    final conjMs = _jdeToUtcMs(_newMoonJDE(ki.toDouble()));
    final monthStart = _fcnaCriterionMs(conjMs);

    if (monthStart > inputMs) continue;

    final nextConjMs = _jdeToUtcMs(_newMoonJDE((ki + 1).toDouble()));
    final nextMonthStart = _fcnaCriterionMs(nextConjMs);

    if (inputMs < nextMonthStart) {
      final monthsFromEpoch = ki - _kEpoch;
      int hy = monthsFromEpoch ~/ monthsPerYear + 1;
      int hm = (monthsFromEpoch % monthsPerYear) + 1;
      if (hm <= 0) {
        hm += monthsPerYear;
        hy--;
      }
      if (hy < 1) return null;

      final hd = ((inputMs - monthStart) / msPerDay).round() + 1;
      return HijriDate(hy: hy, hm: hm, hd: hd);
    }
  }

  return null;
}

// ---- FCNA Hijri -> Gregorian ----

DateTime? _fcnaToGregorian(int hy, int hm, int hd) {
  if (hy < 1 || hm < 1 || hm > monthsPerYear || hd < 1) return null;
  final days = _fcnaDaysInMonth(hy, hm);
  if (hd > days) return null;
  final startMs = _fcnaMonthStartMs(hy, hm);
  return DateTime.fromMillisecondsSinceEpoch(
    (startMs + (hd - 1) * msPerDay).round(),
    isUtc: true,
  );
}

// ---- FCNA validation ----

bool _fcnaIsValid(int hy, int hm, int hd) {
  if (hy < 1 || hm < 1 || hm > monthsPerYear || hd < 1) return false;
  return hd <= _fcnaDaysInMonth(hy, hm);
}

/// The FCNA (Fiqh Council of North America) calendar engine.
final CalendarEngine fcnaEngine = _FcnaEngine();

class _FcnaEngine extends CalendarEngine {
  @override
  String get id => 'fcna';

  @override
  HijriDate? toHijri(DateTime date) => _fcnaToHijri(date);

  @override
  DateTime? toGregorian(int hy, int hm, int hd) => _fcnaToGregorian(hy, hm, hd);

  @override
  bool isValid(int hy, int hm, int hd) => _fcnaIsValid(hy, hm, hd);

  @override
  int daysInMonth(int hy, int hm) => _fcnaDaysInMonth(hy, hm);
}
