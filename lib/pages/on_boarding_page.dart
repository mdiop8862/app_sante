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
      'Où en es-tu ?',
      'Commence ton parcours bien-être : découvre ton niveau d’activité physique et prends soin de ton corps, pas à pas.',
    ),
    (
      'assets/svg/onboarding_2.svg',
      'Passe à l’action',
      'Ton score te guide vers les bons conseils : activité physique, suivi médical ou séances SUAPS. Tu n’es plus seul·e',
    )
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
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 22, color: AppColor.appWhite),
            ),
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                items[currentPage].$3,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8E8E8E),
                ),
              ),
            ),
            const SizedBox(height: 72),
            ElevatedButton(
              onPressed: () =>
                  currentPage == 0 ? setState(() => currentPage = 1) : Get.offAll(() => const LoginScreen()),
              style: ElevatedButton.styleFrom(fixedSize: Size(MediaQuery.sizeOf(context).width * .7, 45)),
              child: Text(['Suivant', 'Commencer'][currentPage]),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
