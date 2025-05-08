import 'package:appli_ap_sante/pages/custom_value_selector_page.dart';
import 'package:appli_ap_sante/utils/colors.dart';
import 'package:appli_ap_sante/pages/form_builder_page.dart';
import 'package:appli_ap_sante/widgets/questionnaire_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? selectedIndex;
  @override
  Widget build(BuildContext context) {
    List<Category> categories = [
      Category(
        title: 'Endurance',
        subtitle: '1 exercice cardio à réaliser',
        image: 'assets/images/endurance.jpeg',
        actions: [
          (
            'Test de marche - 6mn',
            () => Get.to(
                  () => CustomFormBuilderPage(
                    title: 'Test d’endurance',
                    formFields: [
                      CustomFormField(
                        title: 'Test de marche – 6 minutes',
                        labelText: 'Longueur parcourue',
                        hintText: 'm',
                      ),
                    ],
                  ),
                ),
          ),
          (
            'Test de la montée de marche',
            () => Get.to(
                  () => CustomFormBuilderPage(
                    title: 'Test d’endurance',
                    formFields: [
                      CustomFormField(
                        title: 'Test de la montée de marche',
                        labelText: 'Fréquence cardiaque',
                        hintText: 'bpm',
                      ),
                    ],
                  ),
                ),
          ),
        ],
      ),
      Category(
        title: 'Force',
        subtitle: 'Tests de force musculaire',
        image: 'assets/images/force2.jpg',
        actions: [
          (
            'Test de handgrip',
            () => Get.to(
                  () => CustomFormBuilderPage(
                    title: 'Test de force',
                    formFields: [
                      CustomFormField(
                        title: 'Test de handgrip - main droite',
                        labelText: 'Force maximale',
                        hintText: 'Kg',
                      ),
                      CustomFormField(
                        title: 'Test de handgrip - main gauche',
                        labelText: 'Force maximale',
                        hintText: 'Kg',
                      ),
                    ],
                  ),
                ),
          ),
          (
            'Test de la chaise ',
            () => Get.to(
                  () => CustomFormBuilderPage(
                    title: 'Test de force',
                    formFields: [
                      CustomFormField(
                        title: 'Test de la chaise',
                        labelText: 'Nombre de secondes',
                        hintText: 'sec',
                      ),
                    ],
                  ),
                ),
          ),
          (
            'Test assis-debout - 30 sec',
            () => Get.to(
                  () => CustomFormBuilderPage(
                    title: 'Test de force',
                    formFields: [
                      CustomFormField(
                        title: 'Test assis-debout - 30 sec',
                        labelText: 'Nombre de repetitions',
                      ),
                    ],
                  ),
                ),
          ),
        ],
      ),
      Category(
        title: 'Équilibre',
        subtitle: 'Test unipodal simple',
        image: 'assets/images/equilibre.jpg',
        actions: [
          (
            'Test du flamand',
            () => Get.to(
                  () => CustomFormBuilderPage(
                    title: 'Test d’équilibre',
                    subtitle: 'Placer les mains sur les hanches',
                    formFields: [
                      CustomFormField(
                        title: 'Test du flamand - pied droite',
                        labelText: 'Nombre de secondes',
                        hintText: 'sec',
                      ),
                      CustomFormField(
                        title: 'Test du flamand - pied gauche',
                        labelText: 'Nombre de secondes',
                        hintText: 'sec',
                      ),
                    ],
                  ),
                ),
          )
        ],
      ),
      Category(
        title: 'Souplesse',
        subtitle: '3 tests à compléter',
        image: 'assets/images/akram-huseyn-ZJzCO-un8dI-unsplash.jpg',
        actions: [
          (
            'Test de sit and reach ',
            () => Get.to(
                  () => CustomFormBuilderPage(
                    title: 'Test de souplesse',
                    formFields: [
                      CustomFormField(
                        title: 'Test de sit and reach ',
                        labelText: 'Distance atteinte',
                        hintText: 'cm',
                      ),
                    ],
                  ),
                ),
          ),
          (
            'Main / pied ',
            () => Get.to(
                  () => const CustomValueSelectorPage(
                    pageTitle: 'Test de souplesse',
                    labelText: 'Quelle est la position de tes mains ?',
                    values: [
                      'Les mains sur les cuisses',
                      'Les mains sur les genoux',
                      'Les mains sur les tibias',
                      'Les mains sur les chevilles'
                    ],
                  ),
                )
          ),
          (
            'Test de l\'épaule',
            () => Get.to(
                  () => const CustomValueSelectorPage(
                    pageTitle: 'Test de souplesse',
                    labelText: 'Où tes mains se touchent elles ?',
                    values: [
                      'Je ne parviens pas a mettre les deux mains dans le dos',
                      'Mes deux mains dans le dos ne se touchent pas',
                      'Les bouts des deux doigts se touchent ',
                      'Les mains parviennent a se superposer'
                    ],
                  ),
                )
          ),
        ],
      ),
    ];
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                DateFormat('EEEE, dd MMMM yyyy', 'fr')
                        .format(now)
                        .capitalizeFirst ??
                    '',
                style: const TextStyle(color: Color(0xFF8E8E8E)),
              ),
              const SizedBox(height: 10),
              GridView(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisExtent: 40,
                  crossAxisSpacing: 10,
                ),
                shrinkWrap: true,
                children: [
                  ...List.generate(
                    7,
                    (index) => Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        [
                          "Lun",
                          "Mar",
                          "Mer",
                          "Jeu",
                          "Ven",
                          "Sam",
                          "Dim"
                        ][index],
                        style: const TextStyle(
                          color: Color(0xFF8E8E8E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  ...List.generate(
                    7,
                    (index) {
                      final isSelected = now.weekday == index + 1;
                      return Container(
                        decoration: BoxDecoration(
                          color: isSelected ? AppColor.primaryColor : null,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.only(left: isSelected ? 0 : 2),
                        child: Align(
                          alignment: isSelected
                              ? Alignment.center
                              : Alignment.centerLeft,
                          child: Text(
                            startOfWeek
                                .add(Duration(days: index))
                                .day
                                .toString()
                                .padLeft(2, '0'),
                            style: TextStyle(
                              color: isSelected
                                  ? AppColor.appWhite
                                  : const Color(0xFF8E8E8E),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 35),
              Container(
                height: 145,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('IMC',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20)),
                        SizedBox(height: 10),
                        Text('22,8',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 28)),
                        SizedBox(height: 18),
                        Text(
                          'Catégorie : Surpoids',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 12),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        SizedBox.square(
                          dimension: 100,
                          child: CircularProgressIndicator(
                            value: .7,
                            color: AppColor.primaryColor,
                            backgroundColor: Colors.black,
                            strokeWidth: 12,
                          ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: Text(
                              'Élevé',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 20),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                  itemCount: categories.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) return const QuestionnaireCard();
                    final widgets = [
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                categories[index - 1].title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 20),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: Text(
                                  categories[index - 1].subtitle,
                                  maxLines: 2,
                                  style:
                                      const TextStyle(color: Color(0xFF8E8E8E)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 5,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          child: Image.asset(
                            categories[index - 1].image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => setState(() => selectedIndex == index - 1
                              ? selectedIndex = null
                              : selectedIndex = index - 1),
                          child: Container(
                            height: 100,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFF111111),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: index.isOdd
                                  ? widgets.reversed.toList()
                                  : widgets,
                            ),
                          ),
                        ),
                        if (selectedIndex == index - 1) ...[
                          ...categories[index - 1].actions.map(
                                (e) => GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: e.$2,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                            horizontal: 20)
                                        .copyWith(top: 10),
                                    child: Row(
                                      children: [
                                        const Icon(CupertinoIcons.check_mark,
                                            size: 15),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Text(e.$1,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        const SizedBox(width: 15),
                                        const Icon(CupertinoIcons.right_chevron,
                                            size: 15),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        ]
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Category {
  final String title;
  final String image;
  final String subtitle;
  final List<(String, VoidCallback?)> actions;
  Category(
      {required this.title,
      required this.image,
      required this.subtitle,
      List<(String, VoidCallback?)>? actions})
      : actions = actions ?? [];
}
