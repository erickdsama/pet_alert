part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();
  @override
  List<Object> get props => [];
}

class SendMessage extends MessageEvent {
  final UserModel sender;
  final UserModel receiver;
  final String message;

  SendMessage({@required this.message, this.sender, this.receiver,});

  @override
  List<Object> get props => [message];
}

class ListenerMessages extends MessageEvent {
  final String docId;

  ListenerMessages({@required this.docId});

  @override
  List<Object> get props => [docId];
}


class UpdateMessages extends MessageEvent {
  final List<MessageModel> messages;

  UpdateMessages({@required this.messages});

  @override
  List<Object> get props => [messages];
}
