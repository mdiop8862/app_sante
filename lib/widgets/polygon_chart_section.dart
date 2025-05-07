import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PolygonChartSection extends StatelessWidget {
  const PolygonChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.9,
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          radarBorderData: const BorderSide(
            color: Color(0xFFCCFF00),
            width: 4,
          ),
          gridBorderData: BorderSide(
            color: Colors.yellow.withOpacity(0.3),
            width: 1,
          ),
          tickBorderData: const BorderSide(color: Colors.transparent),
          ticksTextStyle: const TextStyle(
            color: Colors.yellow,
            fontSize: 10,
          ),
          // Affiche les graduations 0, 2, 4
          tickCount: 3,
          isMinValueAtCenter: true,
          // ticksPercentage: 1,
          // tickOffset: 0,
          // Données d'affichage
          dataSets: [
            RadarDataSet(
              fillColor: Colors.grey.withOpacity(0.4),
              borderColor: Colors.transparent,
              entryRadius: 1,
              dataEntries: [
                const RadarEntry(value: 2), // Endurance
                const RadarEntry(value: 1.5), // Score Sedent
                const RadarEntry(value: 2.2), // Score B et C
                const RadarEntry(value: 2.8), // IMC
                const RadarEntry(value: 1.9), // Force
                const RadarEntry(value: 2.3), // Équilibre
                const RadarEntry(value: 1.8), // Souplesse
              ],
            ),
          ],
          // Valeur maximale pour tous les axes
          // maxEntry: 4,

          // Titres des axes
          getTitle: (index, angle) {
            return RadarChartTitle(
              text: [
                'Endurance',
                'Score Sedent',
                'Score B et C',
                'IMC',
                'Force',
                'Équilibre',
                'Souplesse',
              ][index],
              // angle: ,
              positionPercentageOffset: 0.5,
            );
          },
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          titlePositionPercentageOffset: .2,
        ),
        duration: const Duration(milliseconds: 500),
      ),
    );
  }
}
