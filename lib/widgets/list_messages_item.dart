import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert/bloc/auth/auth_bloc.dart';
import 'package:pet_alert/bloc/auth/auth_state.dart';
import 'package:pet_alert/models/AlertModel.dart';
import 'package:pet_alert/models/MessageModel.dart';
import 'package:pet_alert/styles.dart';
import 'package:timeago/timeago.dart' as timeago;


class ListMessageItem extends StatelessWidget {
  final MessageModel  messageModel;

  ListMessageItem({Key key,
    @required this.messageModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, '/alertDetail', arguments: {"data": messageModel});
    },
      child: Container(
          child: Material(
            child: BlocBuilder<AuthBloc, AuthState>(
              bloc: BlocProvider.of<AuthBloc>(context),
              builder: (context, state) {
                if (state is AuthenticatedState) {
                  return ListTile(
                    leading: (messageModel.owner.id != state.userModel.id) ? Text(messageModel.message) : null, //izquierda
                    trailing: (messageModel.owner.id == state.userModel.id) ? Text(messageModel.message) : null, //derecha
                  );
                } else {
                  return ListTile();
                }

              }
            ),
          )
      )
    );
  }
}