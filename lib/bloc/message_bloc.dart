import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:couchbase_lite/couchbase_lite.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pet_alert/models/ChatModel.dart';
import 'package:pet_alert/models/MessageModel.dart';
import 'package:pet_alert/models/UserModel.dart';
import 'package:pet_alert/repo/couchbase_repo.dart';

import 'chat/chat_bloc.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  Database database;

  final String databaseName = "pet_alert_939322";
  final ChatModel chatModel;
  CouchBaseRepo couchBaseRepo;
  ListenerToken _listenerToken;
  Replicator replicator;
  ChatBloc chatBloc;
  StreamSubscription listChatSubscription;

  MessageBloc(this.chatModel, this.chatBloc, this.couchBaseRepo){

    listChatSubscription = this.chatBloc.listen((state) {
      if (state is ChatLoadedState) {
        List<ChatModel> chats = state.chats;
        for(var chat in chats) {
          if (chat.id == this.chatModel.id) {
            add(UpdateMessages(messages: chat.messages));
          }
        }
      }
    });
  }

  @override
  MessageState get initialState => MessageInitial();

  @override
  Stream<MessageState> mapEventToState(
    MessageEvent event,
  ) async* {
    if (event is ListenerMessages) {
      couchBaseRepo.enableReplicas(
        replicaChange: (state) {},
        dbChange: (dbChange) {},
        channels: ["sender_1"]
      );

    } else if(event is UpdateMessages) {
      yield(GettingMessages());
      yield(NewMessages(messages: event.messages));
    } else if(event is SendMessage) {
      yield SendingMessage();
      couchBaseRepo.sendMessage(this.chatModel, event.sender, event.receiver, event.message);
      SentMessage();
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
