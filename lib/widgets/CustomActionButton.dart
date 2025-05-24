import 'package:flutter/material.dart';


class CustomActionButton extends StatelessWidget {
  final Function(String) onActionSelected;

  const CustomActionButton({super.key, required this.onActionSelected});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.redAccent,
      child: const Icon(Icons.menu, color: Colors.white), // hamburger icon
      onPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.black87,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionItem(context, Icons.person, 'Profils'),
                _buildActionItem(context, Icons.bar_chart, 'Résultats'),
                _buildActionItem(context, Icons.info, 'Présentation du projet'),
                _buildActionItem(context, Icons.logout, 'Déconnexion'),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildActionItem(
      BuildContext context, IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context); // Ferme le menu
        onActionSelected(label);
      },
    );
  }
}
