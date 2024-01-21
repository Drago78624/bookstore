import 'package:bookstore/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

get_current_userData() async {
  final docRef =
      db.collection("users").doc(FirebaseAuth.instance.currentUser!.uid);
  await docRef.get().then(
    (DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      return data;
    },
    onError: (e) => print("Error getting document: $e"),
  );
}
