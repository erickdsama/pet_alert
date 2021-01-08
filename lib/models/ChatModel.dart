
import 'dart:convert';

import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:flutter/cupertino.dart';
import 'package:pet_alert/models/MessageModel.dart';
import 'package:pet_alert/models/UserModel.dart';

import '../utils.dart';




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


  static List<MessageModel> setMessages(List<dynamic> chatList, Map<String, UserModel> usersModels) {
    List<MessageModel> messages = [];
    for(int i=0; i<chatList.length; i++) {
      messages.add(MessageModel(
          owner: usersModels[chatList[i]["sender"].toString()],
          receiver: usersModels[chatList[i]["receiver"].toString()],
          message: chatList[i]["message"],
          sent: DateTime.fromMillisecondsSinceEpoch(chatList[i]["timestamp"]).toString(),
          state: (chatList[i]["state"] != null) ? chatList[i]["state"] : "new",
          id: (chatList[i]["id"] != null) ? chatList[i]["id"] :  UniqueKey().toString()
      ));
    }
    return messages;
  }

  factory ChatModel.fromResult(Result result, Map<String, UserModel> usersModels) {
    final chatList = getResultData(result, "chat");
    return ChatModel(
      id: result.toMap()["id"],
      state: getResultData(result, "state"),
      messages: setMessages(chatList, usersModels),
      owner: usersModels[getResultData(result, "sender").toString()],
      receiver: usersModels[getResultData(result, "receiver").toString()],
      lastUpdate: DateTime.fromMillisecondsSinceEpoch(getResultData(result, "timestamp")).toString()
    );
  }

  factory ChatModel.fromDoc(Document doc, Map<String, UserModel> usersModels) {
    return ChatModel(
        id: doc.id,
        state: getResultData(doc, "state"),
        messages: setMessages(doc.toMap()["chat"], usersModels),
        owner: usersModels[doc.toMap()["sender"].toString()],
        receiver: usersModels[doc.toMap()["receiver"].toString()],
        lastUpdate: DateTime.fromMillisecondsSinceEpoch(doc.toMap()["timestamp"]).toString()
    );
  }

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