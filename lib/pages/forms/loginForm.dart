import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert/bloc/login/login_bloc.dart';
import 'package:pet_alert/bloc/login/login_event.dart';
import 'package:pet_alert/bloc/login/login_state.dart';

class LoginForm extends StatefulWidget{
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginBloc loginBloc = BlocProvider.of<LoginBloc>(context);
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state){
        return Form(
            child: Center(
              child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    children: [
                      FlatButton(
                          onPressed: () {
                            loginBloc.add(LoginGoogle());
                          },
                          child: Text("Registrarse", style: TextStyle(fontWeight: FontWeight.bold),),
                          minWidth: double.infinity,
                          textColor: Colors.white,
                          shape: new RoundedRectangleBorder(
                              side: new BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                  style: BorderStyle.solid
                              ),
                              borderRadius: new BorderRadius.circular(50.0)
                          )
                      ),
                      FlatButton(
                          onPressed: () => {
                            Navigator.pushNamed(context, '/listPets', arguments: {})
                          },
                          child: Text("Iniciar Sesión con Google", style: TextStyle(fontWeight: FontWeight.bold),),
                          minWidth: double.infinity,
                          textColor: Colors.green,
                          color: Colors.white,
                          shape: new RoundedRectangleBorder(
                              side: new BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                  style: BorderStyle.solid
                            ),
                            borderRadius: new BorderRadius.circular(50.0)
                          )
                      ),
                  ],
                )
              ),
            )
        );
      },
    );
  }

}