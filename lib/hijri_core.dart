/// Hijri/Gregorian calendar conversion for Dart and Flutter.
///
/// Pluggable engine system with built-in Umm al-Qura (UAQ) and FCNA calendars.
/// Zero dependencies.
library;

// Types
export 'src/types.dart';

// Constants
export 'src/constants.dart';

// Data
export 'src/data.dart';

// Registry
export 'src/registry.dart';

// Names
export 'src/names/months.dart';
export 'src/names/weekdays.dart';

// Engines (for direct access)
export 'src/engines/uaq.dart' show uaqEngine;
export 'src/engines/fcna.dart' show fcnaEngine;

// Top-level convenience API
export 'src/hijri_core_api.dart';
