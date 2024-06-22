import 'package:cloud_firestore/cloud_firestore.dart';

class Call {
  final String callId;
  final String callerId;
  final String callerName;
  final String callerPic;
  final String receiverId;
  final String receiverName;
  final String receiverPic;
  final bool hasCalled;
  final DateTime calledTime;
  final bool isGroupCall;
  Call({
    required this.callId,
    required this.callerId,
    required this.callerName,
    required this.callerPic,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPic,
    required this.hasCalled,
    required this.calledTime,
    required this.isGroupCall,
  });

  Map<String, dynamic> toMap() {
    return {
      'callId': callId,
      'callerId': callerId,
      'callerName': callerName,
      'callerPic': callerPic,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverPic': receiverPic,
      'hasDialled': hasCalled,
      'calledTime': Timestamp.fromDate(calledTime),
      'isGroupCall': isGroupCall,
    };
  }

  factory Call.fromMap(Map<String, dynamic> map) {
    return Call(
      callId: map['callId'] ?? '',
      callerId: map['callerId'] ?? '',
      callerName: map['callerName'] ?? '',
      callerPic: map['callerPic'] ?? '',
      receiverId: map['receiverId'] ?? '',
      receiverName: map['receiverName'] ?? '',
      receiverPic: map['receiverPic'] ?? '',
      hasCalled: map['hasDialled'] ?? false,
      calledTime: (map['calledTime'] as Timestamp).toDate(),
      isGroupCall: map['isGroupCall'] ?? false,
    );
  }
}
