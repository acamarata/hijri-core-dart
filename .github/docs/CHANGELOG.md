# Changelog

All notable changes to this project will be documented in this file.

## 1.0.0

### Added

- Umm al-Qura (UAQ) engine: table-driven conversion for Hijri years 1318-1500
- FCNA engine: astronomical new moon calculation using Meeus Ch. 49
- Pluggable engine registry with `registerCalendar()` and `getCalendar()`
- Top-level convenience functions: `toHijri()`, `toGregorian()`, `isValidHijriDate()`, `daysInHijriMonth()`
- Hijri month names in long, medium, and short forms
- Hijri weekday names in long, short, and numeric forms
- Full 184-entry Umm al-Qura reference table (1318-1501 H)
- Zero external dependencies
