import 'package:appli_ap_sante/pages/test_result_page.dart';
import 'package:appli_ap_sante/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomValueSelectorPage extends StatefulWidget {
  const CustomValueSelectorPage({
    super.key,
    required this.pageTitle,
    this.subtitle,
    required this.labelText,
    required this.values,
    this.onSelected, // Ajout du paramètre onSelected
  });
  final String pageTitle, labelText;
  final String? subtitle;
  final List<String> values;
  final Function(String)?
  onSelected; // Fonction qui sera appelée à chaque sélection

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25).copyWith(top: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Text(
                widget.subtitle ?? "",
                style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
            Text(
              widget.labelText,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 21),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.zero,
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
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30)
            .copyWith(bottom: 40, top: 15),
        child: ElevatedButton(
          onPressed: () {
            if (selectedIndex == null) return;
            final selectedValue = widget.values[selectedIndex!];
            if (widget.onSelected != null) {
              widget.onSelected!(selectedValue); 
            }
            Navigator.pop(context, true); // renvoie un booléen au parent
          },
          style: ElevatedButton.styleFrom(
              fixedSize: Size(MediaQuery.sizeOf(context).width * .7, 45)),
          child: const Text('Terminer'),
        ),
      ),
    );
  }
}

