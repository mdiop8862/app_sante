// main widget file
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:appli_ap_sante/widgets/polygon_chart_section.dart';
import 'package:flutter/material.dart';
import 'package:appli_ap_sante/utils/Score_calculator.dart';
import 'package:appli_ap_sante/utils/pdf_generator.dart';
import 'package:flutter/rendering.dart';

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

  double _calculateGlobalScore() {
    final imc_Score = imcScore(widget.imc).toDouble();
    final questionnaireScore = widget.scoreQuestionnaire.toDouble();
    final moyennesList = widget.scoresMoyens.values.map((liste) {
      if (liste.isEmpty) return 0.0;
      return liste.reduce((a, b) => a + b) / liste.length;
    }).toList();

    double moyenneScoresMoyens = 0;
    if (moyennesList.isNotEmpty) {
      moyenneScoresMoyens = moyennesList.reduce((a, b) => a + b) / moyennesList.length;
    }

    return (imc_Score + questionnaireScore + moyenneScoresMoyens) / 3;
  }

  Future<Uint8List?> captureWidgetAsImage(GlobalKey key) async {
    final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
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
            Text('Score global : ${scoreGlobal.toStringAsFixed(1)} / 5', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 100),

              PolygonChartSection(
                imc: widget.imc,
                scoreQuestionnaire: widget.scoreQuestionnaire,
                scoresMoyens: widget.scoresMoyens,
                testResults: widget.testResults,
              ),

            const Spacer(),
            const Text('Recommendation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 16),
            const Text(
              'Votre condition physique ne traduit pas bon état de santé. Nous vous invitons à contacter le SSE qui vous proposera un suivi médical',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 11),
            ),
            const SizedBox(height: 30),
            Align(
              child: ElevatedButton(
                onPressed: () async {
                    await generateGlobalTestResultPdf(
                      imc: widget.imc,
                      scoreQuestionnaire: widget.scoreQuestionnaire,
                      scoresMoyens: widget.scoresMoyens,
                    );
                },
                style: ElevatedButton.styleFrom(fixedSize: Size(MediaQuery.sizeOf(context).width * .7, 45)),
                child: const Text('Télécharger'),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
