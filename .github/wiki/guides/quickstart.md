# Quickstart

## Install

Add to `pubspec.yaml`:

```yaml
dependencies:
  hijri_core: ^1.0.0
```

Run `dart pub get`.

## Gregorian to Hijri

```dart
import 'package:hijri_core/hijri_core.dart';

void main() {
  final hijri = toHijri(DateTime.utc(2025, 3, 1));
  if (hijri != null) {
    print('${hijri.hy}/${hijri.hm}/${hijri.hd}'); // 1446/9/1
  }
}
```

## Hijri to Gregorian

```dart
final greg = toGregorian(1446, 9, 1);
if (greg != null) {
  print(greg.toIso8601String().substring(0, 10)); // 2025-03-01
}
```

Both functions return `null` for dates outside the supported range.

## Days in a Hijri Month

```dart
final days = daysInMonth(1446, 9); // Ramadan 1446
print(days); // 29 or 30
```

## Validate a Hijri Date

```dart
final valid = isValid(1446, 9, 15);  // true
final bad   = isValid(1446, 13, 1);  // false (month 13 does not exist)
```

## Supported Date Range

The Umm al-Qura engine covers 1318 AH (1900 CE) through 1500 AH (2077 CE). Dates outside this range return `null`. The FCNA engine uses a calculated formula with no hard date limit.
