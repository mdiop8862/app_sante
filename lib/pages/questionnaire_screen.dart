import 'package:flutter/material.dart';
import 'package:appli_ap_sante/utils/FirebaseManagement.dart'; // fonction saveFormDataToUserDoc
import 'package:firebase_auth/firebase_auth.dart';

class QuestionnaireScreen extends StatefulWidget {
  final String userId;  // Ajout du userId

  const QuestionnaireScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  bool isQuestionnaireCompleted = false;
  int currentQuestionIndex = 0;
  final Color primaryColor = Color(0xFFb01f00);
  int? selectedOption;
  final Map<int, int> scores = {};

  final List<Map<String, dynamic>> questions = [
    // Sedentarité
    {
      'text': 'Combien de temps passez-vous en position assise par jour (loisirs, télé, ordinateur, travail, etc.) ?',
      'options': [
        'Moins de 2 h',
        '2 à 3 h',
        '3 à 4 h',
        '4 à 5 h',
        'Plus de 5 h'
      ],
    },
    // Question B et C
    {
      'text': 'Pratiquez-vous régulièrement une ou des activités physiques ?',
      'options': ['Non', 'Oui'],
      'isBinary': true,
    },
    {
      'text': 'À quelle fréquence pratiquez-vous l’ensemble de ces activités ?',
      'options': [
        '1 à 2 fois / mois',
        '1 fois / semaine',
        '2 fois / semaine',
        '3 fois / semaine',
        '4 fois / semaine'
      ],
    },
    {
      'text': 'Combien de minutes consacrez-vous en moyenne à chaque séance d’activité physique ?',
      'options': [
        'Moins de 15 min',
        '16 à 30 min',
        '31 à 45 min',
        '46 à 60 min',
        'Plus de 60 min'
      ],
    },
    {
      'text': 'Habituellement, comment percevez-vous votre effort ?',
      'options': ['1', '2', '3', '4', '5'],
    },
    {
      'text': 'Quelle intensité d’activité physique votre travail requiert-il ?',
      'options': ['Légère', 'Modérée', 'Moyenne', 'Intense', 'Très intense'],
    },
    {
      'text': 'En dehors de votre travail régulier, combien d’heures consacrez-vous par semaine aux travaux légers : bricolage, jardinage, ménages, etc. ?',
      'options': [
        'Moins de 2 h',
        '2 à 3 h',
        '5 à 6 h',
        '7 à 9 h',
        'Plus de 10 h'
      ],
    },
    {
      'text': 'Combien de minutes par jour consacrez-vous à la marche ?',
      'options': [
        'Moins de 15 min',
        '16 à 30 min',
        '31 à 45 min',
        '46 à 60 min',
        'Plus de 60 min'
      ],
    },
    {
      'text': 'Combien d’étages, en moyenne, montez-vous à pied chaque jour ?',
      'options': ['Moins de 2', '3 à 5', '6 à 10', '11 à 15', 'Plus de 16'],
    },
  ];

  int getScore(int questionIndex, int optionIndex) {
    final question = questions[questionIndex];
    if (question.containsKey('isBinary')) {
      return optionIndex == 0 ? 1 : 5; // Non = 1, Oui = 5
    }
    return optionIndex + 1; // Options indexées de 1 à 5
  }

  int calculerScoreGlobal(int total) {
    if (total <= 9) return 1;
    if (total <= 18) return 2;
    if (total <= 27) return 3;
    if (total <= 36) return 4;
    return 5;
  }

  void nextQuestion() {
    if (selectedOption != null) {
      scores[currentQuestionIndex] = getScore(currentQuestionIndex, selectedOption!);
      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          // Charger la réponse précédente si elle existe, sinon null
          selectedOption = scores.containsKey(currentQuestionIndex) ? scores[currentQuestionIndex]! - 1 : null;
        });
      } else {
        int total = scores.values.reduce((a, b) => a + b);
        int scoreGlobal = calculerScoreGlobal(total);
        isQuestionnaireCompleted = true;

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: Colors.white,
            title: Text("Résultat", style: TextStyle(color: Colors.black)),
            content: Text("Vous avez terminé le questionnaire !", style: TextStyle(color: Colors.black)),
            actions: [
              TextButton(
                child: Text("OK", style: TextStyle(color: primaryColor)),
                onPressed: () {
                  int total = scores.values.reduce((a, b) => a + b);
                  int scoreGlobal = calculerScoreGlobal(total);
                  print(scoreGlobal);
                  saveQuestionnaire(
                    userId: widget.userId,
                    scoreQuestionnaire: scoreGlobal,
                  );

                  Navigator.pop(context); // Ferme la boîte de dialogue
                  Navigator.pop(context); // Ferme la page questionnaire

                  final uid = FirebaseAuth.instance.currentUser?.uid;
                  if (uid != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionnaireScreen(userId: uid),
                      ),
                    );
                  } else {
                    print("Utilisateur non connecté");
                  }
                },
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (currentQuestionIndex > 0) {
              setState(() {
                currentQuestionIndex--;
                selectedOption = scores.containsKey(currentQuestionIndex) ? scores[currentQuestionIndex]! - 1 : null;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          "Questionnaire APS",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // moins de padding vertical
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: (selectedOption != null ? currentQuestionIndex + 1 : currentQuestionIndex) / questions.length,
              color: primaryColor,
              backgroundColor: Colors.grey[300],
              minHeight: 6,  // barre un peu plus fine
            ),
            SizedBox(height: 12),
            Text("Question ${currentQuestionIndex + 1} / ${questions.length}",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            SizedBox(height: 16),
            Text(question['text'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),

            // Liste des options dans un container avec hauteur max adaptée
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 250,  // limite la hauteur à ~250px (ajuste si besoin)
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: question['options'].length > 5
                    ? ScrollPhysics()
                    : NeverScrollableScrollPhysics(), // scroll seulement si trop d’options
                itemCount: question['options'].length,
                itemBuilder: (context, index) {
                  return RadioListTile<int>(
                    dense: true,
                    title: Text(question['options'][index],
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                    value: index,
                    groupValue: selectedOption,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24), // espace généreux en bas
        child: SizedBox(
          height: 44, // bouton pas trop grand
          child: ElevatedButton(
            onPressed: selectedOption != null ? nextQuestion : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text("Continuer", style: TextStyle(fontSize: 16)),
          ),
        ),
      ),

    );
  }
}
