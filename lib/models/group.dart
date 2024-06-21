import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  final String senderId;
  final String name;
  final String groupId;
  final String lastMessage;
  final String groupPic;
  final List<String> membersUid;
  final DateTime timeCreated;
  final DateTime lastMsgtimeSent;
  Group({
    required this.senderId,
    required this.name,
    required this.groupId,
    required this.lastMessage,
    required this.groupPic,
    required this.membersUid,
    required this.timeCreated,
    required this.lastMsgtimeSent,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'name': name,
      'groupId': groupId,
      'lastMessage': lastMessage,
      'groupPic': groupPic,
      'membersUid': membersUid,
      'timeCreated': Timestamp.fromDate(timeCreated),
      'lastMsgtimeSent': Timestamp.fromDate(lastMsgtimeSent),
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      senderId: map['senderId'] ?? '',
      name: map['name'] ?? '',
      groupId: map['groupId'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      groupPic: map['groupPic'] ?? '',
      membersUid: List<String>.from(map['membersUid']),
      timeCreated: (map['timeCreated'] as Timestamp).toDate(),
      lastMsgtimeSent: (map['lastMsgtimeSent'] as Timestamp).toDate(),
    );
  }
}
