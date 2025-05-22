import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_screen.dart';

enum Sexe { femme, homme }

class FormulaireImc extends StatefulWidget {
  final String? initialPoids;
  final String? initialTaille;
  final String? initialage;
  final String? initialSexe;
  final String userId;

  const FormulaireImc({
    Key? key,
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
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _poidsController = TextEditingController();
  final TextEditingController _tailleController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  Sexe _selectedSexe = Sexe.homme;

  @override
  void initState() {
    super.initState();
    _poidsController.text = widget.initialPoids ?? '';
    _tailleController.text = widget.initialTaille ?? '';
    _ageController.text = widget.initialage ?? '';
    if (widget.initialSexe?.toLowerCase() == 'femme') {
      _selectedSexe = Sexe.femme;
    }
  }

  @override
  void dispose() {
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    BackButton(
                      color: customRed,
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
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
                const SizedBox(height: 30),
                const Text("Profil :", style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 30),
                _buildTextField(
                  label: "Poids (kg)",
                  controller: _poidsController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Poids requis";
                    final poids = double.tryParse(value);
                    if (poids == null || poids <= 0) return "Poids invalide";
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  label: "Taille (cm)",
                  controller: _tailleController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Taille requise";
                    final taille = double.tryParse(value);
                    if (taille == null || taille <= 0) return "Taille invalide";
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  label: "Âge",
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Âge requis";
                    final age = int.tryParse(value);
                    if (age == null || age <= 0 || age > 120) return "Âge invalide";
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const Text("Sexe :", style: TextStyle(color: Colors.white, fontSize: 18)),
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
                      if (_formKey.currentState!.validate()) {
                        Get.to(() => HomeScreen(
                          userId: widget.userId,
                        ));
                      }
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
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      cursorColor: customRed,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[800],
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: customRed, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
