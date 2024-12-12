import 'package:flutter/material.dart';
import 'package:video_player/video_player_controller.dart';
import 'package:video_player/widget/progress_bar.dart';

class VideoControlWidget extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoControlWidget({
    required this.controller,
    super.key,
  });

  @override
  State<VideoControlWidget> createState() => _VideoControlWidgetState();
}

class _VideoControlWidgetState extends State<VideoControlWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 100,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ProgressBar(controller: widget.controller),
        ),
        const SizedBox(
          height: 100,
        ),
      ],
    );
  }
}
