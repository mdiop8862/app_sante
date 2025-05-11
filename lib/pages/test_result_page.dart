import 'package:appli_ap_sante/pages/global_test_result_page.dart';
import 'package:appli_ap_sante/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class TestResultPage extends StatefulWidget {
  final int scorequestionnaire;  // Accepter le score ici
  final double imc;

  const TestResultPage({super.key, required this.scorequestionnaire, required this.imc});

  @override
  State<TestResultPage> createState() => _TestResultPageState();
}


class _TestResultPageState extends State<TestResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Résultats')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shrinkWrap: true,
        children: [
          const SizedBox(height: 10),
          ColorsSection(
            showWhen: (p0) => p0.isEven,
            child: SvgPicture.asset('assets/svg/smiley.svg'),
          ),
          const SizedBox(height: 35),
          const Text(
            'Indice de masse Corporelle (IMC)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          Row(
            children: [

              Container(height: 40, width: 40, color: const Color(0xFF2249FF)),
              const SizedBox(width: 18),
              Text('${widget.imc.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Niveau d’activite physique',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          Row(
            children: [

              Container(height: 40, width: 40, color: getColorFromScore(widget.scorequestionnaire)),
              const SizedBox(width: 18),
              Text('${widget.scorequestionnaire}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)), // Afficher le score ici
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            'Derniers resultats par test de forme physique',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 25),
          const Text('Endurance', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          const SizedBox(height: 25),
          const Text('Force', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          const SizedBox(height: 25),
          const Text('Equilibre', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          const SizedBox(height: 25),
          const Text('Souplesse', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          const Divider(height: 50),
          Row(
            children: [
              const Text('Sit and Reach',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF8E8E8E))),
              const SizedBox(width: 10),
              Expanded(
                child: ColorsSection(
                  child: const Icon(Icons.check),
                  showWhen: (p0) => p0 == 1,
                ),
              ),
              const SizedBox(width: 10),
              const Text('14', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            ],
          )
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 30),
            child: IconButton(
              onPressed: () => Get.to(() => const GlobalTestResultPage()),
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
            child: LayoutBuilder(
              builder: (context, c2) {
                return Container(
                  padding: const EdgeInsets.all(3),
                  width: c2.maxWidth,
                  height: 40,
                  color: Color(colors[index]),
                  child: showWhen?.call(index) == true ? child : null,
                );
              },
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
      return Colors.grey; // Par défaut si score non valide
  }
}
