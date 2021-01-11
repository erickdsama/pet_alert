import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:pet_alert/models/UserModel.dart';

@immutable
abstract class AuthEvent extends Equatable{
  const AuthEvent();
  @override
  List<Object> get props => [];
}


class AuthenticateUser extends AuthEvent {
  final UserModel userModel;

  AuthenticateUser({@required this.userModel});
  List<Object> get props => [];
}
