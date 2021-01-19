import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pet_alert/bloc/auth/auth_bloc.dart';
import 'package:pet_alert/bloc/auth/auth_state.dart';
import 'package:pet_alert/bloc/chat/chat_bloc.dart';
import 'package:pet_alert/bloc/message_bloc.dart';
import 'package:pet_alert/models/ChatModel.dart';
import 'package:pet_alert/models/MessageModel.dart';
import 'package:pet_alert/repo/couchbase_repo.dart';
import 'package:pet_alert/repo/user_repo.dart';
import 'package:pet_alert/widgets/list_messages_item.dart';

import '../styles.dart';

class Chat extends StatefulWidget {

  final ChatModel chatModel;
  Chat({this.chatModel});

  @override
  _ChatState createState() => _ChatState(chatModel: chatModel);
}

class _ChatState extends State<Chat> {
  UserRepo userRepo;
  CouchBaseRepo couchBaseRepo = CouchBaseRepo();
  MessageBloc messageBloc;
  List<MessageModel> messages = [];
  final ChatModel chatModel;

  _ChatState({this.chatModel});

  Widget notChats(context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child:
            Image.asset("assets/images/logo.png", color: Colors.grey, width: 100, fit: BoxFit.fitWidth,),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text("oh! \n No hay conversaciones aun", style: descList, textAlign: TextAlign.center,),
          ),
        ),
        CupertinoButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(MaterialIcons.add, size: 30,),
              Text("Nuevo Chat")
            ],
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/newPet', arguments: {});
          },
        )
      ],
    );
  }

  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    messageBloc = MessageBloc(widget.chatModel, BlocProvider.of<ChatBloc>(context), couchBaseRepo);
    return BlocProvider<MessageBloc>.value(
      value: messageBloc,
      child: new CupertinoPageScaffold(
          backgroundColor: Colors.white,
          navigationBar: CupertinoNavigationBar(
            middle: Text(widget.chatModel.receiver.name),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  BlocBuilder<MessageBloc, MessageState>(
                      builder: (context, state){
                        if (state is MessageInitial) {
                          BlocProvider.of<MessageBloc>(context).add(ListenerMessages(docId: widget.chatModel.id));
                        } else if (state is NewMessages) {
                          messages = state.messages;
                        }
                        if (messages.length <= 0) {
                          return notChats(context);
                        }
                        Timer(
                            Duration(milliseconds: 300),
                                () => _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 200), curve: Curves.easeInExpo));
                        return Flexible(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: messages.length,

                              controller: _scrollController,
                              itemBuilder: (BuildContext ctx, int idx) {
                                return Dismissible(
                                    movementDuration: Duration(seconds: 2),
                                    dragStartBehavior: DragStartBehavior.down,
                                    background: Container(color: Colors.redAccent,),
                                    direction: DismissDirection.endToStart,
                                    key: Key(messages[idx].id),
                                    onDismissed: (direction) {
                                    },
                                    child: ListMessageItem(messageModel: messages[idx])
                                );
                              }),
                        );
                      }),
                    Row(
                      children: [
                        Expanded(
                            flex: 8,
                            child: CupertinoTextField(
                              placeholder: "Enviar Mensaje",
                              controller: _messageController,
                              maxLines: 2,
                            )
                        ),
                        Expanded(
                          flex: 2,
                          child: BlocBuilder<AuthBloc, AuthState>(
                            bloc: BlocProvider.of<AuthBloc>(context),
                            builder: (context, state) {
                              if (state is AuthenticatedState) {
                                return CupertinoButton(
                                  child: Text("Enviar"),
                                  onPressed: () {
                                    messageBloc.add(
                                        SendMessage(
                                            message: _messageController.text,
                                            sender: state.userModel,
                                            receiver: chatModel.owner.id == state.userModel.id ? chatModel.receiver : chatModel.owner ));
                                    _messageController.clear();
                                  },
                                );
                              } else {
                                return Container();
                              }

                            }
                          ),
                        )
                      ],
                    )
                ],
              ),
            ],
          )
      ),
    );
  }

  @override
  void dispose() {
    couchBaseRepo.dispose();
    super.dispose();
  }
}