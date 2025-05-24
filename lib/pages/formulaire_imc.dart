import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_screen.dart';
import '../utils/FirebaseManagement.dart';

enum Sexe { femme, homme }

class FormulaireImc extends StatefulWidget {
  final String? initialPoids;
  final String? initialTaille;
  final String? initialage;
  final String? initialSexe;
  final String? initialFaculte;
  final String userId;

  const FormulaireImc({
    Key? key,
    this.initialPoids,
    this.initialTaille,
    this.initialage,
    this.initialSexe,
    this.initialFaculte,
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
  String? _selectedFaculte;

  final List<String> _facultes = [
    'FST',
    'FAC de medecine',
    'Fac de pharmacie',
    'FLSH',
    'FDSE',
    'IUT',
    'ILFOMER',
    'IAE',
    'IPAG',
    'INSPE',
    'ENSIL-ENSCI',
    'IFSI',
    'IRFSS',
  ];

  @override
  void initState() {
    super.initState();
    _poidsController.text = widget.initialPoids ?? '';
    _tailleController.text = widget.initialTaille ?? '';
    _ageController.text = widget.initialage ?? '';
    if (widget.initialSexe?.toLowerCase() == 'femme') {
      _selectedSexe = Sexe.femme;
    }
    _selectedFaculte = widget.initialFaculte;
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
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Création de Profil",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: "Poids (kg)",
                        controller: _poidsController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          final poids = double.tryParse(value ?? '');
                          if (poids == null || poids <= 0) return "Poids invalide";
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        label: "Taille (cm)",
                        controller: _tailleController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          final taille = double.tryParse(value ?? '');
                          if (taille == null || taille <= 0) return "Taille invalide";
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                _buildTextField(
                  label: "Âge",
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final age = int.tryParse(value ?? '');
                    if (age == null || age <= 0 || age > 120) return "Âge invalide";
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                DropdownButtonFormField<String>(
                  value: _selectedFaculte,
                  dropdownColor: Colors.grey[900],
                  style: const TextStyle(color: Colors.white),
                  iconEnabledColor: customRed,
                  decoration: _inputDecoration("Faculté"),
                  items: _facultes.map((faculte) {
                    return DropdownMenuItem(
                      value: faculte,
                      child: Text(faculte),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedFaculte = value),
                  validator: (value) =>
                  value == null ? 'Faculté requise' : null,
                ),
                const SizedBox(height: 24),

                const Text("Sexe", style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Radio<Sexe>(
                            value: Sexe.femme,
                            groupValue: _selectedSexe,
                            onChanged: (value) => setState(() => _selectedSexe = value!),
                            activeColor: customRed,
                          ),
                          const Text("Femme", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Radio<Sexe>(
                            value: Sexe.homme,
                            groupValue: _selectedSexe,
                            onChanged: (value) => setState(() => _selectedSexe = value!),
                            activeColor: customRed,
                          ),
                          const Text("Homme", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final poids = double.parse(_poidsController.text);
                        final taille = double.parse(_tailleController.text);
                        final age = int.parse(_ageController.text);
                        final sexe = _selectedSexe == Sexe.femme ? 'femme' : 'homme';
                        final faculte = _selectedFaculte ?? '';

                        final success = await saveUserProfile(
                          userId: widget.userId,
                          poids: poids,
                          taille: taille,
                          age: age,
                          sexe: sexe,
                          faculte: faculte,
                        );

                        if (success) {
                          Get.to(() => HomeScreen(userId: widget.userId));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Erreur lors de l'enregistrement")),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customRed,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text("Valider", style: TextStyle(color: Colors.white)),
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[800],
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: customRed, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
      decoration: _inputDecoration(label),
    );
  }
}
