# Changelog

All notable changes to this project will be documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
This project adheres to [Semantic Versioning](https://semver.org/).

## 1.0.1

### Fixed

- `toHijri` now normalizes the input `DateTime` to its UTC calendar day before
  lookup (via `date.toUtc()`), matching the UTC-midnight contract of `toGregorian`.
  Previously, passing a local `DateTime` on a host west of UTC could return the
  previous Hijri day, breaking `toHijri(toGregorian(y, m, d))` round-trips.
  Applies to both the UAQ and FCNA engines.

## [1.0.0] - 2026-05-25

### Added

- Initial public release.
- `toHijri` — converts a Gregorian `DateTime` to a Hijri date tuple.
- `fromHijri` — converts a Hijri date tuple to a Gregorian `DateTime`.
- `daysInMonth` — returns the number of days in a given Hijri month for a given engine.
- `isValid` — validates a Hijri date for a given engine.
- `listCalendars` / `getCalendar` — registry API for available calendar engines.
- Built-in Umm al-Qura (UAQ) engine with tabular data.
- Built-in FCNA (Fiqh Council of North America) calculated engine.
- Pluggable `CalendarEngine` abstract class for custom Hijri calendar implementations.
- Pure Dart implementation. Zero runtime dependencies.
- Dart SDK `^3.7.0` compatibility.
- 42 unit tests covering all 8 SPORT features across both UAQ and FCNA engines.
