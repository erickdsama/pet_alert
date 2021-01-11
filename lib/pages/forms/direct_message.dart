import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert/bloc/chat/chat_bloc.dart';
import 'package:pet_alert/bloc/message_bloc.dart';
import 'package:pet_alert/models/ChatModel.dart';
import 'package:pet_alert/models/UserModel.dart';
import 'package:pet_alert/repo/user_repo.dart';

class DirectMessageForm extends StatefulWidget{
  @override
  State<DirectMessageForm> createState() => _DirectMessageForm();
}

class _DirectMessageForm extends State<DirectMessageForm> {


  ChatBloc chatBloc;
  MessageBloc messageBloc;
  UserRepo userRepo = UserRepo();

  @override
  void initState() {
    chatBloc = ChatBloc(userRepo);
    ChatModel chatModel = ChatModel(

    );

    messageBloc = MessageBloc(chatModel, chatBloc);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: messageBloc,
      child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Icon(Icons.message, color: Colors.orange,),
                    Text("Enviar mensaje al dueño")
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Expanded(
                      child: CupertinoTextField(
                        autofocus: true,
                        placeholder: "Hola buen día",
                        maxLines: 2,

                      ),
                    ),
                    BlocConsumer<MessageBloc, MessageState>(builder: (context, state){
                      return CupertinoButton(
                          child: Text("Enviar"),
                          onPressed: () {
                            chatBloc.add(NewChatEvent(UserModel(
                              id: "1",
                              name: "Pepe",
                              email: "mail@a.com",
                              photo: "https://scontent.fcjs2-1.fna.fbcdn.net/v/t1.0-9/72416855_962330480782002_2942232170342645760_o.jpg?_nc_cat=100&ccb=2&_nc_sid=09cbfe&_nc_eui2=AeH6pp4Wpyn5B8FBfpve2429GuZYHEmfHBga5lgcSZ8cGN0NsedhVjOU-LQSp0v9dmO_xFLJyZTDd94EQKYmprtK&_nc_ohc=oEqRiQow4tAAX-YeCtw&_nc_ht=scontent.fcjs2-1.fna&oh=4dd909e717e00159393c364ca6bfa22a&oe=601F585E"
                            ), UserModel(
                                id: "2",
                                name: "Juan",
                                email: "mail@a.com",
                                photo: "https://scontent.fcjs2-1.fna.fbcdn.net/v/t1.0-9/72416855_962330480782002_2942232170342645760_o.jpg?_nc_cat=100&ccb=2&_nc_sid=09cbfe&_nc_eui2=AeH6pp4Wpyn5B8FBfpve2429GuZYHEmfHBga5lgcSZ8cGN0NsedhVjOU-LQSp0v9dmO_xFLJyZTDd94EQKYmprtK&_nc_ohc=oEqRiQow4tAAX-YeCtw&_nc_ht=scontent.fcjs2-1.fna&oh=4dd909e717e00159393c364ca6bfa22a&oe=601F585E"
                            ), "message"));
                            // messageBloc.add(SendMessage(message: "null"));

                          });
                    }, listener: (context, state){

                    })
                  ],
                )
              ],
            )
      )
    );
  }
}