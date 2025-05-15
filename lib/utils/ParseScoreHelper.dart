int parseScore(dynamic val) {
  if (val is int) return val;
  if (val is String) return int.tryParse(val) ?? 0;
  return 0;
}
