// main widget file
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:appli_ap_sante/widgets/polygon_chart_section.dart';
import 'package:flutter/material.dart';
import 'package:appli_ap_sante/utils/Score_calculator.dart';
import 'package:appli_ap_sante/utils/pdf_generator.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart'; // Pour getTemporaryDirectory()
import 'package:share_plus/share_plus.dart'; // Pour Share et XFile
import 'dart:io'; // Pour File

class GlobalTestResultPage extends StatefulWidget {
  final double imc;
  final int scoreQuestionnaire;
  final Map<String, List<int>> scoresMoyens;
  final Map<String, Map<String, dynamic>> testResults;

  const GlobalTestResultPage({
    super.key,
    required this.imc,
    required this.scoreQuestionnaire,
    required this.scoresMoyens,
    required this.testResults,
  });

  @override
  State<GlobalTestResultPage> createState() => _GlobalTestResultPageState();
}

class _GlobalTestResultPageState extends State<GlobalTestResultPage> {
  final GlobalKey chartKey = GlobalKey();
  late double scoreGlobal;

  @override
  void initState() {
    super.initState();
    scoreGlobal = _calculateGlobalScore();
  }

  int imcScore(double imc) {
    if (imc < 18.5) return 1;
    if (imc < 25) return 5; // Normal
    if (imc < 30) return 4; // Surpoids léger
    if (imc < 35) return 3; // Obésité modérée
    if (imc < 40) return 2; // Obésité sévère
    return 1; // Obésité morbide
  }

  double _calculateGlobalScore() {
    final imc_Score = imcScore(widget.imc).toDouble();
    final questionnaireScore = widget.scoreQuestionnaire.toDouble();
    final moyennesList = widget.scoresMoyens.values.map((liste) {
      if (liste.isEmpty) return 0.0;
      return liste.reduce((a, b) => a + b) / liste.length;
    }).toList();

    double moyenneScoresMoyens = 0;
    if (moyennesList.isNotEmpty) {
      moyenneScoresMoyens =
          moyennesList.reduce((a, b) => a + b) / moyennesList.length;
    }

    return (imc_Score + questionnaireScore + moyenneScoresMoyens) / 3;
  }

  Future<void> sharePdf(Uint8List pdfBytes) async {
    try {
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/resultat_test.pdf';
      final file = File(filePath);

      await file.writeAsBytes(pdfBytes);

      await Share.shareXFiles([XFile(filePath)],
          text: 'Voici mon résultat de test santé 🩺');
    } catch (e) {
      print('Erreur lors du partage : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Résultats')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Score global : ${scoreGlobal.toStringAsFixed(1)} / 5',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 100),
            PolygonChartSection(
              imc: widget.imc,
              scoreQuestionnaire: widget.scoreQuestionnaire,
              scoresMoyens: widget.scoresMoyens,
              testResults: widget.testResults,
            ),
            const Spacer(),
            const Text('Recommandation',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 16),
            const Text(
              'Votre condition physique ne traduit pas bon état de santé. Nous vous invitons à contacter le SSE qui vous proposera un suivi médical',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 11),
            ),
            const SizedBox(height: 30),
            Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      await generateGlobalTestResultPdf(
                        imc: widget.imc,
                        scoreQuestionnaire: widget.scoreQuestionnaire,
                        scoresMoyens: widget.scoresMoyens,
                        printDirectly: true,
                      );
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Télécharger'),
                    style: ElevatedButton.styleFrom(
                      fixedSize:
                          Size(MediaQuery.sizeOf(context).width * 0.42, 45),
                    ),
                  ),
                  const SizedBox(width: 20), // espace entre les boutons
                  ElevatedButton.icon(
                    icon: Icon(Icons.share),
                    label: Text('Partager'),
                    style: ElevatedButton.styleFrom(
                      fixedSize:
                          Size(MediaQuery.sizeOf(context).width * 0.42, 45),
                    ),
                    onPressed: () async {
                      Uint8List? pdfData = await generateGlobalTestResultPdf(
                        imc: widget.imc,
                        scoreQuestionnaire: widget.scoreQuestionnaire,
                        scoresMoyens: widget.scoresMoyens,
                        printDirectly: false,
                      );

                      if (pdfData != null) {
                        await sharePdf(pdfData);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
