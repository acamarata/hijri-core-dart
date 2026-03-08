# hijri_core

[![pub package](https://img.shields.io/pub/v/hijri_core.svg)](https://pub.dev/packages/hijri_core)
[![CI](https://github.com/acamarata/hijri-core-dart/actions/workflows/ci.yml/badge.svg)](https://github.com/acamarata/hijri-core-dart/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Hijri/Gregorian calendar conversion for Dart and Flutter. Zero dependencies.

## Installation

```yaml
dependencies:
  hijri_core: ^1.0.0
```

## Quick Start

```dart
import 'package:hijri_core/hijri_core.dart';

// Gregorian to Hijri (Umm al-Qura by default)
final hijri = toHijri(DateTime.utc(2025, 3, 1));
print('${hijri!.hy}/${hijri.hm}/${hijri.hd}'); // 1446/9/1

// Hijri to Gregorian
final greg = toGregorian(1446, 9, 1);
print(greg!.toIso8601String().substring(0, 10)); // 2025-03-01

// Use FCNA calendar instead
final fcna = toHijri(
  DateTime.utc(2025, 3, 1),
  options: const ConversionOptions(calendar: 'fcna'),
);

// Validate a Hijri date
final valid = isValidHijriDate(1444, 9, 1); // true

// Days in a Hijri month
final days = daysInHijriMonth(1444, 9); // 29
```

## API

### Top-Level Functions

| Function | Description |
| --- | --- |
| `toHijri(DateTime date, {ConversionOptions? options})` | Convert Gregorian to Hijri. Returns `HijriDate?`. |
| `toGregorian(int hy, int hm, int hd, {ConversionOptions? options})` | Convert Hijri to Gregorian. Returns `DateTime?` (UTC). |
| `isValidHijriDate(int hy, int hm, int hd, {ConversionOptions? options})` | Check if a Hijri date is valid. Returns `bool`. |
| `daysInHijriMonth(int hy, int hm, {ConversionOptions? options})` | Days in a Hijri month (29 or 30). Throws `RangeError` if out of range. |

### Registry Functions

| Function | Description |
| --- | --- |
| `registerCalendar(String name, CalendarEngine engine)` | Register a custom calendar engine. |
| `getCalendar(String name)` | Retrieve a registered engine by name. |
| `listCalendars()` | List all registered engine names. |

### Data

| Export | Description |
| --- | --- |
| `hDatesTable` | 184-entry Umm al-Qura reference table (Hijri 1318-1501). |
| `hmLong`, `hmMedium`, `hmShort` | Hijri month names (12 entries each). |
| `hwLong`, `hwShort`, `hwNumeric` | Hijri weekday names (7 entries each). |

## Engines

### UAQ (Umm al-Qura)

The official Saudi Arabian Islamic calendar. Table-driven conversions covering Hijri years 1318-1500 (Gregorian 1900-2076). Returns `null` for dates outside that range.

This is the default engine.

### FCNA (Fiqh Council of North America)

Astronomical calculation using Meeus Chapter 49 new moon algorithm. The FCNA criterion: if the new moon conjunction occurs before 12:00 noon UTC on day D, the new Hijri month begins at midnight starting day D+1. Otherwise it begins at midnight starting day D+2.

No fixed date range. Works for any Hijri year >= 1.

```dart
final h = toHijri(
  DateTime.utc(2025, 3, 1),
  options: const ConversionOptions(calendar: 'fcna'),
);
```

## Custom Engine

Implement the `CalendarEngine` abstract class and register it:

```dart
class MyEngine extends CalendarEngine {
  @override
  String get id => 'custom';

  @override
  HijriDate? toHijri(DateTime date) { /* ... */ }

  @override
  DateTime? toGregorian(int hy, int hm, int hd) { /* ... */ }

  @override
  bool isValid(int hy, int hm, int hd) { /* ... */ }

  @override
  int daysInMonth(int hy, int hm) { /* ... */ }
}

registerCalendar('custom', MyEngine());

final h = toHijri(
  DateTime.utc(2025, 1, 1),
  options: const ConversionOptions(calendar: 'custom'),
);
```

## Compatibility

- Dart SDK >= 3.7.0
- Works with Flutter
- Zero external dependencies

## Related Packages

- [hijri-core](https://www.npmjs.com/package/hijri-core) (TypeScript/npm)
- [nrel-spa](https://www.npmjs.com/package/nrel-spa) (Solar position algorithm)
- [pray-calc](https://www.npmjs.com/package/pray-calc) (Islamic prayer times)

## License

MIT. Copyright (c) 2026 Aric Camarata.
