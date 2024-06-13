import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/common/enums/message_enum.dart';
import 'package:whatsapp/features/chat/widgets/video_player.dart';

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
            textAlign: TextAlign.left,
            file,
            style: const TextStyle(fontSize: 16),
          )
        : messageType == MessageEnum.video
            ? VideoPlayer(videoUrl: file)
            : messageType == MessageEnum.gif
                ? CachedNetworkImage(imageUrl: file)
                : CachedNetworkImage(imageUrl: file);
  }
}
