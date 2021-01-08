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

  final String databaseName = "pet_alert_939322";
  final ChatModel chatModel;
  ListenerToken _listenerToken;
  Replicator replicator;
  ChatBloc chatBloc;
  StreamSubscription listChatSubscription;

  MessageBloc(this.chatModel, this.chatBloc){
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
    } else if(event is SendMessage) {
      yield SendingMessage();
      String message = event.message;
      Document doc = await database.document(this.chatModel.id);
      List<dynamic> chat  = doc.getList("chat");
      chat.add(
        MessageModel(
          state: "new",
          message: message,
          id: UniqueKey().toString(),
          owner: this.chatModel.owner,
          receiver: this.chatModel.receiver,
          sent: DateTime.now().millisecondsSinceEpoch.toString(),
        ).toMap()
      );
      doc = (await database.document(doc.id))
          ?.toMutable()
          ?.setList("chat", chat);
      if (doc != null) {
        await database.saveDocument(doc);
      }
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
