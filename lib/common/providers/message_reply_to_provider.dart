import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/enums/message_enum.dart';

class MessageReplyTo {
  final String message;
  final bool isMe;
  final MessageEnum messageType;

  MessageReplyTo({
    required this.message,
    required this.isMe,
    required this.messageType,
  });
}

final messageReplyProvider = StateProvider<MessageReplyTo?>((ref) => null);
