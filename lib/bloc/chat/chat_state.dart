part of 'chat_bloc.dart';

@immutable
abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];

}

class ChatInitial extends ChatState {}

class ChatListenState extends ChatState {}

class ChatChangeData extends ChatState {}

class ChatLoadedState extends ChatState {
  final List<ChatModel> chats;

  ChatLoadedState({@required this.chats});
  @override
  List<Object> get props => [chats];

}
