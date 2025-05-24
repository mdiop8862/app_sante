import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> saveFormDataToUserDoc({
  required String userId,
  required String category,
  required String testKey,
  required Map<String, String> data,
}) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

  try {
    await userRef.set({
      category: {
        testKey: data
      }
    }, SetOptions(merge: true));

    print('Formulaire "$testKey" sauvegardé dans catégorie "$category"');
  } catch (e) {
    print('Erreur lors de la sauvegarde Firestore : $e');
  }
}

Future<void> saveQuestionnaire({
  required String userId,
  int? scoreQuestionnaire,
}) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

  Map<String, dynamic> updateData = {};

  if (scoreQuestionnaire != null) updateData['scoreQuestionnaire'] = scoreQuestionnaire;

  try {
    await userRef.set(updateData, SetOptions(merge: true));
    print('questionnaire sauvegardés');
  } catch (e) {
    print('Erreur sauvegarde questionnaire : $e');
  }
}

Future<Map<String, dynamic>> getUserTestData(String userId) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  if (!doc.exists) return {};

  final data = doc.data()!;
  Map<String, dynamic> result = {
    'scoreQuestionnaire': data['scoreQuestionnaire'],
    'sexe': data['sexe'],
    'age': data['age'],
    'poids' : data['poids'] ,
    'taille' : data['taille'] ,
    'tests': <String, Map<String, dynamic>>{},
  };

  for (final category in ['endurance', 'force', 'souplesse', 'equilibre']) {
    if (data[category] != null && data[category] is Map<String, dynamic>) {
      result['tests'][category] = Map<String, dynamic>.from(data[category]);
    }
  }

  return result;
}


Future<bool> saveUserProfile({
  required String userId,
  required double poids,
  required double taille,
  required int age,
  required String sexe,
  required String faculte,
}) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'poids': poids,
      'taille': taille,
      'age': age,
      'sexe': sexe,
      'faculte': faculte,
    }, SetOptions(merge: true)); // ✅ NE SUPPRIME PAS les autres champs
    return true;
  } catch (e) {
    print('Erreur lors de la sauvegarde : $e');
    return false;
  }
}

