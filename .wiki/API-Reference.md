# API Reference

## Conversion Functions

### toHijri

```dart
HijriDate? toHijri(DateTime date, {ConversionOptions? options})
```

Converts a Gregorian date to a Hijri date. Returns `null` if the date falls outside the engine's supported range.

The default engine is UAQ (Umm al-Qura), covering Hijri years 1318-1500 (Gregorian 1900-2076).

```dart
final hijri = toHijri(DateTime.utc(2025, 3, 1));
// hijri.hy == 1446, hijri.hm == 9, hijri.hd == 1
```

### HijriDate fields

| Field | Type | Description |
| --- | --- | --- |
| `hy` | `int` | Hijri year |
| `hm` | `int` | Hijri month (1-12) |
| `hd` | `int` | Hijri day (1-30) |

---

### toGregorian

```dart
DateTime? toGregorian(int hy, int hm, int hd, {ConversionOptions? options})
```

Converts a Hijri date to a Gregorian `DateTime` (UTC, midnight). Returns `null` if the date is outside the engine's supported range or is invalid.

```dart
final greg = toGregorian(1446, 9, 1);
// greg.toIso8601String().substring(0, 10) == "2025-03-01"
```

---

### isValidHijriDate

```dart
bool isValidHijriDate(int hy, int hm, int hd, {ConversionOptions? options})
```

Returns `true` if the given Hijri date is valid within the selected engine's calendar. Checks year range, month range (1-12), and day range (1 to the actual days in that month).

---

### daysInHijriMonth

```dart
int daysInHijriMonth(int hy, int hm, {ConversionOptions? options})
```

Returns the number of days in a Hijri month (29 or 30). Throws `RangeError` if the year or month is out of the engine's supported range.

---

## ConversionOptions

```dart
const ConversionOptions({String calendar = 'uaq'})
```

| Field | Type | Default | Description |
| --- | --- | --- | --- |
| `calendar` | `String` | `'uaq'` | Engine name: `'uaq'` or `'fcna'`, or any registered custom name |

---

## Registry Functions

### registerCalendar

```dart
void registerCalendar(String name, CalendarEngine engine)
```

Registers a custom `CalendarEngine` under the given name. The name is case-sensitive. Registering a name that already exists overwrites the previous engine.

### getCalendar

```dart
CalendarEngine getCalendar(String name)
```

Retrieves a registered engine by name. Throws `ArgumentError` if the name is not registered.

### listCalendars

```dart
List<String> listCalendars()
```

Returns all registered calendar engine names, including the built-in `'uaq'` and `'fcna'`.

---

## CalendarEngine (abstract)

Implement this class to create a custom calendar engine:

```dart
abstract class CalendarEngine {
  String get id;
  HijriDate? toHijri(DateTime date);
  DateTime? toGregorian(int hy, int hm, int hd);
  bool isValid(int hy, int hm, int hd);
  int daysInMonth(int hy, int hm);
}
```

---

## Data Exports

### hDatesTable

```dart
final List<List<int>> hDatesTable
```

The 184-entry Umm al-Qura reference table covering Hijri years 1318-1501. Each entry contains the Gregorian year, month, and day of the first day of that Hijri year. Used internally by the UAQ engine.

### Month and weekday name lists

| Export | Length | Example |
| --- | --- | --- |
| `hmLong` | 12 | `'Muharram'`, `'Safar'`, ... |
| `hmMedium` | 12 | Abbreviated month names |
| `hmShort` | 12 | Short month abbreviations |
| `hwLong` | 7 | `'Al-Ahad'`, `'Al-Ithnayn'`, ... |
| `hwShort` | 7 | Short weekday names |
| `hwNumeric` | 7 | Numeric weekday strings |

---

[Home](Home)
