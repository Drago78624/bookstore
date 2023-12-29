import 'package:firebase_auth/firebase_auth.dart';

checkUserAuth() {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return true;
  } else {
    return false;
  }
}
