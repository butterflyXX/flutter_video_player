import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_player/super_player.dart';
import 'package:video_player/global.dart';
import 'package:video_player/model/item_model.dart';
import 'package:video_player/video_list_controller.dart';
import 'package:video_player/video_player_controller.dart';
import 'package:video_player/widget/video_player.dart';

typedef ControlWidgetBuilder = Widget Function(BuildContext context, VideoPlayerController controller);

class PlayItem extends StatefulWidget {
  final ItemModel model;
  final VideoListController listController;
  final ControlWidgetBuilder controlBuilder;
  final ControlWidgetBuilder placeholderBuilder;

  const PlayItem({
    required this.model,
    required this.listController,
    required this.controlBuilder,
    required this.placeholderBuilder,
    super.key,
  });

  @override
  State<PlayItem> createState() => _PlayItemState();
}

class _PlayItemState extends State<PlayItem> {
  late final controller = widget.listController.getController(widget.model.videoUrl);

  @override
  void dispose() {
    widget.listController.disposeCache(controller);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.aspectRatio,
      builder: (context, aspectRatio, child) {
        return Stack(
          children: [
            Positioned.fill(child: widget.placeholderBuilder(context, controller),),
            if (aspectRatio != 0)
              Center(
                child: VideoPlayer(
                  aspectRatio: aspectRatio,
                  controller: controller,
                ),
              ),
            child!,
          ],
        );
      },
      child: widget.controlBuilder(context, controller),
    );
  }
}
