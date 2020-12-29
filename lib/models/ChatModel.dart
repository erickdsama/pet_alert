
import 'dart:convert';

import 'package:pet_alert/models/UserModel.dart';

class ChatModel{
  UserModel owner;
  UserModel receiver;
  String id;
  String lastUpdate;
  String state;

  ChatModel({
    this.state,
    this.owner,
    this.receiver,
    this.id,
    this.lastUpdate
  });


  factory ChatModel.fromJSON(Map<String, dynamic> json) {
    return ChatModel(
        receiver: UserModel.fromJSON(json['receiver']),
        owner: UserModel.fromJSON(json['owner']),
        lastUpdate: json['lastUpdate'],
        id: json['id'].toString());
  }

  String toJSON() {
    return jsonEncode(<String, dynamic>{
      'owner': this.owner.id,
      'receiver': this.receiver.id,
      'lastUpdate': this.lastUpdate,
    });
  }

}