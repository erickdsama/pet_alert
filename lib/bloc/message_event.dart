part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();
  @override
  List<Object> get props => [];
}

class SendMessage extends MessageEvent {
  final String message;

  SendMessage({@required this.message});

  @override
  List<Object> get props => [message];
}
