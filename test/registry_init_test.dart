/// The registry must be usable as the very first call into the package.
///
/// Registration of the built-in engines used to happen as a side effect of calling a
/// conversion function. A caller whose first action was `listCalendars()` therefore got an
/// empty list, and `getCalendar('uaq')` threw "Unknown Hijri calendar: uaq. Available: ." —
/// naming the very engine the package ships with as unavailable.
///
/// Found 2026-08-22 by the cross-language parity fixture: the JavaScript port registers at
/// module load and returned ['uaq', 'fcna'] on a cold call, so the two disagreed.
///
/// This file deliberately contains no conversion call before its assertions. Adding one would
/// warm the registry and make every test here pass regardless of the fix.
library;

import 'package:hijri_core/hijri_core.dart';
import 'package:test/test.dart';

void main() {
  test('listCalendars is populated on a cold call', () {
    expect(listCalendars(), containsAll(<String>['uaq', 'fcna']));
  });

  test('getCalendar resolves a built-in on a cold call', () {
    // The old failure mode threw StateError here rather than returning an engine.
    expect(() => getCalendar('uaq'), returnsNormally);
    expect(() => getCalendar('fcna'), returnsNormally);
  });

  test('an unknown calendar still throws, and names the real alternatives', () {
    // The error message is only useful if the registry is populated when it is built.
    expect(
      () => getCalendar('not-a-calendar'),
      throwsA(
        isA<StateError>().having(
          (e) => e.message,
          'message',
          allOf(contains('uaq'), contains('fcna')),
        ),
      ),
    );
  });

  test('registering a custom engine does not displace the built-ins', () {
    registerCalendar('custom-test', uaqEngine);
    expect(
      listCalendars(),
      containsAll(<String>['uaq', 'fcna', 'custom-test']),
    );
  });
}
