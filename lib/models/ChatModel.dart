
import 'dart:convert';

import 'package:pet_alert/models/MessageModel.dart';
import 'package:pet_alert/models/UserModel.dart';

class ChatModel{
  UserModel owner;
  UserModel receiver;
  String id;
  String lastUpdate;
  String state;
  List<MessageModel> messages;

  ChatModel({
    this.state,
    this.owner,
    this.receiver,
    this.id,
    this.messages,
    this.lastUpdate
  });




  factory ChatModel.fromJSON(Map<String, dynamic> mapJson) {
    final jsonDecoded = json.decode(mapJson["chat"]);
    List<MessageModel> messages = [];
    for(int i=0; i<jsonDecoded.length; i++) {
      messages.add(MessageModel.fromJSON(jsonDecoded[i]));
    }

    return ChatModel(
        receiver: UserModel.fromJSON(mapJson['receiver']),
        owner: UserModel.fromJSON(mapJson['owner']),
        lastUpdate: mapJson['lastUpdate'],
        messages: messages,
        id: mapJson['id'].toString());
  }

  String toJSON() {
    return jsonEncode(<String, dynamic>{
      'owner': this.owner.id,
      'receiver': this.receiver.id,
      'lastUpdate': this.lastUpdate,
    });
  }

}