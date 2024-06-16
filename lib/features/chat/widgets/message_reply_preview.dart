import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/enums/message_enum.dart';
import 'package:whatsapp/common/providers/message_reply_to_provider.dart';
import 'package:whatsapp/common/utils/colors.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final messageReply = ref.watch(messageReplyProvider);
    return Container(
      alignment: Alignment.bottomLeft,
      margin: const EdgeInsets.only(top: 6, left: 8),
      decoration: const BoxDecoration(
        color: mobileChatBoxColor,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      width: size.width - 70,
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  messageReply!.isMe ? 'You' : 'Opp',
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () => cancelReply(ref),
                child: const Icon(Icons.close, size: 16),
              )
            ],
          ),
          const SizedBox(height: 8),
          messageReply.messageType == MessageEnum.text
              ? Text(
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  messageReply.message,
                  style: const TextStyle(fontSize: 17),
                )
              : Text(messageReply.messageType.type),
        ],
      ),
    );
  }
}
