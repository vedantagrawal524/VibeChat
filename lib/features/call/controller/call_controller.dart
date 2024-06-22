import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/features/call/repository/call_repository.dart';
import 'package:whatsapp/models/call.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.watch(callRepositoryProvider);
  return CallController(
    callRepository: callRepository,
    auth: FirebaseAuth.instance,
    ref: ref,
  );
});

class CallController {
  final CallRepository callRepository;
  final FirebaseAuth auth;
  final ProviderRef ref;

  CallController({
    required this.callRepository,
    required this.auth,
    required this.ref,
  });

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;

  void makeCall(
    BuildContext context,
    String receiverId,
    String receiverName,
    String receiverPic,
    bool isGroupChat,
  ) {
    ref.read(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v1();
      Call senderCallData = Call(
        callId: callId,
        callerId: value!.uid,
        callerName: value.name,
        callerPic: value.profilePic,
        receiverId: receiverId,
        receiverName: receiverName,
        receiverPic: receiverPic,
        hasCalled: true,
        calledTime: DateTime.now(),
        isGroupCall: isGroupChat,
      );
      Call receiverCallData = Call(
        callId: callId,
        callerId: value.uid,
        callerName: value.name,
        callerPic: value.profilePic,
        receiverId: receiverId,
        receiverName: receiverName,
        receiverPic: receiverPic,
        hasCalled: false,
        calledTime: DateTime.now(),
        isGroupCall: isGroupChat,
      );
      if (isGroupChat) {
        callRepository.makeGroupCall(context, senderCallData, receiverCallData);
      } else {
        callRepository.makeCall(context, senderCallData, receiverCallData);
      }
    });
  }

  void endCall(
    BuildContext context,
    String senderId,
    String receiverId,
    bool isGroupChat,
  ) {
    if (isGroupChat) {
      callRepository.endGroupCall(context, senderId, receiverId);
    } else {
      callRepository.endCall(context, senderId, receiverId);
    }
  }
}
