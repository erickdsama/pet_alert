import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:pet_alert/globals.dart';
import 'package:pet_alert/models/ChatModel.dart';
import 'package:pet_alert/models/UserModel.dart';
import 'package:pet_alert/repo/couchbase_repo.dart';
import 'package:pet_alert/repo/user_repo.dart';

import '../../utils.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  List<ChatModel> chats = [];
  UserRepo userRepo;
  ChatBloc(this.userRepo);
  CouchBaseRepo couchBaseRepo;

  dynamic getResultDataCB(result, key) {
    return result.toMap()[key];
  }

  @override
  ChatState get initialState => ChatInitial();

  Future<Map<String,UserModel>> getAllDocsUsers(List<Document> result) async {
    print("result $result");
    Map<String, UserModel> idUsersModel = {};
    List<String> idsSender = result.map((x) => getResultData(x, "sender").toString()).toList();
    List<String> idsReceiver = result.map((x) => getResultData(x, "receiver").toString()).toList();
    List<String> allUsers = new List.from(idsSender)..addAll(idsReceiver);
    allUsers = allUsers.toSet().toList();
    allUsers.remove('null');
    if (allUsers.length <= 0 ) {
      return {};
    }
    if (allUsers.length <= 0 ) {
      return {};
    }
    List<UserModel> allModels = await userRepo.fetchUsers(allUsers);
    for(var userModel in allModels) {
      idUsersModel[userModel.id] = userModel;
    }
    return idUsersModel;
  }

  Future<Map<String,UserModel>> getAllChatUsers(ResultSet result) async {
    Map<String, UserModel> idUsersModel = {};
    List<String> idsSender = result.allResults().map((x) => getResultData(x, "sender").toString()).toList();
    List<String> idsReceiver = result.allResults().map((x) => getResultData(x, "receiver").toString()).toList();
    List<String> allUsers = new List.from(idsSender)..addAll(idsReceiver);
    allUsers = allUsers.toSet().toList();
    allUsers.remove('null');
    if (allUsers.length <= 0 ) {
      return {};
    }
    List<UserModel> allModels = await userRepo.fetchUsers(allUsers);
    for(var userModel in allModels) {
      idUsersModel[userModel.id] = userModel;
    }
    return idUsersModel;
  }


  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    Map<String, UserModel> idUserModel = {};
    if (event is InitialChatEvent) {
      couchBaseRepo = CouchBaseRepo();
      yield ChatListenState();
      couchBaseRepo.enableReplicas(
          channels: ['sender_1'],
          replicaChange: (event){

          }, dbChange: (dbChange){
            add(UpdateChatList(dbChange.documentIDs));
          });
      // Create a query to fetch documents.
      try {
        var result = await couchBaseRepo.fetchAllChats();
        idUserModel = await getAllChatUsers(result);
        print("${chats.length}");
        for(var row in result.allResults()) {
          try {
            chats.add(ChatModel.fromResult(row, idUserModel));
          } catch(e){
            print("Error: $e ${row.toMap()}");
          }
        }
        yield ChatLoadedState(chats: chats);
      } on PlatformException {
      }
    } else if(event is UpdateChatList) {
      yield ChatChangeData();
      List<String> chatsIds = chats.map((x) => x.id).toList();
      List<Document> docs = await couchBaseRepo.getChangesDocs(event.changes);
      Map<String, UserModel> idUserModel = await getAllDocsUsers(docs);

      for (var change in event.changes) {
        if (!chatsIds.contains(change)) {
          Document doc = await couchBaseRepo.getDocument(change);
          ChatModel.fromDoc(doc, idUserModel);
        } else{
          Document doc = await couchBaseRepo.getDocument(change);
          for (var i=0; i<chats.length; i++){
            var chat = chats[i];
            if (chat.id == change) {
              try {
                chats[i] = ChatModel.fromDoc(doc, idUserModel);
              } catch(e){
                print("Error: $e ${doc.toMap()}");
              }
            }
          }
        }
      }
      yield ChatLoadedState(chats: chats);
    } else if (event is NewChatEvent) {
      couchBaseRepo = CouchBaseRepo();
      couchBaseRepo.createChat(event.receiver, event.owner);
    }
  }


  @override
  Future<void> close() async {
    couchBaseRepo?.dispose();
    return super.close();
  }

}
