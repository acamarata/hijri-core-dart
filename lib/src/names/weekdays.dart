/// Hijri weekday names in long form.
/// Index 0 = Sunday, index 6 = Saturday (matching DateTime.weekday % 7).
const List<String> hwLong = [
  'Yawm al-Ahad', // Sunday
  'Yawm al-Ithnayn', // Monday
  "Yawm ath-Thulatha'", // Tuesday
  "Yawm al-Arba`a'", // Wednesday
  'Yawm al-Khamis', // Thursday
  'Yawm al-Jum`a', // Friday
  'Yawm as-Sabt', // Saturday
];

/// Hijri weekday names in short form.
const List<String> hwShort = [
  'Ahad', // Sunday
  'Ithn', // Monday
  'Thul', // Tuesday
  'Arba', // Wednesday
  'Kham', // Thursday
  'Jum`a', // Friday
  'Sabt', // Saturday
];

/// Numeric weekday representation: 1 = Sunday, 7 = Saturday.
const List<int> hwNumeric = [1, 2, 3, 4, 5, 6, 7];
