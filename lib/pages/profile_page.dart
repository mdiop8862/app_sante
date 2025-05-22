import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'formulaire_imc.dart';

class ProfilePage extends StatelessWidget {

  final String userId ;



  const ProfilePage({
    Key? key,
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
              _buildInfoRow('Nom', "Franklin"),
              _buildInfoRow('Prénom', "Jean"),
              _buildInfoRow('Poids', "80 kg"),
              _buildInfoRow('Taille', '185 cm'),
              _buildInfoRow('Âge', "23"),
              _buildInfoRow('Sexe', "Homme"),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => FormulaireImc(
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
