import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/features/status/repository/status_repository.dart';
import 'package:whatsapp/models/status.dart';

final statusControllerProvider = Provider((ref) {
  final statusRepository = ref.read(statusRepositoryProvider);
  return StatusController(
    statusRepository: statusRepository,
    ref: ref,
  );
});

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;

  StatusController({
    required this.statusRepository,
    required this.ref,
  });

  void addStatus({
    required BuildContext context,
    required File file,
  }) {
    ref.watch(userDataAuthProvider).whenData((value) {
      statusRepository.uploadStatus(
        context: context,
        username: value!.name,
        profilePic: value.profilePic,
        phoneNumber: value.phoneNumber,
        statusImage: file,
      );
    });
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = await statusRepository.getStatus(context);
    return statusData;
  }
}
