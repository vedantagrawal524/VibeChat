import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp/common/enums/message_enum.dart';
import 'package:whatsapp/common/providers/message_reply_to_provider.dart';
import 'package:whatsapp/common/utils/colors.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/features/chat/controller/chat_controller.dart';
import 'package:whatsapp/features/chat/widgets/message_reply_preview.dart';

class BottomChatField extends ConsumerStatefulWidget {
  const BottomChatField({
    super.key,
    required this.receiverUserId,
    required this.isGroupChat,
  });
  final String receiverUserId;
  final bool isGroupChat;

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInIt = false;
  bool isRecording = false;
  bool isShowEmojiContainer = false;
  FocusNode focusNode = FocusNode();

  void sendFileMessage(File file, MessageEnum messageType) {
    ref.read(chatControllerProvider).sendFileMessag(
          context,
          file,
          widget.receiverUserId,
          messageType,
          widget.isGroupChat,
        );
  }

  void sendTextOrAudio() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.receiverUserId,
            widget.isGroupChat,
          );
      setState(() {
        _messageController.text = '';
        isShowSendButton = false;
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecorderInIt) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(toFile: path);
      }
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void sendVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void sendGIF() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      ref.read(chatControllerProvider).sendGIFMessage(
            context,
            gif.url,
            widget.receiverUserId,
            widget.isGroupChat,
          );
    }
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      showSnackBar(context: context, content: 'Mic Permission not allowed!');
      return;
    }
    await _soundRecorder!.openRecorder();
    isRecorderInIt = true;
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInIt = false;
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;
    return Column(
      children: [
        isShowMessageReply
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MessageReplyPreview(),
                ],
              )
            : const SizedBox(),
        Row(
          children: [
            const SizedBox(width: 6),
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: _messageController,
                onChanged: (value) {
                  if (value.isNotEmpty && value.trim().isNotEmpty) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: SizedBox(
                      width: 48,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            iconSize: 22,
                            onPressed: toggleEmojiKeyboardContainer,
                            icon: const Icon(Icons.emoji_emotions,
                                color: greyColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: SizedBox(
                      width: 144,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            iconSize: 22,
                            onPressed: sendGIF,
                            icon: const Icon(Icons.gif, color: greyColor),
                          ),
                          IconButton(
                            iconSize: 22,
                            onPressed: sendVideo,
                            icon:
                                const Icon(Icons.attach_file, color: greyColor),
                          ),
                          IconButton(
                            iconSize: 22,
                            onPressed: sendImage,
                            icon:
                                const Icon(Icons.camera_alt, color: greyColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                  hintText: 'Message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 5,
                right: 5,
                top: 5,
                left: 5,
              ),
              child: CircleAvatar(
                backgroundColor: sendButtonColor,
                radius: 25,
                child: GestureDetector(
                  onTap: sendTextOrAudio,
                  child: Icon(
                    isShowSendButton
                        ? Icons.send
                        : isRecording
                            ? Icons.close
                            : Icons.mic,
                    color: whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        isShowEmojiContainer
            ? SizedBox(
                height: 278,
                child: EmojiPicker(
                  config: const Config(
                    swapCategoryAndBottomBar: true,
                    bottomActionBarConfig: BottomActionBarConfig(
                      backgroundColor: mobileChatBoxColor,
                      buttonColor: mobileChatBoxColor,
                      buttonIconColor: greyColor,
                    ),
                    searchViewConfig: SearchViewConfig(
                      backgroundColor: mobileChatBoxColor,
                      buttonIconColor: greyColor,
                    ),
                    emojiViewConfig: EmojiViewConfig(
                      backgroundColor: mobileChatBoxColor,
                      columns: 8,
                    ),
                    categoryViewConfig: CategoryViewConfig(
                      backgroundColor: mobileChatBoxColor,
                      iconColor: greyColor,
                      iconColorSelected: whiteColor,
                      indicatorColor: tabColor,
                      initCategory: Category.SMILEYS,
                      recentTabBehavior: RecentTabBehavior.RECENT,
                    ),
                    skinToneConfig: SkinToneConfig(
                      enabled: true,
                      dialogBackgroundColor: backgroundColor,
                      indicatorColor: greyColor,
                    ),
                  ),
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      _messageController.text =
                          _messageController.text + emoji.emoji;
                    });
                    if (!isShowSendButton) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    }
                  },
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
