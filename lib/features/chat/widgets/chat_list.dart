import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/common/enums/message_enum.dart';
import 'package:whatsapp/common/providers/message_reply_to_provider.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/features/chat/controller/chat_controller.dart';
import 'package:whatsapp/features/chat/widgets/my_message_card.dart';
import 'package:whatsapp/features/chat/widgets/sender_message_card.dart';
import 'package:whatsapp/models/message.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({
    super.key,
    required this.receiverUserId,
    required this.isGroupChat,
  });
  final String receiverUserId;
  final bool isGroupChat;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();
  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void onMessageSwipe(
    String message,
    bool isMe,
    MessageEnum type,
  ) {
    ref.read(messageReplyProvider.notifier).update(
          (state) => MessageReplyTo(
            message: message,
            isMe: isMe,
            messageType: type,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: widget.isGroupChat
          ? ref
              .watch(chatControllerProvider)
              .groupChatStream(widget.receiverUserId)
          : ref.watch(chatControllerProvider).chatStream(widget.receiverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        } else if (snapshot.hasError) {
          return const Center(child: Text('Try again Later!'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No Messages found.'));
        }
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          messageController.jumpTo(messageController.position.maxScrollExtent);
        });
        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var message = snapshot.data![index];
            var timeSent = DateFormat.Hm().format(message.timeSent);
            if (!message.isSeen &&
                message.reciverUserId ==
                    FirebaseAuth.instance.currentUser!.uid) {
              ref.read(chatControllerProvider).setMessageSeen(
                    context,
                    widget.receiverUserId,
                    message.messageId,
                  );
            }
            if (message.senderId == FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: message.text,
                date: timeSent,
                messageType: message.type,
                onRightSwipe: () => onMessageSwipe(
                  message.text,
                  true,
                  message.type,
                ),
                repliedToMessage: message.repliedToMessage,
                repiledToUser: message.repliedToUser,
                replyToType: message.replyToType,
                isSeen: message.isSeen,
              );
            } else {
              return SenderMessageCard(
                message: message.text,
                date: timeSent,
                messageType: message.type,
                onRightSwipe: () => onMessageSwipe(
                  message.text,
                  false,
                  message.type,
                ),
                repliedToMessage: message.repliedToMessage,
                repiledToUser: message.repliedToUser,
                replyToType: message.replyToType,
                isGroupChat: widget.isGroupChat,
              );
            }
          },
        );
      },
    );
  }
}
