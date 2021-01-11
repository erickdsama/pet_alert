import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pet_alert/models/UserModel.dart';

@immutable
abstract class LoginState extends Equatable{
  const LoginState();
  @override
  List<Object> get props => [];
}

class InitialLoginState extends LoginState {}
class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserModel userModel;
  LoginSuccess({this.userModel});

  @override
  List<Object> get props => [userModel];
}
class LoginError extends LoginState {}
