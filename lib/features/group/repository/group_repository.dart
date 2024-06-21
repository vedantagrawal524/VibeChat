import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/common/repository/common_firebase_storage_repository.dart';
import 'package:whatsapp/common/utils/data.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/models/group.dart' as grp;

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  GroupRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void createGroup(
    BuildContext context,
    String name,
    File? profilePic,
    List<Contact> selectedContacts,
  ) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < selectedContacts.length; i++) {
        if (selectedContacts[i].phones.isNotEmpty) {
          var userCollection = await firestore
              .collection('users')
              .where(
                'phoneNumber',
                isEqualTo:
                    selectedContacts[i].phones[0].number.replaceAll(' ', ''),
              )
              .get();
          if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
            uids.add(userCollection.docs[0].data()['uid']);
          }
        }
      }
      var groupId = const Uuid().v1();
      String photoUrl = defaultImage;
      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              'group/groupPic/$groupId',
              profilePic,
            );
      }
      var timeCreated = DateTime.now();

      grp.Group group = grp.Group(
        groupId: groupId,
        groupPic: photoUrl,
        name: name,
        lastMessage: '',
        membersUid: [auth.currentUser!.uid, ...uids],
        senderId: auth.currentUser!.uid,
        timeCreated: timeCreated,
      );
      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
