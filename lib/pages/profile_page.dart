import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'formulaire_imc.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? nom;
  String? prenom;
  String? poids;
  String? taille;
  String? age;
  String? sexe;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
      if (doc.exists) {
        final data = doc.data();
        setState(() {
          nom = data?['nom'] ?? 'N/A';
          prenom = data?['prenom'] ?? 'N/A';
          poids = data?['poids']?.toString() ?? 'N/A';
          taille = data?['taille']?.toString() ?? 'N/A';
          age = data?['age']?.toString() ?? 'N/A';
          sexe = data?['sexe'] ?? 'N/A';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Erreur de récupération du profil : $e');
    }
  }

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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
              _buildInfoRow('Nom', nom ?? ''),
              _buildInfoRow('Prénom', prenom ?? ''),
              _buildInfoRow('Poids', '$poids kg'),
              _buildInfoRow('Taille', '$taille cm'),
              _buildInfoRow('Âge', age ?? ''),
              _buildInfoRow('Sexe', sexe ?? ''),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => FormulaireImc(userId: widget.userId, isEditing: true));
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
