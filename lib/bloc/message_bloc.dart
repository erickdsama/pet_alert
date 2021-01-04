import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pet_alert/models/ChatModel.dart';
import 'package:pet_alert/models/MessageModel.dart';

import 'chat/chat_bloc.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  Database database;

  final String databaseName = "pet_alert_9393";
  final String docId;
  Replicator replicator;
  ChatBloc chatBloc;
  StreamSubscription listChatSubscription;
  MessageBloc(this.docId, this.chatBloc){
    listChatSubscription = this.chatBloc.listen((state) {
      if (state is ChatLoadedState) {
        List<ChatModel> chats = state.chats;
        for(var chat in chats) {
          if (chat.id == this.docId) {
            add(UpdateMessages(messages: chat.messages));
          }
        }
      }
    });
  }

  ListenerToken _listenerToken;


  @override
  MessageState get initialState => MessageInitial();

  @override
  Stream<MessageState> mapEventToState(
    MessageEvent event,
  ) async* {
    if (event is ListenerMessages) {
      database = await Database.initWithName(databaseName);
      ReplicatorConfiguration config =
      ReplicatorConfiguration(database, "ws://138.68.249.12:4984/pet_alert/");
      config.replicatorType = ReplicatorType.pushAndPull;
      config.continuous = true;
      config.channels = ["sender_1"];
      replicator = Replicator(config);

      _listenerToken = replicator.addChangeListener((ReplicatorChange event) {
        print("event ${event.status}");

        if (event.status.error != null) {
        }
      });
      replicator.start();
    } else if(event is UpdateMessages) {
      yield(GettingMessages());
      yield(NewMessages(messages: event.messages));
    }
  }

  @override
  Future<void> close() async {
    await listChatSubscription.cancel();
    await replicator?.removeChangeListener(_listenerToken);
    await replicator?.stop();
    await replicator?.dispose();
    await database?.close();
    return super.close();
  }
}
