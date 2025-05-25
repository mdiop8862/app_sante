import 'package:appli_ap_sante/pages/home_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/expandable_test_card.dart';
import "../widgets/progression_card.dart";
import '../widgets/questionnaire_card.dart';
import '../widgets/top_bar.dart';
import 'form_builder_page.dart';
import "custom_value_selector_page.dart";
import '../widgets/add_button.dart';
import 'package:get/get.dart';
import 'profile_page.dart';
import 'test_result_page.dart';
import 'project_presentation.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart'; // adapte le chemin selon ton projet
import '../widgets/CustomActionButton.dart' ;


class HomeScreen extends StatefulWidget {
  final String userId;

  const HomeScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color primaryColor = Color(0xFFb01f00);

  List<List<bool>> allTestsCompletion = [
    [false, false],
    [false, false, false],
    [false],
    [false, false, false],
  ];

  bool questionnaireFait = false;
  int scorequestionnaire = 0;

  double getProgress() {
    int completedSubTests = 0;
    int totalSubTests = 0;
    for (var test in allTestsCompletion) {
      completedSubTests += test.where((subTest) => subTest).length;
      totalSubTests += test.length;
    }
    return completedSubTests / totalSubTests;
  }

  bool checkAllTestsDone() {
    return allTestsCompletion.every((test) => test.every((done) => done)) &&
        questionnaireFait;
  }

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: CustomActionButton(
        onActionSelected: (String action) {
          if (action == 'Profils') {
            Get.to(() => ProfilePage(userId: widget.userId));
          } else if (action == 'Résultats') {
            Get.to(() => TestResultPage(userId: widget.userId));
          } else if (action == 'Présentation du projet') {
            Get.to(() => const PresentationPage());
          } else if (action == 'Déconnexion') {
            _showLogoutConfirmation(context);
          }
        },
      ),


      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBar(selectedDate: today),
              const SizedBox(height: 24),
              ProgressionWidget(
                progression: getProgress(),
                showButton: checkAllTestsDone(),
                onVoirResultat: () {
                  Get.to(() => TestResultPage(userId: widget.userId));
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    QuestionnaireCard(
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          '/questionnaire',
                          arguments: widget.userId,
                        );
                        if (result is Map) {
                          final int? score = result['scoreGlobal'];
                          final bool? questionnaire = result['fait'];
                          if (score != null && questionnaire == true) {
                            setState(() {
                              questionnaireFait = true;
                              scorequestionnaire = score;
                            });
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    // ... (Les cartes de tests que tu avais déjà sont inchangées ici)

                    ExpandableTestCard(
                      title: 'Endurance',
                      subtitle: '1 exercice cardio à réaliser',
                      imagePath: 'assets/images/endurance.jpeg',
                      exercises: const ['Test de marche – 6mn', 'Montée de marche'],
                      isCompleted: allTestsCompletion[0],
                      onExerciseTap: (exerciseName) {
                        if (exerciseName.contains('Test de marche')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CustomFormBuilderPage(
                                userId: widget.userId,
                                title: "Test d’endurance",
                                subtitle: "Procédure : parcourir en marchant le plus de mètres en 6 minutes",
                                formFields: [
                                  CustomFormField(
                                    title: 'Test de marche – 6 minutes',
                                    labelText: 'Longueur parcourue',
                                    hintText: 'm',
                                  ),
                                ],
                                onSubmit: (formValues) {
                                  setState(() {
                                    allTestsCompletion[0][0] = true;
                                  });
                                },
                              ),
                            ),
                          );
                        } else if (exerciseName.contains('Montée de marche')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CustomFormBuilderPage(
                                userId: widget.userId,
                                title: "Test d’endurance",
                                subtitle:
                                "Procédure : pendant 3 minutes monter et descendre une marche en 4 temps sur une cadence de 96 bips par minute. A la fin des 3 minutes le sujet s'assoit sur la marche et dispose d'une minute de repos.",
                                formFields: [
                                  CustomFormField(
                                    title: 'Test de la montée de marche',
                                    labelText: 'Fréquence cardiaque',
                                    hintText: 'bpm',
                                  ),
                                ],
                                onSubmit: (formValues) {
                                  setState(() {
                                    allTestsCompletion[0][1] = true;
                                  });
                                },
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    ExpandableTestCard(
                      title: 'Force',
                      subtitle: 'Tests de force musculaire',
                      imagePath: 'assets/images/force2.jpg',
                      exercises: const ['Assis-debout', 'Test de la chaise', "Test de handgrip"],
                      isCompleted: allTestsCompletion[1],
                      onExerciseTap: (exerciseName) {
                        if (exerciseName.contains('Assis-debout')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CustomFormBuilderPage(
                                userId: widget.userId,
                                title: "Test de force",
                                subtitle:
                                "Procédure : faire des flexions assis-debout pendant 30 secondes, bas en croix sur la poitrine.",
                                formFields: [
                                  CustomFormField(
                                    title: 'Test du assis-debout - 30 sec',
                                    labelText: 'Nombre de répétitions',
                                    //hintText: 'bpm',
                                  ),
                                ],
                                onSubmit: (formValues) {
                                  setState(() {
                                    allTestsCompletion[1][0] = true;
                                  });
                                },
                              ),
                            ),
                          );
                        } else if (exerciseName.contains('Test de la chaise')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CustomFormBuilderPage(
                                userId: widget.userId,
                                title: "Test de force",
                                subtitle:
                                "Procédure : le test de la chaise consiste à se placer le dos contre un mur, les pieds écartés de 20cm, puis glisser vers le bas en fléchissant les jambes et en éloignant les pieds de façon à obtenir un angle de 90° entre le tronc et la cuisse et entre la cuisse et la jambe.",
                                formFields: [
                                  CustomFormField(
                                    title: 'Test de la chaise',
                                    labelText: 'Nombre de secondes',
                                    hintText: 'sec',
                                  ),
                                ],
                                onSubmit: (formValues) {
                                  setState(() {
                                    allTestsCompletion[1][1] = true;
                                  });
                                },
                              ),
                            ),
                          );
                        } else if (exerciseName.contains("Test de handgrip")) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CustomFormBuilderPage(
                                userId: widget.userId,
                                title: "Test de force",
                                subtitle:
                                "Procédure: Prendre le dynanomètre dans la main. Tenir la pognée dans le prolongement du bras, à la hauteur de la cuisse et éloignée du corps(angle de 45°). Serrer vigoureusement la poignée en exerçant une force maximale. Changer de mains.",
                                formFields: [
                                  CustomFormField(
                                    title: 'Test de handgrip (main droite)',
                                    labelText: 'Force maximale',
                                    hintText: 'kg',
                                  ),
                                  CustomFormField(
                                    title: 'Test de handgrip (main gauche)',
                                    labelText: 'Force maximale',
                                    hintText: 'kg',
                                  ),
                                ],
                                onSubmit: (formValues) {
                                  setState(() {
                                    allTestsCompletion[1][2] = true;
                                  });
                                },
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    ExpandableTestCard(
                      title: 'Équilibre',
                      subtitle: 'Test unipodal simple',
                      imagePath: 'assets/images/equilibre.jpg',
                      exercises: const ['Test du flamand'],
                      isCompleted: allTestsCompletion[2],
                      onExerciseTap: (exerciseName) {
                        if (exerciseName.contains('Test du flamand')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CustomFormBuilderPage(
                                userId: widget.userId,
                                title: "Test d’équilibre",
                                subtitle:
                                "Procédure : placer les mains sur les hanches et mettre un pied à plat sur le genou opposé. Fermer les yeux et démarrer le chronomètre. On a le droit à 2 essais par jambe et le meilleur des deux sera pris en compte. Le test peut se dérouler pieds nus.",
                                formFields: [
                                  CustomFormField(
                                    title: 'Test du flamand - pied droit',
                                    labelText: 'Nombre de secondes',
                                    hintText: 'sec',
                                  ),
                                  CustomFormField(
                                    title: 'Test du flamand - pied gauche',
                                    labelText: 'Nombre de secondes',
                                    hintText: 'sec',
                                  ),
                                ],
                                onSubmit: (formValues) {
                                  setState(() {
                                    allTestsCompletion[2][0] = true;
                                  });
                                },
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    ExpandableTestCard(
                      title: 'Souplesse',
                      subtitle: '3 tests à compléter',
                      imagePath: 'assets/images/akram-huseyn-ZJzCO-un8dI-unsplash.jpg',
                      exercises: const ['Main / Pied', 'Épaule', 'Flexomètre'],
                      isCompleted: allTestsCompletion[3],
                      onExerciseTap: (exerciseName) {
                        if (exerciseName.contains('Flexomètre')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CustomFormBuilderPage(
                                userId: widget.userId,
                                title: "Test de souplesse",
                                subtitle:
                                "Procédure : se positionner assis, les jambes en extension, les lantes de pieds sont verticales contre le montant du flexomètre. Tendre les mains vers l'avant et poser les mains l'une sur l'autre. Il faut chercher à pousser ses mains le plus loin possible vers l'avant sans fléchir les genoux et sans à-coup. La position maximale doit être maintenue 3 secondes pour être validée.",
                                formFields: [
                                  CustomFormField(
                                    title: 'Test de Flexomètre',
                                    labelText: 'Distance atteinte',
                                    hintText: 'cm',
                                  ),
                                ],
                                onSubmit: (formValues) {
                                  setState(() {
                                    allTestsCompletion[3][2] = true;
                                  });
                                },
                              ),
                            ),
                          );
                        } else if (exerciseName.contains('Main / Pied')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CustomValueSelectorPage(
                                userId: widget.userId,
                                pageTitle: 'Test de souplesse',
                                subtitle:
                                "Procédure : Se positionner debout, les jambes en extension. Fléchir le tronc et amener les mains les plus bas possible dans plier les jambes.",
                                labelText: 'Quelle est la position de tes mains ?',
                                values: const [
                                  'Les mains sur les cuisses',
                                  'Les mains sur les genoux',
                                  'Les mains sur les tibias',
                                  'Les mains sur les chevilles'
                                ],
                                onSelected: (selectedValue) {
                                  setState(() {
                                    allTestsCompletion[3][0] = true;
                                  });
                                },
                              ),
                            ),
                          );
                        } else if (exerciseName.contains('Épaule')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CustomValueSelectorPage(
                                userId: widget.userId,
                                pageTitle: 'Test de souplesse',
                                subtitle:
                                "Procédure : passer une main par-dessus l'épaule et la faire glisser dans le dos quasiment dans l'axe de la colonne vertébrale. Réaliser la même opération avec la seconde main mais cette fois ci par-dessous l'épaule. Le but du test est de venir toucher ou attraper les mains dans le dos.",
                                labelText: 'Où tes mains se touchent-elles ?',
                                values: const [
                                  'Je ne parviens pas à mettre les deux mains dans le dos',
                                  'Mes deux mains dans le dos ne se touchent pas',
                                  'Les bouts des deux doigts se touchent',
                                  'Les mains parviennent à se superposer'
                                ],
                                onSelected: (selectedValue) {
                                  setState(() {
                                    allTestsCompletion[3][1] = true;
                                  });
                                },
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String title) {
    return InkWell(
      onTap: () {
        // Ajoute ta navigation ici
        print('$title cliqué');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }


  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("Confirmer", style: TextStyle(color: Colors.white)),
        content: const Text("Voulez-vous vraiment vous déconnecter ?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler", style: TextStyle(color: Colors.redAccent)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Provider.of<UserProvider>(context, listen: false).logout();
              Get.offAllNamed('/login');
            },
            child: const Text("Déconnexion", style: TextStyle(color: Colors.greenAccent)),
          ),
        ],
      ),
    );
  }

}
