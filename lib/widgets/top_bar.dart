// 1. top_bar.dart
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final DateTime selectedDate;

  const TopBar({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final weekdays = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    final days = List.generate(7, (i) => selectedDate.subtract(Duration(days: selectedDate.weekday - 1 - i)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'jeudi, ${selectedDate.day} avril ${selectedDate.year}',
          style: const TextStyle(color: Colors.white54, fontSize: 14),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (i) {
            final isSelected = days[i].day == selectedDate.day;
            return Column(
              children: [
                Text(weekdays[i], style: const TextStyle(color: Colors.white, fontSize: 12)),
                const SizedBox(height: 4),
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF9E1B21) : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    days[i].day.toString(),
                    style: TextStyle(color: isSelected ? Colors.white : Colors.white70),
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
