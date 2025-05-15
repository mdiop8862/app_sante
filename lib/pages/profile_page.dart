import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'formulaire_imc.dart';

class ProfilePage extends StatelessWidget {
  final String nom;
  final String prenom;
  final String poids;
  final String taille;
  final String age;
  final String sexe;
  final String userId ;



  const ProfilePage({
    Key? key,
    required this.nom,
    required this.prenom,
    required this.poids,
    required this.taille,
    required this.age,
    required this.sexe,
    required this.userId ,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFb01f00);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Mon Profil', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Nom', nom),
              _buildInfoRow('Prénom', prenom),
              _buildInfoRow('Poids', '$poids kg'),
              _buildInfoRow('Taille', '$taille cm'),
              _buildInfoRow('Âge', age),
              _buildInfoRow('Sexe', sexe),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => FormulaireImc(
                      initialNom: nom,
                      initialPrenom: prenom,
                      initialPoids: poids,
                      initialTaille: taille,
                      initialage: age,
                      initialSexe: sexe,
                        userId: userId

                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text('Modifier', style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        '$label : $value',
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
