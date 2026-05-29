# Basic Usage Examples

## Convert Today's Date

```dart
import 'package:hijri_core/hijri_core.dart';

void main() {
  final today = DateTime.now().toUtc();
  final hijri = toHijri(today);

  if (hijri != null) {
    final months = [
      '', 'Muharram', 'Safar', "Rabi' al-Awwal", "Rabi' al-Thani",
      'Jumada al-Awwal', 'Jumada al-Thani', 'Rajab', "Sha'ban",
      'Ramadan', 'Shawwal', "Dhu al-Qi'dah", 'Dhu al-Hijjah',
    ];
    print('Today in Hijri: ${hijri.hd} ${months[hijri.hm]} ${hijri.hy} AH');
  }
}
```

## Ramadan Calendar for a Year

```dart
import 'package:hijri_core/hijri_core.dart';

void main() {
  // Find Ramadan 1446 start and end in Gregorian
  final ramadanStart = toGregorian(1446, 9, 1);
  final ramadanEnd   = toGregorian(1446, 9, daysInMonth(1446, 9));

  print('Ramadan 1446: ${ramadanStart?.toIso8601String().substring(0, 10)} '
        'to ${ramadanEnd?.toIso8601String().substring(0, 10)}');
}
```

## UAQ vs FCNA Comparison

```dart
import 'package:hijri_core/hijri_core.dart';

void main() {
  final dates = [
    DateTime.utc(2024, 4, 9),  // Eid al-Fitr 2024
    DateTime.utc(2024, 6, 16), // Eid al-Adha 2024
    DateTime.utc(2025, 3, 30), // Eid al-Fitr 2025
  ];

  print('Gregorian    UAQ           FCNA');
  print('${'─' * 45}');
  for (final d in dates) {
    final uaq  = toHijri(d, calendar: 'uaq');
    final fcna = toHijri(d, calendar: 'fcna');
    final greg = d.toIso8601String().substring(0, 10);
    final uaqStr  = uaq  != null ? '${uaq.hy}/${uaq.hm}/${uaq.hd}'   : 'n/a';
    final fcnaStr = fcna != null ? '${fcna.hy}/${fcna.hm}/${fcna.hd}' : 'n/a';
    print('$greg  ${uaqStr.padRight(14)}$fcnaStr');
  }
}
```
