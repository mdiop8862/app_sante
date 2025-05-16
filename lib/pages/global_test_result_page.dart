import 'package:appli_ap_sante/widgets/polygon_chart_section.dart';
import 'package:flutter/material.dart';
import 'package:appli_ap_sante/utils/Score_calculator.dart';

class GlobalTestResultPage extends StatefulWidget {
  final double imc;
  final int scoreQuestionnaire;
  final Map<String, double> scoresMoyens;
  const GlobalTestResultPage({
    super.key,
    required this.imc,
    required this.scoreQuestionnaire,
    required this.scoresMoyens,
  });
  @override
  State<GlobalTestResultPage> createState() => _GlobalTestResultPageState();
}

class _GlobalTestResultPageState extends State<GlobalTestResultPage> {
  late double scoreGlobal;

  @override
  void initState() {
    super.initState();
    scoreGlobal = _calculateGlobalScore();
  }


  double _calculateGlobalScore() {
    // Récupère tous les scores sous forme double
    final imc_Score = imcScore(widget.imc).toDouble();
    final questionnaireScore = widget.scoreQuestionnaire.toDouble();

    // Moyenne des scores moyens (endurance, force, etc)
    final scores = widget.scoresMoyens.values.map((e) => e.toDouble()).toList();
    double moyenneScoresMoyens = 0;
    if (scores.isNotEmpty) {
      moyenneScoresMoyens = scores.reduce((a, b) => a + b) / scores.length;
    }

    // Calcul de la moyenne globale sur 3 valeurs
    return (imc_Score + questionnaireScore + moyenneScoresMoyens) / 3;
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
            Text(
              'Score global : ${scoreGlobal.toStringAsFixed(1)} / 5',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 100),
            PolygonChartSection(
              imc: widget.imc,
              scoreQuestionnaire: widget.scoreQuestionnaire,
              scoresMoyens: widget.scoresMoyens,
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
                onPressed: () {
                  // Téléchargement ou autre action
                  print(widget.scoresMoyens);
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
