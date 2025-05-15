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

    print('✅ Formulaire "$testKey" sauvegardé dans catégorie "$category"');
  } catch (e) {
    print('❌ Erreur lors de la sauvegarde Firestore : $e');
  }
}


Future<Map<String, dynamic>> getUserTestData(String userId) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  if (!doc.exists) return {};

  final data = doc.data()!;
  Map<String, dynamic> result = {
    'sexe': data['sexe'],
    'age': data['age'],
    'tests': <String, Map<String, dynamic>>{},
  };

  for (final category in ['endurance', 'force', 'souplesse', 'equilibre']) {
    if (data[category] != null && data[category] is Map<String, dynamic>) {
      result['tests'][category] = Map<String, dynamic>.from(data[category]);
    }
  }

  return result;
}
