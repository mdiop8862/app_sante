import 'package:appli_ap_sante/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'global_test_result_page.dart';


enum Sexe { femme, homme }

class FormulaireImc extends StatefulWidget {
  const FormulaireImc({super.key});

  @override
  State<FormulaireImc> createState() => _FormulaireImcState();
}

class _FormulaireImcState extends State<FormulaireImc> {
  final Color customRed = const Color(0xFFb01f00);

  Sexe _selectedSexe = Sexe.femme;
 // Femme par défaut
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barre avec le bouton retour et le titre centré
              Row(
                children: [
                  BackButton(
                    color: customRed,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Création de Profil",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                child: Text(
                  "Profil :",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),

              SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                child: TextField(
                  cursorColor: customRed,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800],
                    labelText: "Poids(kg)",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                child: TextField(
                  cursorColor: customRed,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800],
                    labelText: "Taille(cm)",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
                child: TextField(
                  cursorColor: customRed,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800],
                    labelText: "Année de naissance",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                child: Text(
                  "Sexe :",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<Sexe>(
                    value: Sexe.femme,
                    groupValue: _selectedSexe,
                    onChanged: (Sexe? value) {
                      setState(() {
                        _selectedSexe = value!;
                      });
                    },
                    activeColor: customRed,
                  ),
                  const Text(
                    'Femme',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 30),
                  Radio<Sexe>(
                    value: Sexe.homme,
                    groupValue: _selectedSexe,
                    onChanged: (Sexe? value) {
                      setState(() {
                        _selectedSexe = value!;
                      });
                    },
                    activeColor: customRed,
                  ),
                  const Text(
                    'Homme',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const HomePage());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customRed,
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    elevation: 5,
                  ),
                  child: Text('Valider', style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
