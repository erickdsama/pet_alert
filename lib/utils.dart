import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<User> getUser() async {
  await Firebase.initializeApp();
  return await FirebaseAuth.instance
      .currentUser;
}