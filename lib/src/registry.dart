import 'engines/fcna.dart';
import 'engines/uaq.dart';
import 'types.dart';

final Map<String, CalendarEngine> _engines = {};

bool _builtInsRegistered = false;

/// Register the built-in engines on first access to the registry.
///
/// WHY here rather than in the conversion functions: it used to live there, so the registry
/// was only populated as a side effect of calling `toHijri` and friends. A caller whose first
/// action was `listCalendars()` got an empty list, and `getCalendar('uaq')` threw
/// "Unknown Hijri calendar: uaq. Available: ." — naming the very engine the package ships.
/// The JavaScript port registers at module load and has never had this behaviour; the two
/// now agree.
void _ensureBuiltIns() {
  if (_builtInsRegistered) return;
  // Set the flag first: registerCalendar does not re-enter, but a future engine that touched
  // the registry during construction would otherwise recurse.
  _builtInsRegistered = true;
  _engines['uaq'] = uaqEngine;
  _engines['fcna'] = fcnaEngine;
}

/// Register a calendar engine under the given name.
///
/// Once registered, the engine can be selected via [ConversionOptions.calendar]
/// in any conversion function or retrieved directly with [getCalendar].
void registerCalendar(String name, CalendarEngine engine) {
  // Built-ins first, so a caller registering a custom engine before any conversion does not
  // end up with a registry holding only their own.
  _ensureBuiltIns();
  _engines[name] = engine;
}

/// Retrieve a registered calendar engine by name.
///
/// Throws [StateError] if no engine is registered under that name.
CalendarEngine getCalendar(String name) {
  _ensureBuiltIns();
  final engine = _engines[name];
  if (engine == null) {
    final available = listCalendars().join(', ');
    throw StateError(
      'Unknown Hijri calendar: "$name". '
      'Available: $available. '
      'Register custom calendars with registerCalendar().',
    );
  }
  return engine;
}

/// List the names of all registered calendar engines.
List<String> listCalendars() {
  _ensureBuiltIns();
  return _engines.keys.toList();
}
