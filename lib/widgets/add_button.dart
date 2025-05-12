import 'package:animated_expandable_fab/animated_expandable_fab.dart';
import 'package:appli_ap_sante/utils/colors.dart';
import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final Function(String)? onActionSelected;

  const AddButton({super.key, this.onActionSelected});

  @override
  Widget build(BuildContext context) {
    final titles = ['Profils', 'Résultats', 'Présentation du projet'];
    final icons = [
      Icons.contact_page_sharp,
      Icons.bar_chart_sharp,
      Icons.present_to_all_sharp
    ];

    return ExpandableFab(
      closeBackgroundColor: AppColor.appWhite,
      closeShadowColor: AppColor.primaryColor,
      closeElevation: 5,
      openElevation: 4,
      distance: 100.0,
      closeIcon: const Icon(
        Icons.close,
        color: AppColor.primaryColor,
      ),
      openIcon: const Icon(
        Icons.add,
        color: AppColor.primaryColor,
      ),
      children: List.generate(titles.length, (index) {
        return ActionButton(
          onPressed: () {
            if (onActionSelected != null) {
              onActionSelected!(titles[index]);
            }
          },
          closeFabOnTap: true,
          text: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
            child: Text(
              titles[index],
              style: const TextStyle(
                color: AppColor.appWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          icon: Icon(
            icons[index],
            color: AppColor.appWhite,
          ),
        );
      }),
    );
  }
}
