import 'package:flutter/material.dart';

class ProgressionWidget extends StatelessWidget {
  final double progression; // Entre 0.0 et 1.0
  final bool showButton;
  final VoidCallback onVoirResultat;

  const ProgressionWidget({
    super.key,
    required this.progression,
    required this.showButton,
    required this.onVoirResultat,
  });

  @override
  Widget build(BuildContext context) {
    final int percentage = (progression * 100).round();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 📝 Texte "Progression" + bouton
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Progression',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (showButton)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton(
                    onPressed: onVoirResultat,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB32C2C),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('Résultat'),
                  ),
                ),
            ],
          ),
          // 🔴 Cercle de progression
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: progression.clamp(0.0, 1.0),
                  strokeWidth: 8,
                  backgroundColor: Colors.black,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFB32C2C),
                  ),
                ),
              ),
              Text(
                "$percentage%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
