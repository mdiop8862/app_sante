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
    print(endurance);
    final labelsWithScores = [
      ['Endurance', endurance],
      ['Questionnaire', questionnaireScore],
      ['IMC', imcSc],
      ['Force', force],
      ['Équilibre', equilibre],
      ['Souplesse', souplesse],
    ];

    return AspectRatio(
      aspectRatio: 1.9,
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          radarBorderData: const BorderSide(color: Colors.grey, width: 4),
          gridBorderData: BorderSide(color: Colors.yellow.withOpacity(0.3), width: 1),
          tickBorderData: const BorderSide(color: Colors.transparent),
          ticksTextStyle: const TextStyle(color: Colors.yellow, fontSize: 10),
          tickCount: 3,
          isMinValueAtCenter: true,
          dataSets: [
            RadarDataSet(
              fillColor: Color(0xFFCCFF00),
              borderColor: Colors.transparent,
              entryRadius: 1,
              dataEntries: labelsWithScores
                  .map((entry) => RadarEntry(value: (entry[1] as double)))
                  .toList(),
            ),
          ],
          getTitle: (index, angle) {
            final label = labelsWithScores[index][0];
            final score = (labelsWithScores[index][1] as double).toStringAsFixed(1);
            return RadarChartTitle(
              text: '$label ($score)',
              positionPercentageOffset: 0.5,
            );
          },
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
          titlePositionPercentageOffset: .2,
        ),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  /// Calcule la moyenne des sous-tests
  double _getAverage(Map<String, dynamic>? map) {
    if (map == null || map.isEmpty) return 0;
    final values = map.values.whereType<num>().toList();
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  /// Donne un score IMC sur 5
  double _imcScore(double imc) {
    if (imc < 18.5) return 1;
    if (imc < 25) return 5;
    if (imc < 30) return 4;
    if (imc < 35) return 3;
    if (imc < 40) return 2;
    return 1;
  }
}
