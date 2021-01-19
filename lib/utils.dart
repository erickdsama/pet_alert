import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'globals.dart';
import 'models/ChatModel.dart';

Future<User> getUser() async {
  await Firebase.initializeApp();
  return  FirebaseAuth.instance
      .currentUser;
}

dynamic getResultData(dynamic result, key) {
  if (result.toMap()[database_name] != null) {
    return result.toMap()[database_name][key];

  } else {
    return result.toMap()[key];
  }
}

List<ChatModel> orderChats(chats) {
  chats.sort((a, b) {
    if (a.messages.length > 0) {
      if (b.messages.length > 0) {
        return DateTime.parse(a.messages.last.sent).compareTo(DateTime.parse(b.messages.last.sent));
      } else {
        return -1;
      }
    } else{
      return -1;
    }
  });
  return chats.reversed.toList();
}