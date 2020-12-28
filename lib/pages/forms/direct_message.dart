import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert/bloc/message_bloc.dart';

class DirectMessageForm extends StatefulWidget{
  @override
  State<DirectMessageForm> createState() => _DirectMessageForm();
}

class _DirectMessageForm extends State<DirectMessageForm> {

  @override
  Widget build(BuildContext context) {

    return BlocListener<MessageBloc, MessageState>(
      listener: (context, state) {

      },
      child: BlocBuilder<MessageBloc, MessageState>(
        builder: (context, state){
          return Form(
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

                            });
                      }, listener: (context, state){

                      })
                    ],
                  )
                ],
              )
          );
        },
      ),
    );
  }

}