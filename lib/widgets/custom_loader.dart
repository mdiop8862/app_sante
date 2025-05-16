<<<<<<< HEAD
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // fond noir pour s'adapter à l'app
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.primaryColor), // rouge de l’app
              strokeWidth: 4,
            ),
            const SizedBox(height: 20),
            Text(
              message ?? 'Chargement...',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
=======
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // fond noir pour s'adapter à l'app
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.primaryColor), // rouge de l’app
              strokeWidth: 4,
            ),
            const SizedBox(height: 20),
            Text(
              message ?? 'Chargement...',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
>>>>>>> 2d7b1fa (Ajout de score questionnaire sur firestore et affichage des scores sur le graphe)
}