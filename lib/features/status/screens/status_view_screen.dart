import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/models/status.dart';

class StatusViewScreen extends StatefulWidget {
  const StatusViewScreen({
    super.key,
    required this.status,
  });
  final Status status;
  static const routeName = '/status-view-screen';

  @override
  State<StatefulWidget> createState() => _StatusViewScreenState();
}

class _StatusViewScreenState extends State<StatusViewScreen> {
  StoryController storyController = StoryController();
  List<StoryItem> storyItems = [];

  void initStoryPageItems() {
    for (int i = 0; i < widget.status.photoUrls.length; i++) {
      storyItems.add(StoryItem.pageImage(
        url: widget.status.photoUrls[i],
        controller: storyController,
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    initStoryPageItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.isEmpty
          ? const Loader()
          : StoryView(
              storyItems: storyItems,
              controller: storyController,
              onComplete: () {
                Navigator.pop(context);
              },
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
            ),
    );
  }
}
