/// Cross-language parity against the JavaScript `hijri-core` package.
///
/// Both ports carry the same tabular calendar data and the same arithmetic over it, so they
/// must agree exactly — a calendar conversion is integer-valued, and there is no rounding for
/// a tolerance to absorb. Any disagreement is a transcription error in the table or an
/// off-by-one in the day arithmetic, and either would be invisible in ordinary use until it
/// put a date on the wrong day.
///
/// `test/fixtures/cross_language_golden.json` holds the JavaScript package's output for both
/// supported calendars (uaq, fcna) across 1938-2076, plus every month of two full Hijri
/// years, plus the validity edge cases where an off-by-one first shows: day 30 of a 29-day
/// month, month 13, day 0.
///
/// The fixture is produced by the reference implementation: see
/// `tool/generate-parity-fixture.mjs` in the `hijri-core` repository. If this suite fails
/// against an unchanged fixture, that is the divergence it exists to catch — fix the port,
/// do not refresh the fixture.
library;

import 'dart:convert';
import 'dart:io';

import 'package:hijri_core/hijri_core.dart';
import 'package:test/test.dart';

DateTime _utcDay(String iso) {
  final p = iso.split('-').map(int.parse).toList();
  return DateTime.utc(p[0], p[1], p[2]);
}

void main() {
  final raw =
      jsonDecode(
            File('test/fixtures/cross_language_golden.json').readAsStringSync(),
          )
          as Map<String, dynamic>;

  test('fixture covers both calendars and is non-trivial', () {
    expect(
      (raw['calendars'] as List).cast<String>(),
      containsAll(<String>['uaq', 'fcna']),
    );
    expect((raw['toHijri'] as List).length, greaterThan(150));
    expect((raw['toGregorian'] as List).length, greaterThan(150));
  });

  test('the port registers the same calendars as the JavaScript package', () {
    expect(
      listCalendars().toSet(),
      (raw['calendars'] as List).cast<String>().toSet(),
    );
  });

  group('toHijri', () {
    for (final v in (raw['toHijri'] as List).cast<Map<String, dynamic>>()) {
      final cal = v['cal'] as String;
      final g = v['g'] as String;
      test('$cal $g', () {
        final actual = toHijri(
          _utcDay(g),
          options: ConversionOptions(calendar: cal),
        );
        final expected = v['h'] as List?;
        if (expected == null) {
          expect(
            actual,
            isNull,
            reason: 'out of range in JS, must be out of range here too',
          );
          return;
        }
        expect(actual, isNotNull, reason: 'JS produced $expected for $cal $g');
        expect([actual!.hy, actual.hm, actual.hd], expected.cast<int>());
      });
    }
  });

  group('toGregorian', () {
    for (final v in (raw['toGregorian'] as List).cast<Map<String, dynamic>>()) {
      final cal = v['cal'] as String;
      final h = (v['h'] as List).cast<int>();
      test('$cal ${h.join("-")}', () {
        final actual = toGregorian(
          h[0],
          h[1],
          h[2],
          options: ConversionOptions(calendar: cal),
        );
        final expected = v['g'] as String?;
        if (expected == null) {
          expect(actual, isNull);
          return;
        }
        expect(actual, isNotNull, reason: 'JS produced $expected');
        expect(actual!.toUtc().toIso8601String().substring(0, 10), expected);
      });
    }
  });

  group('daysInHijriMonth', () {
    for (final v
        in (raw['monthLengths'] as List).cast<Map<String, dynamic>>()) {
      final cal = v['cal'] as String;
      test('$cal ${v['hy']}-${v['hm']}', () {
        expect(
          daysInHijriMonth(
            v['hy'] as int,
            v['hm'] as int,
            options: ConversionOptions(calendar: cal),
          ),
          v['days'] as int,
        );
      });
    }
  });

  group('isValidHijriDate', () {
    for (final v in (raw['validity'] as List).cast<Map<String, dynamic>>()) {
      final cal = v['cal'] as String;
      final h = (v['h'] as List).cast<int>();
      test('$cal ${h.join("-")}', () {
        expect(
          isValidHijriDate(
            h[0],
            h[1],
            h[2],
            options: ConversionOptions(calendar: cal),
          ),
          v['valid'] as bool,
        );
      });
    }
  });

  test('round-trip: every fixture Hijri date converts back to itself', () {
    // Not a parity assertion but an internal invariant the fixture makes cheap to check.
    for (final v in (raw['toGregorian'] as List).cast<Map<String, dynamic>>()) {
      final cal = v['cal'] as String;
      final h = (v['h'] as List).cast<int>();
      final g = toGregorian(
        h[0],
        h[1],
        h[2],
        options: ConversionOptions(calendar: cal),
      );
      if (g == null) continue;
      final back = toHijri(g, options: ConversionOptions(calendar: cal));
      expect(
        [back!.hy, back.hm, back.hd],
        h,
        reason: '$cal round-trip via ${g.toIso8601String()}',
      );
    }
  });
}
