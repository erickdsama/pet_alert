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
  InitialChatEvent();
}
