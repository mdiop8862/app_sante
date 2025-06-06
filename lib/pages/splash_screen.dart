import 'package:appli_ap_sante/pages/on_boarding_page.dart';
import 'package:appli_ap_sante/utils/colors.dart';
import 'package:appli_ap_sante/widgets/app_loader.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(3.seconds, () => Get.offAll(() => const OnBoardingScreen()));
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Center(
              child: Image.asset('assets/images/university.png', width: Get.width / 2),
            ),
            Positioned(
              bottom: Get.height / 10,
              right: 0,
              left: 0,
              child: const AppLoader(height: 40, color: AppColor.primaryColor),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.7,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Inspiré par',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Image.asset(
                      'assets/images/tous_en_forme.png',
                      width: 120,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
