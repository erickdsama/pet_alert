import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pet_alert/models/UserModel.dart';
import 'package:pet_alert/repo/login_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_alert/repo/user_repo.dart';
import 'package:pet_alert/utils.dart';
import 'bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginRepo loginRepo;
  UserRepo userRepo;

  @override
  LoginState get initialState => InitialLoginState();
  LoginBloc({this.loginRepo, this.userRepo});

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginGoogle) {
      LoginLoading();
      User gUser = await getUser();
      print("gUser $gUser");
      if (gUser == null) {
        gUser = await loginRepo.signInWithGoogle();
      }
      if (gUser == null) {

      } else {
        UserModel userModel = UserModel(
            name: gUser.displayName,
            photo: gUser.photoURL,
            gUser: gUser.uid,
            email: gUser.email
        );
        try {
          UserModel userCreated = await userRepo.postUser(userModel);
          yield LoginSuccess(userModel: userCreated);
        } catch (e) {
          LoginError();
        }
      }
      
    }

  }
}
