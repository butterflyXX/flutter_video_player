import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_player/super_player.dart';
import 'package:video_player/global.dart';
import 'package:video_player/util/safe_size.dart';
import 'package:video_player/video_player_controller.dart';
import 'package:video_player/widget/progress_bar.dart';
import 'package:video_player/widget/speed_dialog.dart';

class HomeVideoControlWidget extends StatefulWidget {
  final VideoPlayerController controller;

  const HomeVideoControlWidget({
    required this.controller,
    super.key,
  });

  @override
  State<HomeVideoControlWidget> createState() => _VideoControlWidgetState();
}

class _VideoControlWidgetState extends State<HomeVideoControlWidget> {
  late final controller = widget.controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ProgressBar(controller: controller),
            ),
          ],
        ),
        Center(
          child: StreamBuilder(
            stream: controller.onPlayerState,
            builder: (context, snapshot) {
              return IconButton(
                onPressed: () {
                  if (controller.playState == TXPlayerState.paused) {
                    controller.groupController.resume();
                  } else {
                    controller.groupController.pause();
                  }
                },
                icon: Icon(
                  controller.playState == TXPlayerState.paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  size: 80,
                  color: color,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
