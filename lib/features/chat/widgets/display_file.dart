import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/common/enums/message_enum.dart';

class DisplayFile extends StatelessWidget {
  const DisplayFile({
    super.key,
    required this.file,
    required this.messageType,
  });
  final String file;
  final MessageEnum messageType;

  @override
  Widget build(BuildContext context) {
    return messageType == MessageEnum.text
        ? Text(
            file,
            style: const TextStyle(fontSize: 16),
          )
        : CachedNetworkImage(imageUrl: file);
  }
}
