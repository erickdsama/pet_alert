import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pet_alert/bloc/chat/chat_bloc.dart';
import 'package:pet_alert/bloc/message_bloc.dart';
import 'package:pet_alert/models/ChatModel.dart';
import 'package:pet_alert/repo/user_repo.dart';
import 'package:pet_alert/widgets/list_messages_item.dart';

import '../styles.dart';


class Chat extends StatelessWidget {

  UserRepo userRepo;
  ChatModel chatModel;
  MessageBloc messageBloc;
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

  Chat({this.chatModel});

  @override
  Widget build(BuildContext context) {
    messageBloc = MessageBloc(chatModel.id, BlocProvider.of<ChatBloc>(context));
    return BlocProvider<MessageBloc>.value(
      value: messageBloc,
      child: new CupertinoPageScaffold(
          backgroundColor: Colors.white,
          navigationBar: CupertinoNavigationBar(
            middle: Text(chatModel.receiver.name),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  BlocBuilder<MessageBloc, MessageState>(
                      builder: (context, state){
                        if (state is MessageInitial) {
                          BlocProvider.of<MessageBloc>(context).add(ListenerMessages(docId: chatModel.id));
                        }
                        if(state is NewMessages) {
                            if (state.messages.length > -1) {
                            return Flexible(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.messages.length,
                                  itemBuilder: (BuildContext ctx, int idx) {
                                    return Dismissible(
                                        movementDuration: Duration(seconds: 2),
                                        dragStartBehavior: DragStartBehavior.down,
                                        background: Container(color: Colors.redAccent,),
                                        direction: DismissDirection.endToStart,
                                        key: Key(state.messages[idx].id),
                                        onDismissed: (direction) {
                                        },
                                        child: ListMessageItem(messageModel: state.messages[idx])
                                    );
                                  }),
                            );
                          } else {
                            return notChats(context);
                          }
                        } else {
                          return notChats(context);
                        }
                      }),
                    Row(
                      children: [
                        Expanded(
                            flex: 8,
                            child: CupertinoTextField(
                              placeholder: "Enviar Mensaje",
                              maxLines: 2,
                            )
                        ),
                        Expanded(
                          flex: 2,
                          child: CupertinoButton(
                            child: Text("Enviar"),
                            onPressed: () {

                            },
                          ),
                        )
                      ],
                    )
//                  Row(
//                    children: [
//                      CupertinoTextField(
//                        placeholder: "Enviar mensaje",
//
//                      ),
//                      CupertinoButton(child: Text("enviar"), onPressed: (){
//
//                      })
//                    ],
//                  )

                ],
              ),
            ],
          )
      ),
    );
  }
}