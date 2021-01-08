import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pet_alert/bloc/chat/chat_bloc.dart';
import 'package:pet_alert/bloc/pets/bloc.dart';
import 'package:pet_alert/models/ChatModel.dart';
import 'package:pet_alert/models/PetModel.dart';
import 'package:pet_alert/models/UserModel.dart';
import 'package:pet_alert/repo/user_repo.dart';
import 'package:pet_alert/widgets/list_chat_item.dart';
import 'package:pet_alert/widgets/list_pet_item.dart';

import '../styles.dart';


class ChatsList extends StatelessWidget {

  ScrollController _scrollController = ScrollController();
  UserRepo userRepo;
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

  @override
  Widget build(BuildContext context) {
    return new CupertinoPageScaffold(
          backgroundColor: Colors.white,
          navigationBar: CupertinoNavigationBar(
            middle: Text("Mis Conversaciones"),
            trailing: CupertinoButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/newMessage', arguments: {});
              },
            ),
          ),
          child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state){
                if (state is ChatInitial) {
                  BlocProvider.of<ChatBloc>(context).add(InitialChatEvent());
                }
                if(state is ChatLoadedState) {
                  if (state.chats.length > -1) {
                    ListView list =  ListView.builder(
                        padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                        controller: _scrollController,
                        itemCount: state.chats.length,
                        itemBuilder: (BuildContext ctx, int idx) {
                          return Dismissible(
                              movementDuration: Duration(seconds: 2),
                              dragStartBehavior: DragStartBehavior.down,
                              background: Container(color: Colors.redAccent,),
                              direction: DismissDirection.endToStart,
                              key: Key(state.chats[idx].id),
                              onDismissed: (direction) {
                              },
                              child: ListChatItem(chatModel: state.chats[idx],)
                          );
                        });
                    return list;
                  } else {
                    return notChats(context);
                  }
                } else {
                  return notChats(context);
                }
              })
      );
  }
}