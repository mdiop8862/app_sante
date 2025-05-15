String detectCategory(String title) {
  if (title.contains('endurance')) return 'endurance';
  if (title.contains('force')) return 'force';
  if (title.contains('équilibre')) return 'equilibre';
  if (title.contains('souplesse')) return 'souplesse';
  if (title.contains('questionnaire')) return 'questionnaire';
  return 'autres';
}

String normalizeTestKey(String raw) {
  return raw
      .toLowerCase()
      .replaceAll('–', '')
      .replaceAll('(', '')
      .replaceAll(')', '')
      .replaceAll(' ', '_')
      .trim();
}
