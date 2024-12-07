import 'package:flutter/material.dart';
import 'package:super_player/super_player.dart';
import 'package:video_player/video_player_controller.dart';
import 'package:video_player/widget/buffering_widget.dart';

class PlayItem extends StatefulWidget {
  final VideoPlayerController controller;

  const PlayItem({
    required this.controller,
    super.key,
  });

  @override
  State<PlayItem> createState() => _PlayItemState();
}

class _PlayItemState extends State<PlayItem> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller.aspectRatio,
      builder: (context, aspectRatio, child) {
        if (aspectRatio != 0) {
          return Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: TXPlayerVideo(controller: widget.controller),
                ),
              ),
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  widget.controller.resume();
                },
              ),
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
