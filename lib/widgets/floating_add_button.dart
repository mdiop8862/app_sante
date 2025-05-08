import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class FloatingAddButton extends StatelessWidget {
  final VoidCallback onNavigateToResults;
  final VoidCallback onNavigateToProfile;
  final VoidCallback onNavigateToPresentation;

  const FloatingAddButton({
    super.key,
    required this.onNavigateToResults,
    required this.onNavigateToProfile,
    required this.onNavigateToPresentation,
  });

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: const Color(0xFF9E1B21),
      foregroundColor: Colors.white,
      overlayColor: Colors.transparent,
      overlayOpacity: 0.0,

      children: [
        SpeedDialChild(
          child: const Icon(Icons.assessment),
          label: 'Résultats',
          onTap: onNavigateToResults,
          labelStyle: const TextStyle(color: Colors.black , fontWeight: FontWeight.bold),
        ),
        SpeedDialChild(
          child: const Icon(Icons.person),
          label: 'Profil',
          onTap: onNavigateToProfile,
          labelStyle: const TextStyle(color: Colors.black , fontWeight: FontWeight.bold),
        ),
        SpeedDialChild(
          child: const Icon(Icons.info_outline),
          label: 'Présentation',
          onTap: onNavigateToPresentation,
          labelStyle: const TextStyle(color: Colors.black , fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
