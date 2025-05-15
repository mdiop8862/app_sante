import 'package:appli_ap_sante/utils/colors.dart';
import 'package:appli_ap_sante/utils/score_calculator.dart';
import 'package:appli_ap_sante/utils/FirebaseManagement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class TestResultPage extends StatefulWidget {
  final int scorequestionnaire;
  final double imc;
  final String userId;

  const TestResultPage({
    super.key,
    required this.scorequestionnaire,
    required this.imc,
    required this.userId,
  });

  @override
  State<TestResultPage> createState() => _TestResultPageState();
}

class _TestResultPageState extends State<TestResultPage> {
  Map<String, Map<String, dynamic>> testResults = {};
  String sexe = '';
  int age = 0;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final result = await getUserTestData(widget.userId);
    if (result.isEmpty) return;

    setState(() {
      sexe = result['sexe'] ?? '';
      age = int.tryParse('${result['age']}') ?? 0;
      testResults = Map<String, Map<String, dynamic>>.from(result['tests']);
    });
  }

  Widget _buildTestScore(String label, int score, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFF8E8E8E))),
            const SizedBox(width: 10),
            Expanded(
              child: ColorsSection(
                child: const Icon(Icons.check, color: Colors.white),
                showWhen: (index) => index == (score - 1),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '$score',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }


  List<Widget> buildCategoryWidgets(String title, List<Widget> children) {
    if (children.isEmpty) return [Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18))];
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

    final enduranceWidgets = <Widget>[];
    if (endurance != null) {
      final marche = int.tryParse('${endurance['test_de_marche__6_minutes']?['Test de marche – 6 minutes']}');
      if (marche != null) {
        final score = calculScoreMarche6Min(sexe: sexe, age: age, distance: marche);
        enduranceWidgets.add(_buildTestScore("6 min walk", score, marche.toString()));
      }
      final montee = int.tryParse('${endurance['test_de_la_montée_de_marche']?['Test de la montée de marche']}');
      if (montee != null) {
        final score = calculScoreMonteeMarche(sexe: sexe, age: age, bpm: montee);
        enduranceWidgets.add(_buildTestScore("Step Test", score, montee.toString()));
      }
    }

    final forceWidgets = <Widget>[];
    if (force != null) {
      final assis = int.tryParse('${force['test_du_assis-debout_-_30_sec']?['Test du assis-debout - 30 sec']}');
      print(assis) ;
      if (assis != null) {
        final score = calculerScoreTestAssisDebout(age: age, sexe: sexe, repetitions: assis);
        forceWidgets.add(_buildTestScore("Assis-Debout", score, assis.toString()));
      }
      final chaise = int.tryParse('${force['test_de_la_chaise']?['Test de la chaise']}');
      if (chaise != null) {
        final score = calculerScoreTestChaise(chaise);
        forceWidgets.add(_buildTestScore("Test de la chaise", score, chaise.toString()));
      }
    }

    final souplesseWidgets = <Widget>[];
    if (souplesse != null) {
      final flexo = int.tryParse('${souplesse['test_de_flexomètre']?['Test de Flexomètre']}');
      if (flexo != null) {
        final score = calculScore(sexe, age, flexo);
        souplesseWidgets.add(_buildTestScore("Flexomètre", score, flexo.toString()));
      }
    }

    final equilibreWidgets = <Widget>[];
    if (equilibre != null) {
      final piedDroit = int.tryParse('${equilibre['test_du_flamand_-_pied_droit']?['Test du flamand - pied droit']}');
      final piedGauche = int.tryParse('${equilibre['test_du_flamand_-_pied_gauche']?['Test du flamand - pied gauche']}');
      if (piedDroit != null && piedGauche != null) {
        final moyenneTemps = ((piedDroit + piedGauche) / 2).round();
        // fake score en attendant
        final  score = 2 ;
        equilibreWidgets.add(_buildTestScore("Test du flamand", score, '$moyenneTemps s'));
      }
    }






    return Scaffold(
      appBar: AppBar(title: const Text('Résultats')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 10),
          ColorsSection(
            showWhen: (index) => index == widget.scorequestionnaire - 1,
            child: SvgPicture.asset('assets/svg/smiley.svg'),
          ),
          const SizedBox(height: 30),
          const Text('Indice de masse Corporelle (IMC)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(height: 40, width: 40, color: const Color(0xFF2249FF)),
              const SizedBox(width: 12),
              Text(widget.imc.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 25),
          const Text('Niveau d’activité physique',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(height: 40, width: 40, color: getColorFromScore(widget.scorequestionnaire)),
              const SizedBox(width: 12),
              Text('${widget.scorequestionnaire}',
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
          ...buildCategoryWidgets("Equilibre", equilibreWidgets),
        ],
      ),
    );
  }
}

class ColorsSection extends StatelessWidget {
  const ColorsSection({super.key, this.child, this.showWhen});
  final Widget? child;
  final bool Function(int)? showWhen;

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
              padding: const EdgeInsets.all(3),
              height: 40,
              color: Color(colors[index]),
              child: showWhen?.call(index) == true ? child : null,
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
      return Colors.blue;
    default:
      return Colors.grey;
  }
}
