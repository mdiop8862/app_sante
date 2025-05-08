import 'package:flutter/material.dart';
import '../widgets/expandable_test_card.dart' ;
import "../widgets/imc_card.dart" ;
import '../widgets/questionnaire_card.dart' ;
import '../widgets/top_bar.dart' ;
import 'form_builder_page.dart' ;
import "custom_value_selector_page.dart" ;
import '../widgets/add_button.dart' ;
import 'package:get/get.dart';
import 'profile_page.dart';
import 'test_result_page.dart';
import 'project_presentation.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: AddButton(
        onActionSelected: (String action) {
          if (action == 'Profils') {
            Get.to(
                  () => const ProfilePage(),
            );
          } else if (action == 'Résultats') {
            Get.to(
                  () => const TestResultPage(),
            );
          } else if (action == 'Présentation du projet') {
            Get.to(
                  () => const PresentationPage(),
            );
          }
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //  Date
              TopBar(selectedDate: today),
              const SizedBox(height: 24),

              //  IMC
              const IMCWidget(
                imcValue: 22.8,
                statut: 'Élevé',
                categorie: 'Surpoids',
              ),
              const SizedBox(height: 16),

              // Liste scrollable des catégories de tests
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    QuestionnaireCard(
                      onTap: () {
                        Navigator.pushNamed(context, '/questionnaire');
                      },
                    ),
                    const SizedBox(height: 12),
                    ExpandableTestCard(
                      title: 'Endurance',
                      subtitle: '1 exercice cardio à réaliser',
                      imagePath: 'assets/images/endurance.jpeg',
                      exercises: ['Test de marche – 6mn', 'Montée de marche'],
                      isCompleted: [true, false],
                      onExerciseTap: (exerciseName) {
                        if (exerciseName.contains('Test de marche')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CustomFormBuilderPage(
                                title: "Test d’endurance",
                                formFields: [
                                  CustomFormField(
                                    title: 'Test de marche – 6 minutes',
                                    labelText: 'Longueur parcourue',
                                    hintText: 'm',
                                  ),

                                ],
                              ),
                            ),
                          );
                        }
                        else if (exerciseName.contains('Montée de marche')){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CustomFormBuilderPage(
                                title: "Test d’endurance",
                                formFields: [
                                  CustomFormField(
                                    title: 'Test de la montée de marche',
                                    labelText: 'Fréquence cardiaque ',
                                    hintText: 'bpm',
                                  ),

                                ],
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
                      exercises: ['Assis-debout', 'Test de la chaise' , "Test de handgrip"],
                      isCompleted: [false, false , true],
                      onExerciseTap: (exerciseName) {
                        if (exerciseName.contains('Assis-debout')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CustomFormBuilderPage(
                                title: "Test de force",
                                formFields: [
                                  CustomFormField(
                                    title: 'Test assis-debout - 30 sec',
                                    labelText: 'Nombre de repetitions',
                                    hintText: '',
                                  ),

                                ],
                              ),
                            ),
                          );
                        }
                        else if (exerciseName.contains('Test de la chaise')){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CustomFormBuilderPage(
                                title: "Test de force",
                                formFields: [
                                  CustomFormField(
                                    title: 'Test de la chaise ',
                                    labelText: 'Nombre de  secondes',
                                    hintText: 'sec',
                                  ),

                                ],
                              ),
                            ),
                          );
                        }
                        else if(exerciseName.contains("Test de handgrip")){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CustomFormBuilderPage(
                                title: "Test de force",
                                formFields: [
                                  CustomFormField(
                                    title: 'Test de handgrip ( main droite ) ',
                                    labelText: 'Force maximale',
                                    hintText: 'kg',
                                  ),
                                  CustomFormField(
                                    title: 'Test de handgrip ( main gauche )',
                                    labelText: 'Force maximale',
                                    hintText: 'kg',
                                  ),

                                ],
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
                      exercises: ['Test du flamand'],
                      isCompleted: [true],
                      onExerciseTap: (exerciseName) {
                        if (exerciseName.contains('Test du flamand')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CustomFormBuilderPage(
                                title: "Test d’équilibre",
                                formFields: [
                                  CustomFormField(
                                    title: 'Test du flamand - pied droit ',
                                    labelText: 'Nombre de  secondes',
                                    hintText: 'sec',
                                  ),
                                  CustomFormField(
                                    title: 'Test du flamand - pied gauche ',
                                    labelText: 'Nombre de  secondes',
                                    hintText: 'sec',
                                  ),

                                ],
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
                      exercises: ['Main / Pied', 'Épaule', 'Flexomètre'],
                      isCompleted: [false, false, false],
                      onExerciseTap: (exerciseName) {
                        if (exerciseName.contains('Flexomètre')) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CustomFormBuilderPage(
                                title: "Test de souplesse",
                                formFields: [
                                  CustomFormField(
                                    title: 'Test de Flexomètre ',
                                    labelText: 'Distance atteinte',
                                    hintText: 'cm',
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        else if(exerciseName.contains('Main / Pied')){
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                                 builder : (_) => const CustomValueSelectorPage(
                                   pageTitle: 'Test de souplesse',
                                   labelText: 'Quelle est la position de tes mains ?',
                                   values: [
                                     'Les mains sur les cuisses',
                                     'Les mains sur les genoux',
                                     'Les mains sur les tibias',
                                     'Les mains sur les chevilles'
                                   ],
                                 ),


                             ) ,
                           ) ;
                        }

                        else if(exerciseName.contains('Épaule')){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder : (_) => const CustomValueSelectorPage(
                                pageTitle: 'Test de souplesse',
                                labelText: 'Où tes mains se touchent elles ?',
                                values: [
                                  'Je ne parviens pas a mettre les deux mains dans le dos',
                                  'Mes deux mains dans le dos ne se touchent pas',
                                  'Les bouts des deux doigts se touchent ',
                                  'Les mains parviennent a se superposer'

                                ],
                              ),


                            ) ,
                          ) ;
                        }

                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );


  }
}
