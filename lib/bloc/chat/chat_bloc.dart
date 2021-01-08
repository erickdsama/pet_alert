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
import 'package:pet_alert/repo/user_repo.dart';

import '../../utils.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  List<ChatModel> chats = [];
  UserRepo userRepo;
  ListenerToken _dbListenerToken;
  ListenerToken _listenerToken;
  Database database;
  Replicator replicator;
  ChatBloc(this.userRepo);


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
    allUsers.toSet().toList();
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
    allUsers.toSet().toList();
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
      database = await Database.initWithName(database_name);
      ReplicatorConfiguration config = ReplicatorConfiguration(database, "ws://138.68.249.12:4984/pet_alert/");
      config.replicatorType = ReplicatorType.pushAndPull;
      config.continuous = true;
      config.channels = ["sender_1"];

      replicator = Replicator(config);
      yield ChatListenState();

      _listenerToken = replicator.addChangeListener((ReplicatorChange event) {
        if (event.status.error != null) {
        }
      });

      // Create a query to fetch documents.
      var query = QueryBuilder.select([SelectResult.all(), SelectResult.expression(Meta.id)])
          .from(database_name);
      // Run the query.
      try {
        var result = await query.execute();
        idUserModel = await getAllChatUsers(result);
        for(var row in result.allResults()) {
          chats.add(ChatModel.fromResult(row, idUserModel));
        }
        yield ChatLoadedState(chats: chats);
      } on PlatformException {
      }

      _dbListenerToken = database.addChangeListener((dbChange) {
        add(UpdateChatList(dbChange.documentIDs));
      });

      replicator.start();

    } else if(event is UpdateChatList) {
      yield ChatChangeData();
      List<String> chatsIds = chats.map((x) => x.id).toList();
      List<Document> docs = await Future.wait(event.changes.map((change) async => await database.document(change)));
      Map<String, UserModel> idUserModel = await getAllDocsUsers(docs);

      for (var change in event.changes) {
        if (!chatsIds.contains(change)) {
          Document doc = await database.document(change);
          ChatModel.fromDoc(doc, idUserModel);
        } else{
          Document doc = await database.document(change);
          for (var i=0; i<chats.length; i++){
            var chat = chats[i];
            if (chat.id == change) {
              chats[i] = ChatModel.fromDoc(doc, idUserModel);
            }
          }
        }
      }
      yield ChatLoadedState(chats: chats);
    }
  }


  @override
  Future<void> close() async {
    await replicator?.removeChangeListener(_listenerToken);
    await replicator?.stop();
    await replicator?.dispose();
    await database?.removeChangeListener(_dbListenerToken);
    await database?.close();
    return super.close();
  }

}
