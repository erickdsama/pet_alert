import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent {}



class LoginGoogle extends LoginEvent {
  LoginGoogle();
  @override
  List<Object> get props => [];
}
class LoginApple extends LoginEvent {
  @override
  List<Object> get props => [];
}
