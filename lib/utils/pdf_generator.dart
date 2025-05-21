import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// Fonction principale de génération PDF
Future<Uint8List?> generateGlobalTestResultPdf({
  required double imc,
  required int scoreQuestionnaire,
  required Map<String, List<int>> scoresMoyens,
  bool printDirectly = false,
}) async {
  final pdf = pw.Document();

  final ttfNoto = pw.Font.ttf(await rootBundle.load('assets/fonts/Inter-VariableFont_opsz,wght.ttf'));
  final imageBytes = await rootBundle.load('assets/images/echelle.png');
  final image = pw.MemoryImage(imageBytes.buffer.asUint8List());

  // Définition des couleurs selon score
  PdfColor getPdfColor(int score) {
    switch (score) {
      case 1: return PdfColors.red;
      case 2: return PdfColors.orange;
      case 3: return PdfColors.yellow;
      case 4: return PdfColors.green;
      case 5: return PdfColors.blue;
      default: return PdfColors.grey;
    }
  }

  // Construction d'une ligne de score avec barres colorées
  pw.Widget buildTestScoreRow(String label, int score) {
    final clampedScore = score.clamp(1, 5);
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        children: [
          pw.Expanded(
            flex: 3,
            child: pw.Text(label, style: pw.TextStyle(fontSize: 12, font: ttfNoto)),
          ),
          pw.SizedBox(width: 6),
          pw.Expanded(
            flex: 5,
            child: pw.Row(
              children: List.generate(5, (index) {
                final color = getPdfColor(index + 1);
                final isActive = index == (clampedScore - 1);
                return pw.Expanded(
                  child: pw.Container(
                    height: 18,
                    color: color,
                    alignment: pw.Alignment.center,
                    child: isActive
                        ? pw.Text("✓", style: pw.TextStyle(font: ttfNoto, color: PdfColors.white, fontSize: 14))
                        : null,
                  ),
                );
              }),
            ),
          ),
          pw.SizedBox(width: 8),
          pw.Container(
            width: 25,
            alignment: pw.Alignment.centerRight,
            child: pw.Text('$clampedScore',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttfNoto)),
          ),
        ],
      ),
    );
  }
  pw.Widget buildRadarChartPdf(Map<String, double> scores, Map<String, double> displayVals, {double maxScore = 5}) {
    final fixedLabels = ['Endurance', 'Questionnaire', 'IMC', 'Force', 'Équilibre', 'Souplesse'];
    final labels = fixedLabels;
    final values = fixedLabels.map((label) => scores[label] ?? 0).toList();
    final displayValues = fixedLabels.map((label) => displayVals[label] ?? 0).toList();
    final count = labels.length;

    final double radius = 80;
    final double boxSize = 2 * (radius + 40);
    final double centerX = boxSize / 2;
    final double centerY = boxSize / 2;

    return pw.Center(
      child: pw.SizedBox(
        width: boxSize,
        height: boxSize,
        child: pw.Stack(
          children: [
            pw.CustomPaint(
              size: PdfPoint(boxSize, boxSize),
              painter: (canvas, size) {
                final angleStep = 2 * pi / count;
                final center = PdfPoint(centerX, centerY);

                // Grille + labels niveaux (1 à 5), 1 au centre, 5 au bord
                for (int level = 1; level <= maxScore; level++) {
                  final levelRatio = (level - 1) / (maxScore - 1); // 0 pour 1, 1 pour 5
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

                  final angle = -pi / 2;
                  final x = center.x + cos(angle) * radius * levelRatio;
                  final y = center.y + sin(angle) * radius * levelRatio;
                  final font = PdfFont.helveticaBold(pdf.document);

                  canvas
                    ..setColor(PdfColors.amber)
                    ..drawString(font, 8, '$level', x - 5, y - 3);
                }

                // Traits radiaux
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

                // Points de données (valeurs), 1 au centre, 5 au bord
                final dataPoints = <PdfPoint>[];
                for (int i = 0; i < count; i++) {
                  final angle = i * angleStep - pi / 2;
                  final valueRatio = (values[i] - 1) / (maxScore - 1); // 0 pour 1, 1 pour 5
                  final x = center.x + cos(angle) * radius * valueRatio;
                  final y = center.y + sin(angle) * radius * valueRatio;
                  dataPoints.add(PdfPoint(x, y));
                }

                // Remplissage
                canvas
                  ..setColor(PdfColors.yellow200)
                  ..moveTo(dataPoints.first.x, dataPoints.first.y);
                for (final p in dataPoints.skip(1)) {
                  canvas.lineTo(p.x, p.y);
                }
                canvas.lineTo(dataPoints.first.x, dataPoints.first.y);
                canvas.fillPath();

                // Contour
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

            // Labels axes : texte + valeurs entre parenthèses (avec displayValues)
            for (int i = 0; i < count; i++)
              pw.Positioned(
                left: centerX + cos(2 * pi * i / count - pi / 2) * (radius + 20) - 30,
                top: centerY + sin(2 * pi * i / count - pi / 2) * (radius + 20) - 6,
                child: pw.Container(
                  width: 60,
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    '${labels[i]} (${displayValues[i].toStringAsFixed(1)})',
                    style: pw.TextStyle(fontSize: 8, font: ttfNoto),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }


  double moyenneScore(List<int> scores) {
    if (scores.isEmpty) return 0;
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  final imcScoreVal = imcScore(imc).toDouble();
  final allScores = scoresMoyens.values.expand((v) => v).toList();
  final moyenneScores = allScores.isNotEmpty ? allScores.reduce((a, b) => a + b) / allScores.length : 0;
  final scoreGlobal = (imcScoreVal + scoreQuestionnaire + moyenneScores) / 3;

  // Pour affichage
  final displayValues = {
    'Endurance': moyenneScore(scoresMoyens['endurance'] ?? []),
    'Questionnaire': scoreQuestionnaire.toDouble(),
    'IMC': imcScoreVal,
    'Force': moyenneScore(scoresMoyens['force'] ?? []),
    'Équilibre': moyenneScore(scoresMoyens['equilibre'] ?? []),
    'Souplesse': moyenneScore(scoresMoyens['souplesse'] ?? []),
  };

  // Pour graphique radar (valeurs échangées)
  final radarValues = {
    'Endurance': moyenneScore(scoresMoyens['force'] ?? []),
    'Questionnaire': imcScoreVal,
    'IMC': scoreQuestionnaire.toDouble(),
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

  // Ajout d'une page complète
  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Text('Résultats globaux', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, font: ttfNoto)),
        pw.SizedBox(height: 10),
        pw.Center(child: pw.Image(image, width: 800, height: 150)),
        pw.SizedBox(height: 10),
        pw.Text('Score global : ${scoreGlobal.toStringAsFixed(1)} / 5', style: pw.TextStyle(fontSize: 16, font: ttfNoto)),
        pw.SizedBox(height: 10),

        // IMC
        pw.Text('Indice de masse corporelle (IMC)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttfNoto)),
        pw.SizedBox(height: 5),
        pw.Row(children: [
          pw.Container(width: 20, height: 20, color: getPdfColor(imcScoreVal.round())),
          pw.SizedBox(width: 10),
          pw.Text(imc.toStringAsFixed(1), style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, font: ttfNoto)),
        ]),
        pw.SizedBox(height: 20),

        // Activité physique
        pw.Text("Niveau d'activité physique", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttfNoto)),
        pw.SizedBox(height: 5),
        pw.Row(children: [
          pw.Container(width: 20, height: 20, color: getPdfColor(scoreQuestionnaire)),
          pw.SizedBox(width: 10),
          pw.Text(scoreQuestionnaire.toString(), style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, font: ttfNoto)),
        ]),
        pw.SizedBox(height: 10),

        // Détails des tests
        pw.Text("Détail des scores par catégorie", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, font: ttfNoto)),
        pw.SizedBox(height: 10),
        for (final entry in scoresMoyens.entries)
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                entry.key[0].toUpperCase() + entry.key.substring(1),
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, font: ttfNoto),
              ),
              pw.SizedBox(height: 4),
              pw.Divider(),
              for (int i = 0; i < entry.value.length; i++)
                if (i < (testLabels[entry.key]?.length ?? 0))
                  buildTestScoreRow(testLabels[entry.key]![i], entry.value[i]),
            ],
          ),
        pw.SizedBox(height: 10),

        // Graphique radar
        pw.Text("Graphique radar", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, font: ttfNoto)),
        pw.SizedBox(height: 10),
        buildRadarChartPdf(radarValues, displayValues),

        // Recommandation
        pw.SizedBox(height: 30),
        pw.Text("Recommandation", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16, font: ttfNoto)),
        pw.SizedBox(height: 10),
        pw.Text(
          'Votre condition physique ne traduit pas bon état de santé. '
              'Nous vous invitons à contacter le SSE qui vous proposera un suivi médical.',
          style: pw.TextStyle(fontStyle: pw.FontStyle.italic, fontSize: 12, font: ttfNoto),
        ),
      ],
    ),
  );

  if (printDirectly) {
    // affiche la boîte d'impression, pas besoin de retourner les bytes ici
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    return null; // rien à retourner car on imprime directement
  } else {
    // retourne les bytes pour traitement ultérieur
    return pdf.save();
  }

}

// Score IMC
int imcScore(double imc) {
  if (imc < 18.5) return 1;
  if (imc < 25) return 5;
  if (imc < 30) return 3;
  return 1;
}






