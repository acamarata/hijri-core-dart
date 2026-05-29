# Advanced Usage

## Selecting a Calendar Engine

The default engine is Umm al-Qura (UAQ). Switch to FCNA for North American Islamic Society dates:

```dart
import 'package:hijri_core/hijri_core.dart';

void main() {
  final date = DateTime.utc(2025, 3, 1);

  final uaq = toHijri(date, calendar: 'uaq');
  final fcna = toHijri(date, calendar: 'fcna');

  print('UAQ:  ${uaq?.hy}/${uaq?.hm}/${uaq?.hd}');
  print('FCNA: ${fcna?.hy}/${fcna?.hm}/${fcna?.hd}');
}
```

## Listing Available Calendars

```dart
final calendars = listCalendars();
print(calendars); // ['uaq', 'fcna']

final engine = getCalendar('uaq');
print(engine.name); // 'Umm al-Qura'
```

## Custom Engine

Implement `CalendarEngine` to plug in your own calendar algorithm:

```dart
import 'package:hijri_core/hijri_core.dart';

class MyCalendarEngine implements CalendarEngine {
  @override
  String get id => 'my-calendar';

  @override
  String get name => 'My Custom Calendar';

  @override
  HijriDate? toHijri(DateTime gregorian) {
    // Your conversion logic here
    return null;
  }

  @override
  DateTime? toGregorian(int hy, int hm, int hd) {
    // Your reverse conversion logic here
    return null;
  }

  @override
  int daysInMonth(int hy, int hm) => 30; // simplified

  @override
  bool isValid(int hy, int hm, int hd) => hm >= 1 && hm <= 12 && hd >= 1 && hd <= 30;
}

// Register and use
registerCalendar(MyCalendarEngine());
final result = toHijri(DateTime.utc(2025, 3, 1), calendar: 'my-calendar');
```

## Ramadan Detection

```dart
bool isRamadan(DateTime date) {
  final hijri = toHijri(date);
  return hijri != null && hijri.hm == 9;
}
```
