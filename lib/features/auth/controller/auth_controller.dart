import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/auth/repository/auth_repository.dart';

final authControllerProvider = Provider(
  (ref) {
    final authRepositry = ref.watch(authRepositoryProvider);
    return AuthController(authRepositry: authRepositry, ref: ref);
  },
);

class AuthController {
  final AuthRepository authRepositry;
  final ProviderRef ref;
  AuthController({
    required this.authRepositry,
    required this.ref,
  });

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepositry.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP) {
    authRepositry.verifyOTP(
      context: context,
      verificationId: verificationId,
      userOTP: userOTP,
    );
  }

  void saveUserDataToFirebase(
      BuildContext context, String name, File? profilePic) {
    authRepositry.saveUserDataToFirebase(
      context: context,
      name: name,
      profilePic: profilePic,
      ref: ref,
    );
  }
}
