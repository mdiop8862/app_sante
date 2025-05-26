import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PolygonChartSection extends StatelessWidget {
  final double imc;
  final int scoreQuestionnaire;
  final Map<String, List<int>> scoresMoyens;
  final Map<String, Map<String, dynamic>> testResults;

  const PolygonChartSection({
    super.key,
    required this.imc,
    required this.scoreQuestionnaire,
    required this.scoresMoyens,
    required this.testResults,
  });

  double moyenneScore(List<int> scores) {
    if (scores.isEmpty) return 0;
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  @override
  Widget build(BuildContext context) {
    final endurance = moyenneScore(scoresMoyens['endurance'] ?? []);
    final force = moyenneScore(scoresMoyens['force'] ?? []);
    final equilibre = moyenneScore(scoresMoyens['equilibre'] ?? []);
    final souplesse = moyenneScore(scoresMoyens['souplesse'] ?? []);
    final questionnaireScore = scoreQuestionnaire.toDouble();
    final imcSc = _imcScore(imc);

    final labelsWithScores = [
      ['Endurance', endurance],
      ['Questionnaire', questionnaireScore],
      ['IMC', imcSc],
      ['Force', force],
      ['Équilibre', equilibre],
      ['Souplesse', souplesse],
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;
        return SizedBox(
          width: size,
          height: size,
          child: RadarChart(
            RadarChartData(
              radarShape: RadarShape.polygon,
              radarBorderData: const BorderSide(color: Colors.white, width: 4),
              gridBorderData: BorderSide(
                color: Colors.cyanAccent.withOpacity(0.4),
                width: 2,
              ),
              tickBorderData: BorderSide(
                color: Colors.deepOrangeAccent.withOpacity(0.8),
                width: 2,
              ),
              ticksTextStyle: const TextStyle(
                color: Colors.yellowAccent,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
              tickCount: 5,
              isMinValueAtCenter: true,
              dataSets: [
                RadarDataSet(
                  fillColor: Colors.greenAccent.withOpacity(0.6),
                  borderColor: Colors.greenAccent,
                  borderWidth: 3,
                  entryRadius: 4,
                  dataEntries: labelsWithScores
                      .map((entry) => RadarEntry(value: (entry[1] as double)))
                      .toList(),
                ),
              ],
              getTitle: (index, angle) {
                final label = labelsWithScores[index][0];
                final score = (labelsWithScores[index][1] as double).toStringAsFixed(1);
                final isQuestionnaire = label == 'Questionnaire';

                return RadarChartTitle(
                  text: '$label\n($score)',
                  positionPercentageOffset: isQuestionnaire ? 0.08 : 0.10, // 🟡 Ajustement ici
                );
              },
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 13, // ✔️ Augmenté mais contrôlé
                fontWeight: FontWeight.w600,
              ),
              titlePositionPercentageOffset: 0.08, // même logique que getTitle
            ),
            duration: const Duration(milliseconds: 600),
          ),
        );
      },
    );
  }

  double _getAverage(Map<String, dynamic>? map) {
    if (map == null || map.isEmpty) return 0;
    final values = map.values.whereType<num>().toList();
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  double _imcScore(double imc) {
    if (imc < 18.5) return 1;
    if (imc < 25) return 5;
    if (imc < 30) return 4;
    if (imc < 35) return 3;
    if (imc < 40) return 2;
    return 1;
  }
}
