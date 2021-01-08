import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:pet_alert/models/ChatModel.dart';
import 'package:pet_alert/models/MessageModel.dart';
import 'package:pet_alert/models/UserModel.dart';
import 'package:pet_alert/repo/user_repo.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  String database_name = "pet_alert_939322";
  Database database;
  Replicator replicator;
  List<ChatModel> chats = [];

  UserRepo userRepo;

  ListenerToken _dbListenerToken;
  ListenerToken _listenerToken;
  
  ChatBloc(this.userRepo);


  dynamic getResultData(result, key) {
    return result.toMap()[database_name][key];
  }
  dynamic getResultDataCB(result, key) {
    return result.toMap()[key];
  }

  @override
  ChatState get initialState => ChatInitial();

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    Map<String, UserModel> idUserModel = {};
    if (event is InitialChatEvent) {
      database = await Database.initWithName(database_name);
      ReplicatorConfiguration config =
      ReplicatorConfiguration(database, "ws://138.68.249.12:4984/pet_alert/");
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

        idUserModel = {};
        // todo: mover este codigo a una funcion para que se pueda reusar
        if (result.allResults().length > 0 ){
          List<String> idsSender = result.allResults().map((x) => getResultData(x, "sender").toString()).toList();
          List<String> idsReceiver = result.allResults().map((x) => getResultData(x, "receiver").toString()).toList();
          List<String> allUsers = new List.from(idsSender)..addAll(idsReceiver);
          List<UserModel> allModels = await userRepo.fetchUsers(allUsers);
          for(var userModel in allModels) {
            idUserModel[userModel.id] = userModel;
          }
        }
        for(var row in result.allResults()) {


          final chatList = getResultData(row, "chat");
          List<MessageModel> messages = [];
          for(int i=0; i<chatList.length; i++) {
            messages.add(MessageModel(
              owner: idUserModel[chatList[i]["sender"].toString()],
              receiver: idUserModel[chatList[i]["receiver"].toString()],
              message: chatList[i]["message"],
              sent: DateTime.fromMillisecondsSinceEpoch(chatList[i]["timestamp"] * 1000).toString(),
              state: "new",
                id: UniqueKey().toString()
            ));
          }

          chats.add(ChatModel(
              id: row.toMap()["id"],
              messages: messages,
              state: getResultData(row, "state"),
              owner: idUserModel[getResultData(row, "sender").toString()],
              receiver: idUserModel[getResultData(row, "receiver").toString()],
              lastUpdate: DateTime.fromMillisecondsSinceEpoch(getResultData(row, "timestamp")*1000).toString()
          ));
        }
        yield ChatLoadedState(chats: chats);
      } on PlatformException {
      }


      _dbListenerToken = database.addChangeListener((dbChange) {
        add(UpdateChatList(dbChange.documentIDs));
      });

      replicator.start();

    } else if(event is UpdateChatList) {
      List<String> chatsIds = chats.map((x) => x.id).toList();


      for (var change in event.changes) {
        yield ChatListenState();
        // print("changes not in ${chatsIds.toString()}");
        if (!chatsIds.contains(change)) {
          // todo: necesito realizar codigo para cuando se crea un nuevo chat
          // chats.add(ChatModel(
          //     id: change,
          //     owner: UserModel(name: "Erick",
          //         photo: "https://avatars3.githubusercontent.com/u/17994929?s=400&u=f0f900ffc441bf446785bce723e345dbec9bed40&v=4",
          //         id: "1", age: 29, sex: 1),
          //     receiver: UserModel(name: "Juan",
          //         photo: "https://avatars3.githubusercontent.com/u/17994929?s=400&u=f0f900ffc441bf446785bce723e345dbec9bed40&v=4",
          //         id: "1", age: 29, sex: 1),
          //     lastUpdate: "2020-11-12 18:00:00"
          // ));
        } else{
          Document doc = await database.document(change);
          for (var i=0; i<chats.length; i++){
            var chat = chats[i];
            if (chat.id == change) {
              // print("doc ${doc.toMap()}");
              final chatList = getResultDataCB(doc, "chat");
              List<MessageModel> messages = [];
              for(int i=0; i<chatList.length; i++) {
                messages.add(MessageModel(
                    owner: (chatList[i]["sender"].toString() == chat.owner.id) ? chat.owner : chat.receiver,
                    receiver:(chatList[i]["receiver"].toString() == chat.owner.id) ? chat.owner : chat.receiver,
                    message: chatList[i]["message"],
                    sent: DateTime.fromMillisecondsSinceEpoch(chatList[i]["timestamp"] * 1000).toString(),
                    state: "new",
                    id: UniqueKey().toString()
                ));
              }
              // print("len ${messages.length}");
              chat = ChatModel(
                  id: doc.id,
                  messages: messages,
                  state: getResultDataCB(doc, "state"),
                  owner: chat.owner,
                  receiver: chat.receiver,
                  lastUpdate: DateTime.fromMillisecondsSinceEpoch(getResultDataCB(doc, "timestamp")*1000).toString()
              );
              chats[i] = chat;
            }
          }
          // print("messages ${chats.map((x) => x.messages.map((y)=>y.owner.id))}");
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
