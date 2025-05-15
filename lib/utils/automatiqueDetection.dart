String detectCategory(String title) {
  if (title.contains('endurance')) return 'endurance';
  if (title.contains('force')) return 'force';
  if (title.contains('équilibre')) return 'equilibre';
  if (title.contains('souplesse')) return 'souplesse';
  if (title.contains('questionnaire')) return 'questionnaire';
  return 'autres';
}

String normalizeTestKey(String title) {
  title = title.toLowerCase().trim();

  if (title.contains('flamand')) return 'test_du_flamand';
  if (title.contains('marche') && title.contains('6')) return 'test_de_marche__6_minutes';
  if (title.contains('montée')) return 'test_de_la_montée_de_marche';
  if (title.contains('assis-debout')) return 'test_du_assis-debout_-_30_sec';
  if (title.contains('chaise')) return 'test_de_la_chaise';
  if (title.contains('handgrip')) return 'test_de_handgrip';
  if (title.contains('flexomètre')) return 'test_de_flexomètre';

  return title.replaceAll(RegExp(r'\s+'), '_');
}
