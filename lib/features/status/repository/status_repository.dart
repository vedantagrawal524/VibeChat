import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/common/repository/common_firebase_storage_repository.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/models/status.dart';
import 'package:whatsapp/models/user_model.dart';

final statusRepositoryProvider = Provider(
  (ref) => StatusRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  StatusRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });
  void uploadStatus({
    required BuildContext context,
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
  }) async {
    try {
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            '/status/$uid/$statusId',
            statusImage,
          );
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
          sorted: true,
        );
      }
      List<String> whoCanSeeUid = [];
      for (int i = 0; i < contacts.length; i++) {
        if (contacts[i].phones.isNotEmpty) {
          var userData = await firestore
              .collection('users')
              .where(
                'phoneNumber',
                isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''),
              )
              .get();
          if (userData.docs.isNotEmpty) {
            var user = UserModel.fromMap(userData.docs[0].data());
            whoCanSeeUid.add(user.uid);
          }
        }
      }
      List<String> statusImageUrls = [];
      var statusSnapshot = await firestore
          .collection('status')
          .where(
            'uid',
            isEqualTo: auth.currentUser!.uid,
          )
          .get();
      if (statusSnapshot.docs.isNotEmpty) {
        Status status = Status.fromMap(statusSnapshot.docs[0].data());
        statusImageUrls = status.photoUrls;
        statusImageUrls.add(imageUrl);
        await firestore
            .collection('status')
            .doc(statusSnapshot.docs[0].id)
            .update({
          'photoUrls': statusImageUrls,
          'whoCanSee': whoCanSeeUid,
        });
      } else {
        statusImageUrls = [imageUrl];
        Status status = Status(
          uid: uid,
          username: username,
          phoneNumber: phoneNumber,
          photoUrls: statusImageUrls,
          uploadedAt: DateTime.now(),
          profilePic: profilePic,
          statusId: statusId,
          whoCanSee: whoCanSeeUid,
        );
        await firestore.collection('status').doc(statusId).set(status.toMap());
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = [];
    try {
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
          sorted: true,
        );
      }
      for (int i = 0; i < contacts.length; i++) {
        if (contacts[i].phones.isNotEmpty) {
          var statusSnapshot = await firestore
              .collection('status')
              .where(
                'phoneNumber',
                isEqualTo: contacts[i].phones[0].number.replaceAll(' ', ''),
              )
              .where(
                'uploadedAt',
                isGreaterThan: Timestamp.fromDate(
                    DateTime.now().subtract(const Duration(hours: 24))),
              )
              .get();
          for (var tempData in statusSnapshot.docs) {
            Status tempStatus = Status.fromMap(tempData.data());
            if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
              statusData.add(tempStatus);
            }
          }
        }
      }
    } catch (e) {
      // if (kDebugMode) print(e);
      showSnackBar(context: context, content: e.toString());
    }
    return statusData;
  }
}
