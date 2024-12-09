import 'package:flutter/material.dart';
import 'package:super_player/super_player.dart';
import 'package:video_player/video_list_controller.dart';
import 'package:video_player/video_player_controller.dart';
import 'package:video_player/widget/buffering_widget.dart';

class PlayItem extends StatefulWidget {
  final String url;
  final VideoListController listController;

  const PlayItem({
    required this.url,
    required this.listController,
    super.key,
  });

  @override
  State<PlayItem> createState() => _PlayItemState();
}

class _PlayItemState extends State<PlayItem> {
  late final controller = widget.listController.getController(widget.url);

  @override
  void dispose() {
    widget.listController.updateCache(controller);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.aspectRatio,
      builder: (context, aspectRatio, child) {
        if (aspectRatio != 0) {
          return Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: TXPlayerVideo(controller: controller),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: (){
                    controller.pause();
                  }, icon: Icon(Icons.pause)),
                  IconButton(onPressed: (){
                    controller.resume();
                  }, icon: Icon(Icons.play_arrow)),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              child!,
              const SizedBox(
                height: 100,
              ),
            ],
          );
        }
      },
      child: const BufferingWidget(),
    );
  }
}
