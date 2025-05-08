import 'package:flutter/material.dart';

class ExpandableTestCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final List<String> exercises;
  final List<bool> isCompleted;
  final Function(String)? onExerciseTap;

  const ExpandableTestCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.exercises,
    required this.isCompleted,
    this.onExerciseTap,
  });

  @override
  State<ExpandableTestCard> createState() => _ExpandableTestCardState();
}

class _ExpandableTestCardState extends State<ExpandableTestCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Image
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 69,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset(widget.imagePath),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Texte
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 6),
                      Text(widget.subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 13.5,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Dropdown
        if (_isExpanded)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: List.generate(widget.exercises.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: GestureDetector(
                    onTap: () {
                      if (widget.onExerciseTap != null) {
                        widget.onExerciseTap!(widget.exercises[index]);
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Icon validation
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: widget.isCompleted[index]
                                ? Colors.red
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.isCompleted[index]
                                ? Icons.check
                                : Icons.radio_button_unchecked,
                            size: 16,
                            color: widget.isCompleted[index]
                                ? Colors.white
                                : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Label
                        Expanded(
                          child: Text(
                            widget.exercises[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        const Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

        const SizedBox(height: 13.5),
      ],
    );
  }
}
