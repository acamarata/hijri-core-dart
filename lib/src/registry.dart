import 'types.dart';

final Map<String, CalendarEngine> _engines = {};

/// Register a calendar engine under the given name.
///
/// Once registered, the engine can be selected via [ConversionOptions.calendar]
/// in any conversion function or retrieved directly with [getCalendar].
void registerCalendar(String name, CalendarEngine engine) {
  _engines[name] = engine;
}

/// Retrieve a registered calendar engine by name.
///
/// Throws [StateError] if no engine is registered under that name.
CalendarEngine getCalendar(String name) {
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
  return _engines.keys.toList();
}
