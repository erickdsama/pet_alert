import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert/bloc/login/login_bloc.dart';
import 'package:pet_alert/bloc/login/login_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pet_alert/models/UserModel.dart';
import 'package:pet_alert/repo/user_repo.dart';

class LoginForm extends StatefulWidget{
  @override
  State<LoginForm> createState() => _LoginFormState();
}


_signInWithGoogle(context) async {
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication googleAuth =
  await googleUser.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

  final User user =
      (await FirebaseAuth.instance.signInWithCredential(credential)).user;
  if (user != null) {
//    Navigator.popAndPushNamed(context, '/listPets', arguments: {});
    UserRepo userRepo = UserRepo();
    UserModel userModel = UserModel(
      name: user.displayName,
      photo: user.photoURL,
      gUser: user.uid,
      email: user.email

    );
    userRepo.postUser(userModel);

  }
  print("USSSSEEEEERRRRR: $user");
}

class _LoginFormState extends State<LoginForm> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;
  // Define an async function to initialize FlutterFire

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {

      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state){
          return Form(
              child: Center(
                child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [
                        FlatButton(
                            onPressed: () => _signInWithGoogle(context),
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
      ),
    );
  }

}