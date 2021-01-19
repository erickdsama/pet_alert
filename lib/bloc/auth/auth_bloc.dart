import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:pet_alert/bloc/login/bloc.dart';
import './bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  LoginBloc loginBloc;
  StreamSubscription loginBlocSubscription;

  @override
  AuthState get initialState => InitialAuthState();


  AuthBloc({this.loginBloc}) {
    loginBlocSubscription = this.loginBloc.listen((state) {
      if (state is LoginSuccess) {
        print("user model -> ${state.userModel.id}");
        add(AuthenticateUser(userModel: state.userModel));
      }
    });
  }

  @override
  Future<void> close() {
    loginBlocSubscription.cancel();
    return super.close();
  }


  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthenticateUser) {
      yield AuthenticatedState(userModel: event.userModel);

    }

  }
}
