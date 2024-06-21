import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/utils/colors.dart';
import 'package:whatsapp/common/utils/data.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/features/group/controller/group_controller.dart';
import 'package:whatsapp/features/group/widgets/add_members_group.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});
  static const routeName = '/create-group-screen';

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  File? image;
  final TextEditingController groupNameController = TextEditingController();

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void createGroup() {
    var members = ref.read(selectedGroupMembers);
    if (groupNameController.text.trim().isNotEmpty && members.isNotEmpty) {
      ref.read(groupControllerProvider).createGroup(
            context,
            groupNameController.text.trim(),
            image,
            members,
          );
      ref.read(selectedGroupMembers.notifier).update((state) => []);
      Navigator.pop(context);
    } else {
      showSnackBar(
          context: context,
          content: 'Group name & at least 1 contact must be selcted');
    }
  }

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        backgroundImage: NetworkImage(
                          defaultImage,
                        ),
                        radius: 65,
                      )
                    : CircleAvatar(
                        backgroundImage: FileImage(image!),
                        radius: 65,
                      ),
                Positioned(
                  left: 80,
                  bottom: -10,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(Icons.add_a_photo),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: groupNameController,
                decoration: const InputDecoration(hintText: 'Enter Group Name'),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 8,
                left: 11,
              ),
              child: const Text(
                'Add Members',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const AddMembersGroup(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: createGroup,
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
