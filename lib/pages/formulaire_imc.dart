import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_screen.dart';

enum Sexe { femme, homme }

class FormulaireImc extends StatefulWidget {
  final String? initialNom;
  final String? initialPrenom;
  final String? initialPoids;
  final String? initialTaille;
  final String? initialage;
  final String? initialSexe;
  final String userId;

  const FormulaireImc({
    Key? key,
    this.initialNom,
    this.initialPrenom,
    this.initialPoids,
    this.initialTaille,
    this.initialage,
    this.initialSexe,
    required this.userId,
  }) : super(key: key);

  @override
  State<FormulaireImc> createState() => _FormulaireImcState();
}

class _FormulaireImcState extends State<FormulaireImc> {
  final Color customRed = const Color(0xFFb01f00);

  // Déclaration des contrôleurs
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _poidsController = TextEditingController();
  final TextEditingController _tailleController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  Sexe _selectedSexe = Sexe.homme;

  @override
  void initState() {
    super.initState();
    _nomController.text = widget.initialNom ?? '';
    _prenomController.text = widget.initialPrenom ?? '';
    _poidsController.text = widget.initialPoids ?? '';
    _tailleController.text = widget.initialTaille ?? '';
    _ageController.text = widget.initialage ?? '';
    if (widget.initialSexe?.toLowerCase() == 'femme') {
      _selectedSexe = Sexe.femme;
    } else if (widget.initialSexe?.toLowerCase() == 'homme') {
      _selectedSexe = Sexe.homme;
    }

  }


  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _poidsController.dispose();
    _tailleController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  BackButton(
                    color: customRed,
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.initialNom != null ? "Modification de Profil" : "Création de Profil",
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
              const SizedBox(height: 30),
              Text("Profil :", style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(child: _buildTextField("Nom", _nomController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField("Prénom", _prenomController)),
                ],
              ),
              const SizedBox(height: 24),
              _buildTextField("Poids (kg)", _poidsController),
              const SizedBox(height: 24),
              _buildTextField("Taille (cm)", _tailleController),
              const SizedBox(height: 24),
              _buildTextField("Âge", _ageController),
              const SizedBox(height: 24),
              Text("Sexe :", style: TextStyle(color: Colors.white, fontSize: 18)),
              Row(
                children: [
                  Radio<Sexe>(
                    value: Sexe.femme,
                    groupValue: _selectedSexe,
                    onChanged: (value) => setState(() => _selectedSexe = value!),
                    activeColor: customRed,
                  ),
                  const Text("Femme", style: TextStyle(color: Colors.white)),
                  const SizedBox(width: 30),
                  Radio<Sexe>(
                    value: Sexe.homme,
                    groupValue: _selectedSexe,
                    onChanged: (value) => setState(() => _selectedSexe = value!),
                    activeColor: customRed,
                  ),
                  const Text("Homme", style: TextStyle(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {


                    Get.to(() => HomeScreen(

                      nom: _nomController.text,
                      prenom: _prenomController.text,
                      poids: _poidsController.text,
                      taille: _tailleController.text,
                      age: _ageController.text,
                      sexe: _selectedSexe == Sexe.femme ? 'Femme' : 'Homme',
                      userId: widget.userId,
                    ));

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customRed,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Valider', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      cursorColor: customRed,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[800],
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: customRed, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
