import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'globals.dart';

Future<User> getUser() async {
  await Firebase.initializeApp();
  return await FirebaseAuth.instance
      .currentUser;
}

dynamic getResultData(dynamic result, key) {
  if (result.toMap()[database_name] != null) {
    return result.toMap()[database_name][key];

  } else {
    return result.toMap()[key];
  }
}
