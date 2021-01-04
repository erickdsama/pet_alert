
import 'dart:convert';

import 'package:pet_alert/models/UserModel.dart';

class MessageModel{
  UserModel owner;
  UserModel receiver;
  String id;
  String sent;
  String message;
  String state;

  MessageModel({
    this.owner,
    this.receiver,
    this.id,
    this.sent,
    this.message,
    this.state
  });


  factory MessageModel.fromJSON(Map<String, dynamic> json) {
    return MessageModel(
        receiver: UserModel.fromJSON(json['receiver']),
        owner: UserModel.fromJSON(json['owner']),
        sent: json['timestamp'],
        id: json['id'].toString(),
        message: json['message'].toString());
  }

  String toJSON() {
    return jsonEncode(<String, dynamic>{
      'owner': this.owner.id,
      'receiver': this.receiver.id,
      'message': this.message,
      'timestamp': this.sent,
    });
  }

}