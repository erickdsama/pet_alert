import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pet_alert/models/UserModel.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class InitialAuthState extends AuthState {}

class AuthenticatedState extends AuthState {
  final UserModel userModel;

  AuthenticatedState({this.userModel});

  @override
  List<Object> get props => [userModel];
}
