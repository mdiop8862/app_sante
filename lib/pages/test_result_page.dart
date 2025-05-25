import 'package:appli_ap_sante/utils/Score_calculator.dart';
import 'package:appli_ap_sante/utils/colors.dart';
import 'package:appli_ap_sante/utils/FirebaseManagement.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:appli_ap_sante/pages/global_test_result_page.dart';

class TestResultPage extends StatefulWidget {
  final String userId;

  const TestResultPage({super.key, required this.userId});

  @override
  State<TestResultPage> createState() => _TestResultPageState();
}

class _TestResultPageState extends State<TestResultPage> {
  Map<String, List<int>> moyenneScores = {};

  Map<String, Map<String, dynamic>> testResults = {};
  String sexe = '';
  int age = 0;
  double poids = 0;
  double taille = 0;
  int scoreQuestionnaire = 0;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  double moyenneScore(List<int> scores) {
    if (scores.isEmpty) return 0;
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  double get imcValue {
    double t = taille / 100; // cm -> m
    if (t <= 0 || poids <= 0) return 0;
    return poids / (t * t);
  }

  Future<void> fetchUserData() async {
    final result = await getUserTestData(widget.userId);
    if (result.isEmpty) return;

    setState(() {
      sexe = result['sexe'] ?? '';
      age = int.tryParse('${result['age']}') ?? 0;
      taille = double.tryParse('${result['taille']}') ?? 0;
      poids = double.tryParse('${result['poids']}') ?? 0;
      testResults = Map<String, Map<String, dynamic>>.from(result['tests'] ?? {});
      scoreQuestionnaire = result['scoreQuestionnaire'] ?? 0;
    });
  }
  Widget _buildTestScore(String label, int score, String value) {
    final colors = [0xFFE00808, 0xFFFE5200, 0xFFFFD102, 0xFF02952A, 0xFF2249FF];
    const spaceBetween = 0.1;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Color(0xFF8E8E8E),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // On retire l'espace total entre les 5 cases (4 espaces)
                final totalSpacing = spaceBetween * 4;
                final boxSize = (constraints.maxWidth - totalSpacing) / 5;
                return Row(
                  children: List.generate(5, (index) {
                    return Container(
                      width: boxSize,
                      height: boxSize,
                      margin: EdgeInsets.only(
                        right: index < 4 ? spaceBetween : 0,
                      ),
                      decoration: BoxDecoration(
                        color: Color(colors[index]),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: index == score - 1
                          ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.4),
                        ),
                        child: Icon(Icons.check, size: boxSize * 0.9, color: Colors.white),
                      )
                          : null,

                    );
                  }),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$score',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }



  List<Widget> buildCategoryWidgets(String title, List<Widget> children) {
    if (children.isEmpty) return [];
    return [
      Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
      const Divider(height: 50),
      ...children
    ];
  }

  @override
  Widget build(BuildContext context) {
    final endurance = testResults['endurance'];
    final force = testResults['force'];
    final souplesse = testResults['souplesse'];
    final equilibre = testResults['equilibre'];

    final enduranceScores = <int>[];
    final forceScores = <int>[];
    final equilibreScores = <int>[];
    final souplesseScores = <int>[];

    final enduranceWidgets = <Widget>[];
    if (endurance != null) {
      final marche = int.tryParse('${endurance['test_de_marche__6_minutes']?['Test de marche – 6 minutes']}');
      if (marche != null) {
        final score = calculScoreMarche6Min(sexe: sexe, age: age, distance: marche); //
        enduranceWidgets.add(_buildTestScore("6 min walk", score, marche.toString()));
        enduranceScores.add(score);
      }

      final montee = int.tryParse('${endurance['test_de_la_montée_de_marche']?['Test de la montée de marche']}');
      if (montee != null) {
        final score = calculScoreMonteeMarche(sexe: sexe, age: age, bpm: montee);
        enduranceWidgets.add(_buildTestScore("Step Test", score, montee.toString()));
        enduranceScores.add(score);
      }
      if (enduranceScores.isNotEmpty) {
        moyenneScores['endurance'] = enduranceScores;
      }
    }

    final forceWidgets = <Widget>[];
    if (force != null) {
      final assis = int.tryParse('${force['test_du_assis-debout_-_30_sec']?['Test du assis-debout - 30 sec']}');
      if (assis != null) {
        final score = calculerScoreTestAssisDebout(age: age, sexe: sexe, repetitions: assis);
        forceWidgets.add(_buildTestScore("Assis-Debout", score, assis.toString()));
        forceScores.add(score);
      }

      final chaise = int.tryParse('${force['test_de_la_chaise']?['Test de la chaise']}');
      if (chaise != null) {
        final score = calculerScoreTestChaise(chaise);
        forceWidgets.add(_buildTestScore("Test de la chaise", score, chaise.toString()));
        forceScores.add(score);
      }
      if (forceScores.isNotEmpty) {
        moyenneScores['force'] = forceScores;
      }
    }

    final souplesseWidgets = <Widget>[];
    if (souplesse != null) {
      final flexo = int.tryParse('${souplesse['test_de_flexomètre']?['Test de Flexomètre']}');
      final mainPied = '${souplesse['quelle_est_la_position_de_tes_mains_?']?['reponse']}';
      final epaule = '${souplesse['où_tes_mains_se_touchent-elles_?']?['reponse']}';

      if (flexo != null) {
        final score = calculScore(sexe, age, flexo);
        souplesseWidgets.add(_buildTestScore("Flexomètre", score, flexo.toString()));
        souplesseScores.add(score);
      }

      if (mainPied.isNotEmpty) {
        const positions = {
          1: 'Les mains sur les cuisses',
          2: 'Les mains sur les genoux',
          3: 'Les mains sur les tibias',
          4: 'Les mains sur les chevilles',
          5: 'La paume de la main touche le sol',
        };
        final key = positions.entries
            .firstWhere((entry) => entry.value == mainPied, orElse: () => const MapEntry(-1, ''))
            .key;
        souplesseWidgets.add(_buildTestScore("Main/Pied", key, mainPied));
        souplesseScores.add(key);
      }

      if (epaule.isNotEmpty) {
        const positions = {
          1: "Je ne parviens pas à mettre les deux mains dans le dos",
          2: "Mes deux mains dans le dos ne se touchent pas",
          3: "Les bouts des deux doigts se touchent",
          4: "Les doigts s'agrippent",
          5: "Les mains parviennent à se superposer",
        };
        final key = positions.entries
            .firstWhere((entry) => entry.value == epaule, orElse: () => const MapEntry(-1, ''))
            .key;
        souplesseWidgets.add(_buildTestScore("Epaule", key, epaule));
        souplesseScores.add(key);
      }

      if (souplesseScores.isNotEmpty) {
        moyenneScores['souplesse'] = souplesseScores;
      }
    }

    final equilibreWidgets = <Widget>[];
    if (equilibre != null) {
      final piedDroit = int.tryParse('${equilibre['test_du_flamand']?['Test du flamand - pied droit']}');
      final piedGauche = int.tryParse('${equilibre['test_du_flamand']?['Test du flamand - pied gauche']}');
      if (piedDroit != null && piedGauche != null) {
        final note = piedDroit > piedGauche ? piedDroit : piedGauche;
        final score = calculerScoreTestFlamand(age: age, sexe: sexe, secondes: note);
        equilibreWidgets.add(_buildTestScore("Test du flamand", score, '$note s'));
        equilibreScores.add(score);
      }

      if (equilibreScores.isNotEmpty) {
        moyenneScores['equilibre'] = equilibreScores;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Résultats')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 10),
          ColorsSection(
            showWhen: (index) => [0, 2, 4].contains(index),
            childBuilder: (index) {
              switch (index) {
                case 0:
                  return const Icon(Icons.sentiment_very_dissatisfied, color: Colors.black, size: 40);
                case 2:
                  return const Icon(Icons.sentiment_neutral, color: Colors.black, size: 40);
                case 4:
                  return const Icon(Icons.sentiment_very_satisfied, color: Colors.black, size: 40);
                default:
                  return const SizedBox.shrink();
              }
            },
          ),

          const SizedBox(height: 30),
          const Text('Indice de masse Corporelle (IMC)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                color: getColorFromScore(imcScore(imcValue)),
              ),
              const SizedBox(width: 12),
              Text(imcValue.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 25),
          const Text('Niveau d’activité physique',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(height: 40, width: 40, color: getColorFromScore(scoreQuestionnaire)),
              const SizedBox(width: 12),
              Text('$scoreQuestionnaire',
                  style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 30),
          const Text('Derniers résultats par test de forme physique',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 25),
          ...buildCategoryWidgets("Endurance", enduranceWidgets),
          const SizedBox(height: 25),
          ...buildCategoryWidgets("Force", forceWidgets),
          const SizedBox(height: 25),
          ...buildCategoryWidgets("Souplesse", souplesseWidgets),
          const SizedBox(height: 25),
          ...buildCategoryWidgets("Équilibre", equilibreWidgets),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 30),
            child: IconButton(
              onPressed: () => Get.to(() => GlobalTestResultPage(imc: imcValue, scoreQuestionnaire: scoreQuestionnaire, scoresMoyens: moyenneScores,testResults: testResults)),
              icon: Transform.scale(
                scaleX: 2,
                child: const Icon(
                  Icons.arrow_forward,
                  size: 30,
                  color: AppColor.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ColorsSection extends StatelessWidget {
  const ColorsSection({
    super.key,
    this.child,
    this.showWhen,
    this.childBuilder,
  });

  final Widget? child;
  final bool Function(int)? showWhen;
  final Widget Function(int)? childBuilder;

  @override
  Widget build(BuildContext context) {
    final colors = [0xFFE00808, 0xFFFE5200, 0xFFFFD102, 0xFF02952A, 0xFF2249FF];

    return SizedBox(
      height: 40,
      child: Row(
        children: List.generate(
          colors.length,
              (index) => Expanded(
            child: Container(
              color: Color(colors[index]),
              child: Center(
                child: (childBuilder != null && showWhen?.call(index) == true)
                    ? childBuilder!(index)
                    : (showWhen?.call(index) == true ? child : null),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Color getColorFromScore(int score) {
  switch (score) {
    case 1:
      return Colors.red;
    case 2:
      return Colors.orange;
    case 3:
      return Colors.yellow;
    case 4:
      return Colors.green;
    case 5:
      return const Color(0xFF2249FF);
    default:
      return Colors.grey;
  }
}
