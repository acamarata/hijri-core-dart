import 'package:hijri_core/hijri_core.dart';
import 'package:test/test.dart';

void main() {
  // ---- Exports exist ----

  group('exports', () {
    test('toHijri is callable', () {
      expect(toHijri, isA<Function>());
    });
    test('toGregorian is callable', () {
      expect(toGregorian, isA<Function>());
    });
    test('isValidHijriDate is callable', () {
      expect(isValidHijriDate, isA<Function>());
    });
    test('daysInHijriMonth is callable', () {
      expect(daysInHijriMonth, isA<Function>());
    });
    test('registerCalendar is callable', () {
      expect(registerCalendar, isA<Function>());
    });
    test('getCalendar is callable', () {
      expect(getCalendar, isA<Function>());
    });
    test('listCalendars is callable', () {
      expect(listCalendars, isA<Function>());
    });
    test('hDatesTable has > 180 entries', () {
      expect(hDatesTable.length, greaterThan(180));
    });
    test('hmLong has 12 entries', () {
      expect(hmLong.length, equals(12));
    });
    test('hmMedium has 12 entries', () {
      expect(hmMedium.length, equals(12));
    });
    test('hmShort has 12 entries', () {
      expect(hmShort.length, equals(12));
    });
    test('hwLong has 7 entries', () {
      expect(hwLong.length, equals(7));
    });
    test('hwShort has 7 entries', () {
      expect(hwShort.length, equals(7));
    });
    test('hwNumeric has 7 entries [1..7]', () {
      expect(hwNumeric, equals([1, 2, 3, 4, 5, 6, 7]));
    });
  });

  // ---- UAQ toGregorian ----

  group('UAQ toGregorian', () {
    test('1444/9/1 = 2023-03-23', () {
      final d = toGregorian(1444, 9, 1);
      expect(d, isNotNull);
      expect(d!.toIso8601String().substring(0, 10), equals('2023-03-23'));
    });
    test('1446/9/1 = 2025-03-01', () {
      final d = toGregorian(1446, 9, 1);
      expect(d, isNotNull);
      expect(d!.toIso8601String().substring(0, 10), equals('2025-03-01'));
    });
    test('1446/10/1 = 2025-03-30', () {
      final d = toGregorian(1446, 10, 1);
      expect(d, isNotNull);
      expect(d!.toIso8601String().substring(0, 10), equals('2025-03-30'));
    });
    test('1318/1/1 = 1900-04-30', () {
      final d = toGregorian(1318, 1, 1);
      expect(d, isNotNull);
      expect(d!.toIso8601String().substring(0, 10), equals('1900-04-30'));
    });
  });

  // ---- UAQ toHijri ----

  group('UAQ toHijri', () {
    test('2023-03-23 = 1444/9/1', () {
      final h = toHijri(DateTime.utc(2023, 3, 23));
      expect(h, isNotNull);
      expect(h!.hy, equals(1444));
      expect(h.hm, equals(9));
      expect(h.hd, equals(1));
    });
    test('2025-03-01 = 1446/9/1', () {
      final h = toHijri(DateTime.utc(2025, 3, 1));
      expect(h, isNotNull);
      expect(h!.hy, equals(1446));
      expect(h.hm, equals(9));
      expect(h.hd, equals(1));
    });
  });

  // ---- UAQ isValid ----

  group('UAQ isValid', () {
    test('1444/9/1 = true', () {
      expect(isValidHijriDate(1444, 9, 1), isTrue);
    });
    test('1317/1/1 = false (before table)', () {
      expect(isValidHijriDate(1317, 1, 1), isFalse);
    });
    test('1501/1/1 = false (sentinel)', () {
      expect(isValidHijriDate(1501, 1, 1), isFalse);
    });
    test('month 0 = false', () {
      expect(isValidHijriDate(1444, 0, 1), isFalse);
    });
    test('month 13 = false', () {
      expect(isValidHijriDate(1444, 13, 1), isFalse);
    });
  });

  // ---- UAQ daysInMonth ----

  group('UAQ daysInMonth', () {
    test('Ramadan 1444 = 29 days', () {
      expect(daysInHijriMonth(1444, 9), equals(29));
    });
    test('throws for month 0', () {
      expect(() => daysInHijriMonth(1444, 0), throwsRangeError);
    });
    test('throws for month 13', () {
      expect(() => daysInHijriMonth(1444, 13), throwsRangeError);
    });
  });

  // ---- FCNA toGregorian ----

  group('FCNA toGregorian', () {
    test('1446/9/1 = 2025-03-01', () {
      final d = toGregorian(
        1446,
        9,
        1,
        options: const ConversionOptions(calendar: 'fcna'),
      );
      expect(d, isNotNull);
      expect(d!.toIso8601String().substring(0, 10), equals('2025-03-01'));
    });
    test('1446/10/1 = 2025-03-30', () {
      final d = toGregorian(
        1446,
        10,
        1,
        options: const ConversionOptions(calendar: 'fcna'),
      );
      expect(d, isNotNull);
      expect(d!.toIso8601String().substring(0, 10), equals('2025-03-30'));
    });
  });

  // ---- FCNA toHijri ----

  group('FCNA toHijri', () {
    test('2025-03-01 = 1446/9/1', () {
      final h = toHijri(
        DateTime.utc(2025, 3, 1),
        options: const ConversionOptions(calendar: 'fcna'),
      );
      expect(h, isNotNull);
      expect(h!.hy, equals(1446));
      expect(h.hm, equals(9));
      expect(h.hd, equals(1));
    });
  });

  // ---- FCNA round-trips ----

  group('FCNA round-trips', () {
    test('1446/9/1 toGregorian->toHijri', () {
      final greg = toGregorian(
        1446,
        9,
        1,
        options: const ConversionOptions(calendar: 'fcna'),
      );
      expect(greg, isNotNull);
      final hijri = toHijri(
        greg!,
        options: const ConversionOptions(calendar: 'fcna'),
      );
      expect(hijri, isNotNull);
      expect(hijri!.hy, equals(1446));
      expect(hijri.hm, equals(9));
      expect(hijri.hd, equals(1));
    });
    test('1446/10/15 toGregorian->toHijri', () {
      final greg = toGregorian(
        1446,
        10,
        15,
        options: const ConversionOptions(calendar: 'fcna'),
      );
      expect(greg, isNotNull);
      final hijri = toHijri(
        greg!,
        options: const ConversionOptions(calendar: 'fcna'),
      );
      expect(hijri, isNotNull);
      expect(hijri!.hy, equals(1446));
      expect(hijri.hm, equals(10));
      expect(hijri.hd, equals(15));
    });
  });

  // ---- FCNA isValid ----

  group('FCNA isValid', () {
    test('1/1/1 = true', () {
      expect(
        isValidHijriDate(
          1,
          1,
          1,
          options: const ConversionOptions(calendar: 'fcna'),
        ),
        isTrue,
      );
    });
    test('1600/1/1 = true', () {
      expect(
        isValidHijriDate(
          1600,
          1,
          1,
          options: const ConversionOptions(calendar: 'fcna'),
        ),
        isTrue,
      );
    });
    test('0/1/1 = false', () {
      expect(
        isValidHijriDate(
          0,
          1,
          1,
          options: const ConversionOptions(calendar: 'fcna'),
        ),
        isFalse,
      );
    });
  });

  // ---- FCNA daysInMonth invalid month ----

  group('FCNA daysInMonth', () {
    test('throws for month 0', () {
      expect(
        () => daysInHijriMonth(
          1446,
          0,
          options: const ConversionOptions(calendar: 'fcna'),
        ),
        throwsRangeError,
      );
    });
    test('throws for month 13', () {
      expect(
        () => daysInHijriMonth(
          1446,
          13,
          options: const ConversionOptions(calendar: 'fcna'),
        ),
        throwsRangeError,
      );
    });
  });

  // ---- Registry ----

  group('registry', () {
    test('listCalendars includes uaq and fcna', () {
      final cals = listCalendars();
      expect(cals, contains('uaq'));
      expect(cals, contains('fcna'));
    });
    test('getCalendar throws for unknown calendar', () {
      expect(() => getCalendar('nonexistent'), throwsStateError);
    });
    test('registerCalendar: custom engine works', () {
      final mockEngine = _MockEngine();
      registerCalendar('mock', mockEngine);

      final cals = listCalendars();
      expect(cals, contains('mock'));

      final h = toHijri(
        DateTime.utc(2020, 1, 1),
        options: const ConversionOptions(calendar: 'mock'),
      );
      expect(h, isNotNull);
      expect(h!.hy, equals(999));

      final g = toGregorian(
        1,
        1,
        1,
        options: const ConversionOptions(calendar: 'mock'),
      );
      expect(g, isNotNull);
      expect(g!.toIso8601String().substring(0, 10), equals('2000-01-01'));

      expect(
        isValidHijriDate(
          1,
          1,
          1,
          options: const ConversionOptions(calendar: 'mock'),
        ),
        isTrue,
      );
      expect(
        daysInHijriMonth(
          1,
          1,
          options: const ConversionOptions(calendar: 'mock'),
        ),
        equals(30),
      );
    });
  });

  // ---- Error cases ----

  group('error cases', () {
    test('UAQ toGregorian returns null for out-of-range date', () {
      expect(toGregorian(1317, 1, 1), isNull);
    });
  });
}

class _MockEngine extends CalendarEngine {
  @override
  String get id => 'mock';

  @override
  HijriDate? toHijri(DateTime date) => const HijriDate(hy: 999, hm: 1, hd: 1);

  @override
  DateTime? toGregorian(int hy, int hm, int hd) => DateTime.utc(2000, 1, 1);

  @override
  bool isValid(int hy, int hm, int hd) =>
      hy > 0 && hm >= 1 && hm <= 12 && hd >= 1;

  @override
  int daysInMonth(int hy, int hm) => 30;
}
