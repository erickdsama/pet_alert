import 'package:flutter/material.dart';
import 'package:pet_alert/services/AuthService.dart';

import '../globals.dart';
import 'forms/loginForm.dart';



class LoginPage extends StatelessWidget{
  LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: const Color(0xFF24B299),
      body:  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png", fit: BoxFit.fitWidth, width: 180,),
              Text(appName, style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
              Divider(),
              LoginForm()
            ],
          )
        )
    );
  }
}

