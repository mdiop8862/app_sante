import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> saveTestResultToFirestore({
  required String userId,
  required String category, // ex: "endurance"
  required String testKey,  // ex: "marche6mn"
  required Map<String, dynamic> data, // les valeurs à enregistrer
}) async {
  final docRef = FirebaseFirestore.instance.collection('users').doc(userId);

  await docRef.set({
    category: {
      testKey: data,
    }
  }, SetOptions(merge: true)); // fusionne sans écraser les autres données
}
