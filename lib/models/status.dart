import 'package:cloud_firestore/cloud_firestore.dart';

class Status {
  final String uid;
  final String username;
  final String phoneNumber;
  final List<String> photoUrls;
  final DateTime uploadedAt;
  final String profilePic;
  final String statusId;
  final List<String> whoCanSee;

  Status({
    required this.uid,
    required this.username,
    required this.phoneNumber,
    required this.photoUrls,
    required this.uploadedAt,
    required this.profilePic,
    required this.statusId,
    required this.whoCanSee,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'phoneNumber': phoneNumber,
      'photoUrls': photoUrls,
      'uploadedAt': Timestamp.fromDate(uploadedAt),
      'profilePic': profilePic,
      'statusId': statusId,
      'whoCanSee': whoCanSee,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photoUrls: List<String>.from(map['photoUrls']),
      uploadedAt: (map['uploadedAt'] as Timestamp).toDate(),
      profilePic: map['profilePic'] ?? '',
      statusId: map['statusId'] ?? '',
      whoCanSee: List<String>.from(map['whoCanSee']),
    );
  }
}
