import 'package:appli_ap_sante/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/FirebaseManagement.dart';
import '../utils/automatiqueDetection.dart';

class CustomValueSelectorPage extends StatefulWidget {
  final String pageTitle, labelText;
  final String? subtitle;
  final List<String> values;
  final Function(String)? onSelected;
  final String userId; // 👈 Ajouté

  const CustomValueSelectorPage({
    super.key,
    required this.pageTitle,
    this.subtitle,
    required this.labelText,
    required this.values,
    this.onSelected,
    required this.userId, // 👈 requis
  });

  @override
  State<CustomValueSelectorPage> createState() =>
      _CustomValueSelectorPageState();
}

class _CustomValueSelectorPageState extends State<CustomValueSelectorPage> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.pageTitle)),
      body:
      Column(
          children: [
            const SizedBox(height: 20), // ✅ espace entre AppBar et contenu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.subtitle != null)
                    Text(
                      widget.subtitle!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        color: Color(0xFFAAAAAA), // gris doux
                      ),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    widget.labelText,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),


            const SizedBox(height: 16),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                separatorBuilder: (context, index) =>
                const SizedBox(height: 35),
                itemCount: widget.values.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() => selectedIndex == index
                        ? selectedIndex = null
                        : selectedIndex = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColor.primaryColor
                            : const Color(0xFF111111),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.values[index],
                        style: TextStyle(
                          color: isSelected
                              ? AppColor.appWhite
                              : const Color(0xFF8E8E8E),
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30)
            .copyWith(bottom: 40, top: 15),
        child: ElevatedButton(
          onPressed: () async {
            if (selectedIndex == null) return;

            final selectedValue = widget.values[selectedIndex!];

            // 🔁 Enregistrement Firestore
            final category = detectCategory(widget.pageTitle);
            final testKey = normalizeTestKey(widget.labelText);

            await saveFormDataToUserDoc(
              userId: widget.userId,
              category: category,
              testKey: testKey,
              data: {"reponse": selectedValue},
            );

            if (widget.onSelected != null) {
              widget.onSelected!(selectedValue);
            }

            Navigator.pop(context, true);
          },
          style: ElevatedButton.styleFrom(
              fixedSize: Size(MediaQuery.sizeOf(context).width * .7, 45)),
          child: const Text('Terminer'),
        ),
      ),
    );
  }
}
