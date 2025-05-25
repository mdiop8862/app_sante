import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:appli_ap_sante/utils/Score_calculator.dart';
// Score IMC
int imcScore(double imc) {
  if (imc < 18.5) return 1;
  if (imc < 25) return 5;
  if (imc < 30) return 3;
  return 1;
}

// Générateur de PDF
Future<Uint8List?> generateGlobalTestResultPdf({
  required double imc,
  required int scoreQuestionnaire,
  required Map<String, List<int>> scoresMoyens,
  bool printDirectly = false,
}) async {
  final pdf = pw.Document();
  final ttfNoto = pw.Font.ttf(await rootBundle.load('assets/fonts/Inter-VariableFont_opsz,wght.ttf'));
  final logoImage = pw.MemoryImage(await rootBundle.load('assets/images/logo.png').then((value) => value.buffer.asUint8List()));
  final tefImage = pw.MemoryImage(await rootBundle.load('assets/images/tef.jpg').then((value) => value.buffer.asUint8List()));

  final bluee = PdfColor.fromInt(0xFF3F3FFF);

  PdfColor getPdfColor(int score) {
    switch (score) {
      case 1: return PdfColors.red;
      case 2: return PdfColors.orange;
      case 3: return PdfColors.yellow;
      case 4: return PdfColors.green;
      case 5: return bluee;
      default: return PdfColors.grey;
    }
  }

  pw.Widget buildTestScoreRow(String label, int score) {
    final clampedScore = score.clamp(1, 5);
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Expanded(
            flex: 3,
            child: pw.Text(label, style: pw.TextStyle(fontSize: 8, font: ttfNoto)),
          ),
          pw.SizedBox(width: 4),
          pw.Expanded(
            flex: 5,
            child: pw.Row(
              children: List.generate(5, (index) {
                final color = getPdfColor(index + 1);
                final isActive = index == (clampedScore - 1);
                return pw.Expanded(
                  child: pw.Container(
                    height: 12,
                    color: color,
                    alignment: pw.Alignment.center,
                    child: isActive
                        ? pw.Text("✓", style: pw.TextStyle(font: ttfNoto, color: PdfColors.white, fontSize: 8))
                        : null,
                  ),
                );
              }),
            ),
          ),
          pw.SizedBox(width: 4),
          pw.Text('$clampedScore', style: pw.TextStyle(fontSize: 8, font: ttfNoto)),
        ],
      ),
    );
  }

  pw.Widget buildRadarChartPdf(Map<String, double> scores, Map<String, double> displayVals, {double maxScore = 5}) {
    final fixedLabels = ['Endurance', 'Questionnaire', 'IMC', 'Force', 'Équilibre', 'Souplesse'];
    final values = fixedLabels.map((label) => scores[label] ?? 0).toList();
    final displayValues = fixedLabels.map((label) => displayVals[label] ?? 0).toList();
    final count = fixedLabels.length;
    final double radius = 80;
    final double boxSize = 2 * (radius + 20);
    final double centerX = boxSize / 2;
    final double centerY = boxSize / 2;

    return pw.SizedBox(
      width: boxSize,
      height: boxSize,
      child: pw.Stack(
        children: [
          pw.CustomPaint(
            size: PdfPoint(boxSize, boxSize),
            painter: (canvas, size) {
              final angleStep = 2 * pi / count;
              final center = PdfPoint(centerX, centerY);

              for (int level = 1; level <= maxScore; level++) {
                final levelRatio = (level - 1) / (maxScore - 1);
                final points = <PdfPoint>[];

                for (int i = 0; i < count; i++) {
                  final angle = i * angleStep - pi / 2;
                  final x = center.x + cos(angle) * radius * levelRatio;
                  final y = center.y + sin(angle) * radius * levelRatio;
                  points.add(PdfPoint(x, y));
                }

                for (int i = 0; i < points.length; i++) {
                  final next = (i + 1) % points.length;
                  canvas
                    ..setLineWidth(0.5)
                    ..setColor(PdfColors.grey300)
                    ..moveTo(points[i].x, points[i].y)
                    ..lineTo(points[next].x, points[next].y)
                    ..strokePath();
                }
              }

              for (int i = 0; i < count; i++) {
                final angle = i * angleStep - pi / 2;
                final x = center.x + cos(angle) * radius;
                final y = center.y + sin(angle) * radius;
                canvas
                  ..setLineWidth(0.5)
                  ..setColor(PdfColors.grey600)
                  ..moveTo(center.x, center.y)
                  ..lineTo(x, y)
                  ..strokePath();
              }

              final dataPoints = <PdfPoint>[];
              for (int i = 0; i < count; i++) {
                final angle = i * angleStep - pi / 2;
                final valueRatio = values[i] / maxScore;
                final x = center.x + cos(angle) * radius * valueRatio;
                final y = center.y + sin(angle) * radius * valueRatio;
                dataPoints.add(PdfPoint(x, y));
              }

              canvas
                ..setColor(PdfColors.yellow200)
                ..moveTo(dataPoints.first.x, dataPoints.first.y);
              for (final p in dataPoints.skip(1)) {
                canvas.lineTo(p.x, p.y);
              }
              canvas.lineTo(dataPoints.first.x, dataPoints.first.y);
              canvas.fillPath();

              canvas
                ..setColor(PdfColors.yellow900)
                ..setLineWidth(2)
                ..moveTo(dataPoints.first.x, dataPoints.first.y);
              for (final p in dataPoints.skip(1)) {
                canvas.lineTo(p.x, p.y);
              }
              canvas.lineTo(dataPoints.first.x, dataPoints.first.y);
              canvas.strokePath();
            },
          ),
          for (int i = 0; i < count; i++)
            pw.Positioned(
              left: centerX + cos(2 * pi * i / count - pi / 2) * (radius + 10) - 20,
              top: centerY + sin(2 * pi * i / count - pi / 2) * (radius + 10) - 6,
              child: pw.Container(
                width: 40,
                alignment: pw.Alignment.center,
                child: pw.Text(
                  '${fixedLabels[i]} (${displayValues[i].toStringAsFixed(1)})',
                  style: pw.TextStyle(fontSize: 6, font: ttfNoto),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  double moyenneScore(List<int> scores) => scores.isEmpty ? 0 : scores.reduce((a, b) => a + b) / scores.length;

  final imcVal = imcScore(imc).toDouble();
  final questionnaireVal = scoreQuestionnaire.toDouble();
  final moyenneTests = scoresMoyens.values.expand((e) => e).isEmpty
      ? 0
      : scoresMoyens.values.map((l) => moyenneScore(l)).reduce((a, b) => a + b) / scoresMoyens.length;
  final scoreGlobal = (imcVal + questionnaireVal + moyenneTests) / 3;

  final displayValues = {
    'Endurance': moyenneScore(scoresMoyens['endurance'] ?? []),
    'Questionnaire': questionnaireVal,
    'IMC': imcVal,
    'Force': moyenneScore(scoresMoyens['force'] ?? []),
    'Équilibre': moyenneScore(scoresMoyens['equilibre'] ?? []),
    'Souplesse': moyenneScore(scoresMoyens['souplesse'] ?? []),
  };
  final radarValues = {
    'Endurance': moyenneScore(scoresMoyens['force'] ?? []),
    'Questionnaire': imcVal,
    'IMC': questionnaireVal,
    'Force': moyenneScore(scoresMoyens['endurance'] ?? []),
    'Équilibre': moyenneScore(scoresMoyens['souplesse'] ?? []),
    'Souplesse': moyenneScore(scoresMoyens['equilibre'] ?? []),
  };

  final testLabels = {
    'endurance': ['Marche 6 min', 'Montée de marche'],
    'force': ['Assis-debout 30s', 'Test de la chaise'],
    'souplesse': ['Flexomètre', 'Main/pied', 'Épaule'],
    'equilibre': ['Test du flamand'],
  };

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (context) {
        return pw.Column(

          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Image(logoImage, width: 80),
                pw.Image(tefImage, width: 80),
              ],
            ),
            pw.SizedBox(height: 12),
            pw.Text('Résultats au test de condition physique inspiré de tous en forme',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, font: ttfNoto)),
            pw.SizedBox(height: 6),
            pw.Text('Score global : ${scoreGlobal.toStringAsFixed(1)} / 5',
                style: pw.TextStyle(fontSize: 14, font: ttfNoto)),
            pw.SizedBox(height: 14),

            // Ligne IMC + Activité + Graph radar à droite
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 4,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Indice de masse corporelle (IMC)',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttfNoto)),
                      pw.SizedBox(height: 4),
                      pw.Row(children: [
                        pw.Container(width: 18, height: 18, color: getPdfColor(imcScore(imcVal))),
                        pw.SizedBox(width: 8),
                        pw.Text(imc.toStringAsFixed(1),
                            style: pw.TextStyle(fontSize: 12, font: ttfNoto)),
                      ]),
                      pw.SizedBox(height: 12),

                      pw.Text("Niveau d'activité physique",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttfNoto)),
                      pw.SizedBox(height: 4),
                      pw.Row(children: [
                        pw.Container(width: 18, height: 18, color: getPdfColor(scoreQuestionnaire)),
                        pw.SizedBox(width: 8),
                        pw.Text(scoreQuestionnaire.toString(),
                            style: pw.TextStyle(fontSize: 12, font: ttfNoto)),
                      ]),
                    ],
                  ),
                ),
                pw.SizedBox(width: 20),
                pw.Expanded(
                  flex: 5,
                  child: buildRadarChartPdf(radarValues, displayValues),
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            // Détails des tests
            pw.Text("Détail des scores par catégorie",
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, font: ttfNoto)),
            pw.SizedBox(height: 6),
            for (final entry in scoresMoyens.entries)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 4),
                  pw.Text(
                    entry.key[0].toUpperCase() + entry.key.substring(1),
                    style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, font: ttfNoto),
                  ),
                  pw.Divider(thickness: 0.5),
                  for (int i = 0; i < entry.value.length; i++)
                    if (i < (testLabels[entry.key]?.length ?? 0))
                      buildTestScoreRow(testLabels[entry.key]![i], entry.value[i]),
                ],
              ),
            pw.SizedBox(height: 20),

            // Recommandation en bas
            pw.Text("Recommandation",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14, font: ttfNoto)),
            pw.SizedBox(height: 6),
            pw.Text(
              'Votre condition physique ne traduit pas bon état de santé. '
                  'Nous vous invitons à contacter le SSE qui vous proposera un suivi médical.',
              style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 10, font: ttfNoto),
            ),
          ],
        );
      },
    ),
  );


  if (printDirectly) {
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    return null;
  } else {
    return pdf.save();
  }
}
