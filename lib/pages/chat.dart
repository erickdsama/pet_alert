import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
    if (userRepo == null) {
      userRepo = UserRepo();
    }
    //estoy revisando como crear la lista de mensajes, lo mas seguro es que debo de usar
    // un listener document, pero por el moemnto solo quiero abrir messages

    BlocProvider.of<ChatBloc>(context).listen((state) {
      print("state $state");

    });
    return BlocProvider<MessageBloc>(
      create: (context) => MessageBloc(chatModel.id, BlocProvider.of<ChatBloc>(context)),
      child: new CupertinoPageScaffold(
          backgroundColor: Colors.white,
          navigationBar: CupertinoNavigationBar(
            middle: Text(chatModel.receiver.name),
          ),
          child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state){

                if (state is MessageInitial) {
                  BlocProvider.of<MessageBloc>(context).add(ListenerMessages(docId: chatModel.id));
                }
                if(state is NewMessages) {
                    if (state.messages.length > -1) {
                    return ListView.builder(
                        padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
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
                        });
                  } else {
                    return notChats(context);
                  }
                } else {
                  return notChats(context);
                }
              })
      ),
    );
  }
}