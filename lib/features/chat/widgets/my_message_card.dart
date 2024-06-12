import 'package:flutter/material.dart';
import 'package:whatsapp/common/enums/message_enum.dart';
import 'package:whatsapp/common/utils/colors.dart';
import 'package:whatsapp/features/chat/widgets/display_file.dart';

class MyMessageCard extends StatelessWidget {
  const MyMessageCard({
    super.key,
    required this.message,
    required this.date,
    required this.messageType,
  });
  final String message;
  final String date;
  final MessageEnum messageType;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
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
                        left: 10,
                        right: 30,
                        top: 5,
                        bottom: 20,
                      )
                    : const EdgeInsets.only(
                        left: 5,
                        right: 5,
                        top: 5,
                        bottom: 25,
                      ),
                child: DisplayFile(
                  file: message,
                  messageType: messageType,
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.done_all,
                      size: 20,
                      color: Colors.white60,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
