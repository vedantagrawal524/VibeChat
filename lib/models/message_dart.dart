import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/common/enums/message_enum.dart';

class Message {
  final String senderId;
  final String reciverUserId;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;

  Message({
    required this.senderId,
    required this.reciverUserId,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
  });
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'reciverUserId': reciverUserId,
      'text': text,
      'type': type.type,
      'timeSent': Timestamp.fromDate(timeSent),
      'messageId': messageId,
      'isSeen': isSeen,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      reciverUserId: map['reciverUserId'] ?? '',
      text: map['text'] ?? '',
      type: (map['type'] as String).toEnum(),
      timeSent: (map['timeSent'] as Timestamp).toDate(),
      messageId: map['messageId'] ?? '',
      isSeen: map['isSeen'] ?? '',
    );
  }
}
