import 'package:flutter/material.dart';
import 'package:super_player/super_player.dart';

class VideoPlayer extends StatelessWidget {
  final double aspectRatio;

  final TXPlayerController controller;

  final BoxFit fit;

  const VideoPlayer({
    required this.aspectRatio,
    required this.controller,
    this.fit = BoxFit.cover,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      return ClipRect(
        child: SizedBox(
          height: cons.maxHeight,
          width: cons.maxWidth,
          child: FittedBox(
            fit: fit,
            child: SizedBox(
              height: cons.maxHeight,
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: TXPlayerVideo(controller: controller),
              ),
            ),
          ),
        ),
      );
    });
  }
}
