import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/utils/colors.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/features/chat/widgets/bottom_chat_field.dart';
import 'package:whatsapp/models/user_model.dart';
import 'package:whatsapp/features/chat/widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  const MobileChatScreen({
    super.key,
    required this.name,
    required this.uid,
  });
  final String name;
  final String uid;
  static const routeName = '/mobile-chat-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: StreamBuilder<UserModel>(
          stream: ref.read(authControllerProvider).userDataById(uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 18.5),
                ),
                Text(
                  snapshot.data!.isOnline ? 'online' : 'offline',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            );
          },
        ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.video_call,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.call,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
              )),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: ChatList(receiverUserId: uid)),
          BottomChatField(receiverUserId: uid),
        ],
      ),
    );
  }
}
