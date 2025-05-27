import 'package:appli_ap_sante/pages/login_page.dart';
import 'package:appli_ap_sante/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late int currentPage = 0;
  final isLoading = false.obs;
  final googleLoading = false.obs;
  final items = [
    (
    'assets/svg/onboarding_1.svg',
    ' L’Université de Limoges s’engage pour votre réussite',
    'Parce que votre santé est importante pour votre épanouissement, l’Université de Limoges vous accompagne et vous propose de tester votre condition physique, sans enjeu de performance, juste pour savoir où vous en êtes.',
    ),

    (
    'assets/svg/onboarding_2.svg',
    'Un accompagnement personnalisé',
    'En fonction de vos résultats, vous pourrez être mis en relation avec le SSE, orienté vers une activité adaptée, ou les activités du SUAPS. '
        'Ce dispositif, inspiré de TOUS EN FORME de l’Université Paris Cité, vous permet de faire le premier pas.',
    ),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: SvgPicture.asset(items[currentPage].$1)),
            const SizedBox(height: 30),
            Text(
              items[currentPage].$2,
              textAlign: TextAlign.center,  // ← ajouté ici
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: AppColor.appWhite,
              ),
            ),
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                items[currentPage].$3,
                textAlign: TextAlign.center,  // ← et ici
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8E8E8E),
                ),
              ),
            ),
            const SizedBox(height: 72),
            ElevatedButton(
              onPressed: () => currentPage == 0
                  ? setState(() => currentPage = 1)
                  : Get.offAll(() => const LoginScreen()),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.sizeOf(context).width * .7, 45),
              ),
              child: Text(['Suivant', 'Commencer'][currentPage]),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

}
