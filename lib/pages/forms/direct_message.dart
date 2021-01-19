import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert/bloc/chat/chat_bloc.dart';
import 'package:pet_alert/bloc/message_bloc.dart';
import 'package:pet_alert/models/ChatModel.dart';
import 'package:pet_alert/models/UserModel.dart';
import 'package:pet_alert/repo/couchbase_repo.dart';
import 'package:pet_alert/repo/user_repo.dart';

class DirectMessageForm extends StatefulWidget{
  final UserModel loginUser;
  final UserModel reportAlertUser;

  const DirectMessageForm({Key key, this.loginUser, this.reportAlertUser}) : super(key: key);

  @override
  State<DirectMessageForm> createState() => _DirectMessageForm(loginUser: loginUser, reportAlertUser: reportAlertUser );
}

class _DirectMessageForm extends State<DirectMessageForm> {


  ChatBloc chatBloc;
  MessageBloc messageBloc;
  UserRepo userRepo = UserRepo();
  CouchBaseRepo couchBaseRepo;
  UserModel loginUser;
  UserModel reportAlertUser;
  TextEditingController _directMessageController = TextEditingController();


  _DirectMessageForm({
    this.loginUser,
    this.reportAlertUser
  });

  @override
  void initState() {
    chatBloc = ChatBloc(userRepo);
    ChatModel chatModel = ChatModel(

    );
    couchBaseRepo = CouchBaseRepo();
    messageBloc = MessageBloc(chatModel, chatBloc, couchBaseRepo);

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
                        controller: _directMessageController,
                        placeholder: "Hola buen día",
                        maxLines: 2,

                      ),
                    ),
                    BlocConsumer<MessageBloc, MessageState>(builder: (context, state){
                      return CupertinoButton(
                          child: Text("Enviar"),
                          onPressed: () {
                            chatBloc.add(NewChatEvent(
                                loginUser,
                                reportAlertUser,
                                _directMessageController.text));
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

  @override
  void dispose() async {
    await chatBloc?.close();
    await messageBloc?.close();
    couchBaseRepo.dispose();
    super.dispose();
  }
}