import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp/common/enums/message_enum.dart';
import 'package:whatsapp/common/utils/colors.dart';
import 'package:whatsapp/features/chat/widgets/display_file.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    super.key,
    required this.message,
    required this.date,
    required this.messageType,
    required this.onRightSwipe,
    required this.repliedToMessage,
    required this.repiledToUser,
    required this.replyToType,
  });
  final String message;
  final String date;
  final MessageEnum messageType;
  final VoidCallback onRightSwipe;
  final String repliedToMessage;
  final String repiledToUser;
  final MessageEnum replyToType;

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedToMessage.isNotEmpty;
    return SwipeTo(
      onRightSwipe: (details) {
        onRightSwipe();
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
            minWidth: 100,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: messageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: messageType == MessageEnum.text
                      ? const EdgeInsets.only(
                          left: 7,
                          right: 10,
                          top: 5,
                          bottom: 20,
                        )
                      : const EdgeInsets.only(
                          left: 5,
                          right: 5,
                          top: 5,
                          bottom: 20,
                        ),
                  child: Column(
                    children: [
                      if (isReplying) ...[
                        Text(
                          repiledToUser,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: backgroundColor.withOpacity(0.5),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: DisplayFile(
                            file: repliedToMessage,
                            messageType: replyToType,
                          ),
                        ),
                        const SizedBox(height: 3),
                      ],
                      DisplayFile(
                        file: message,
                        messageType: messageType,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 5,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.done_all,
                        size: 17.5,
                        color: Colors.white60,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
