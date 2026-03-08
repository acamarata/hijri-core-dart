# hijri_core

Hijri/Gregorian calendar conversion for Dart and Flutter. Supports Umm al-Qura (UAQ) and FCNA/ISNA calendars. Zero dependencies.

## Quick Start

```dart
import 'package:hijri_core/hijri_core.dart';

final hijri = toHijri(DateTime.utc(2025, 3, 1));
print('${hijri!.hy}/${hijri.hm}/${hijri.hd}'); // 1446/9/1

final greg = toGregorian(1446, 9, 1);
print(greg!.toIso8601String().substring(0, 10)); // 2025-03-01
```

## Pages

- [API Reference](API-Reference) — Full function and type reference
- [Calendar Systems](Calendar-Systems) — UAQ and FCNA algorithm details
