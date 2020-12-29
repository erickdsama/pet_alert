import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:pet_alert/bloc/couchbase/couchbase_bloc.dart';
import 'package:pet_alert/models/ChatModel.dart';
import 'package:pet_alert/models/UserModel.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  Database database;
  Replicator replicator;
  List<ChatModel> chats = [];

  ListenerToken _dbListenerToken;
  ListenerToken _listenerToken;
  
  ChatBloc();

  @override
  ChatState get initialState => ChatInitial();

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is InitialChatEvent) {
      database = await Database.initWithName("pet_alert_chats12232");
      ReplicatorConfiguration config =
      ReplicatorConfiguration(database, "ws://138.68.249.12:4984/pet_alert/");
      config.replicatorType = ReplicatorType.pushAndPull;
      config.continuous = true;
      replicator = Replicator(config);
      yield ChatListenState();


      _listenerToken = replicator.addChangeListener((ReplicatorChange event) {
        if (event.status.error != null) {
        }
      });

      // Create a query to fetch documents.
      var query = QueryBuilder.select([SelectResult.all(), SelectResult.expression(Meta.id)])
          .from("pet_alert_chats12232");
      // Run the query.
      try {
        var result = await query.execute();
        for(var row in result.allResults()) {
          print("row: ${row}");
          print("${row.toMap()}");

          chats.add(ChatModel(
              id: row.toMap()["id"],
              owner: UserModel(name: "Erick",
                  photo: "https://avatars3.githubusercontent.com/u/17994929?s=400&u=f0f900ffc441bf446785bce723e345dbec9bed40&v=4",
                  id: row.toMap()["id"], age: 29, sex: 1),
              receiver: UserModel(name: "Juan",
                  photo: "https://avatars3.githubusercontent.com/u/17994929?s=400&u=f0f900ffc441bf446785bce723e345dbec9bed40&v=4",
                  id: "1", age: 29, sex: 1),
              lastUpdate: "2020-11-12 18:00:00"
          ));
        }
        if (result.allResults().length > 0 ){
          yield ChatLoadedState(chats: chats);
        }

      } on PlatformException {
      }


      _dbListenerToken = database.addChangeListener((dbChange) {
        add(UpdateChatList(dbChange.documentIDs));
      });

      replicator.start();
      
    } else if(event is UpdateChatList) {
      print("changes ${event.changes}");
      List<String> ChatsIds = chats.map((x) => x.id).toList();

      for (var change in event.changes) {
        yield ChatListenState();

        if (!ChatsIds.contains(change)) {
          chats.add(ChatModel(
              id: change,
              owner: UserModel(name: "Erick",
                  photo: "https://avatars3.githubusercontent.com/u/17994929?s=400&u=f0f900ffc441bf446785bce723e345dbec9bed40&v=4",
                  id: "1", age: 29, sex: 1),
              receiver: UserModel(name: "Juan",
                  photo: "https://avatars3.githubusercontent.com/u/17994929?s=400&u=f0f900ffc441bf446785bce723e345dbec9bed40&v=4",
                  id: "1", age: 29, sex: 1),
              lastUpdate: "2020-11-12 18:00:00"
          ));
        } else{
          for (var chat in chats){
            if (chat.id == change) {
              chat.state = "new";
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
    await database?.close();
    return super.close();
  }

}
