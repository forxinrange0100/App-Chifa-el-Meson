

int boolToInt (bool value) => value ? 1 : 0;

bool intToBool (int value) => value == 1;

bool dynamicToBool (dynamic value, {bool defaultValue = false}) {
  if (value is bool) return value;
  if (value is int) return intToBool(value);
  return defaultValue;
}