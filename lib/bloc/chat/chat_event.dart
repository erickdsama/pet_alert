part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {
  const ChatEvent();
  @override
  List<Object> get props => [];
}

class UpdateChatList extends ChatEvent {
  final List<String> changes;

  UpdateChatList(this.changes);
  List<Object> get props => [changes];
}

class InitialChatEvent extends ChatEvent {
  final UserModel loggedUser;
  InitialChatEvent(this.loggedUser);
  List<Object> get props => [loggedUser];
}

class NewChatEvent extends ChatEvent {
  final UserModel owner;
  final UserModel receiver;
  final String message;

  NewChatEvent(this.owner, this.receiver, this.message);

  List<Object> get props => [owner, receiver, message];
}
