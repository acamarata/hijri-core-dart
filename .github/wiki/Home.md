# hijri_core

Hijri/Gregorian calendar conversion for Dart and Flutter. Pluggable engine system with built-in Umm al-Qura (UAQ) and FCNA calendar implementations. Zero dependencies.

## Install

```yaml
dependencies:
  hijri_core: ^1.0.0
```

```dart
import 'package:hijri_core/hijri_core.dart';

final hijri = toHijri(DateTime.utc(2025, 3, 1));
print('${hijri!.hy}/${hijri.hm}/${hijri.hd}'); // 1446/9/1

final greg = toGregorian(1446, 9, 1);
print(greg!.toIso8601String().substring(0, 10)); // 2025-03-01
```

## Contents

- [Quickstart Guide](guides/quickstart) — install, first call, engine selection
- [Advanced Usage](guides/advanced) — pluggable engines, custom calendars
- [API Reference](API-Reference) — full function and type reference
- [Examples](examples/basic-usage) — real-world snippets
- [Contributing](CONTRIBUTING)
