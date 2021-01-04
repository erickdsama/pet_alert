part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();
  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {
  @override
  List<Object> get props => [];
}

class SendingMessage extends MessageState{}
class ErrorSendingMessage extends MessageState{}
class SentMessage extends MessageState{}

class GettingMessages extends MessageState{}

class NewMessages extends MessageState{
  final List<MessageModel> messages;

  NewMessages({@required this.messages});

  @override
  List<Object> get props => [this.messages];

}
