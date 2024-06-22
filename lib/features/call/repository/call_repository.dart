import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/features/call/screens/call_screen.dart';
import 'package:whatsapp/models/call.dart';
import 'package:whatsapp/models/group.dart';

final callRepositoryProvider = Provider(
  (ref) => CallRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CallRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream =>
      firestore.collection('calls').doc(auth.currentUser!.uid).snapshots();

  void makeCall(
    BuildContext context,
    Call senderCallData,
    Call receiverCallData,
  ) async {
    try {
      await firestore
          .collection('calls')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      await firestore
          .collection('calls')
          .doc(senderCallData.receiverId)
          .set(receiverCallData.toMap());
      Navigator.pushNamed(
        context,
        CallScreen.routeName,
        arguments: {
          'channelId': senderCallData.callId,
          'call': senderCallData,
          'isGroupChat': false,
        },
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void makeGroupCall(
    BuildContext context,
    Call senderCallData,
    Call receiverCallData,
  ) async {
    try {
      await firestore
          .collection('calls')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());

      var groupSnapShot = await firestore
          .collection('groups')
          .doc(senderCallData.receiverId)
          .get();
      Group group = Group.fromMap(groupSnapShot.data()!);
      for (var id in group.membersUid) {
        await firestore
            .collection('calls')
            .doc(id)
            .set(receiverCallData.toMap());
      }

      Navigator.pushNamed(
        context,
        CallScreen.routeName,
        arguments: {
          'channelId': senderCallData.callId,
          'call': senderCallData,
          'isGroupChat': true,
        },
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endCall(
    BuildContext context,
    String senderId,
    String receiverId,
  ) async {
    try {
      await firestore.collection('calls').doc(senderId).delete();
      await firestore.collection('calls').doc(receiverId).delete();
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endGroupCall(
    BuildContext context,
    String senderId,
    String receiverId,
  ) async {
    try {
      await firestore.collection('calls').doc(senderId).delete();

      var groupSnapShot =
          await firestore.collection('groups').doc(receiverId).get();
      Group group = Group.fromMap(groupSnapShot.data()!);

      for (var id in group.membersUid) {
        await firestore.collection('calls').doc(id).delete();
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
