import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_player/super_player.dart';
import 'package:video_player/global.dart';
import 'package:video_player/util/safe_size.dart';
import 'package:video_player/video_player_controller.dart';
import 'package:video_player/widget/button/column_button.dart';
import 'package:video_player/widget/progress_bar.dart';
import 'package:video_player/widget/speed_dialog.dart';

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
  late final controller = widget.controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: StreamBuilder(
            stream: controller.onPlayerState,
            builder: (context, snapshot) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (controller.playState == TXPlayerState.paused) {
                    controller.groupController.resume();
                  } else {
                    controller.groupController.pause();
                  }
                },
                child: controller.playState == TXPlayerState.paused ? const Icon(
                  Icons.play_arrow_rounded,
                  size: 60,
                  color: color,
                ) : Container(),
              );
            },
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _interactionWidget(Icons.star_purple500_sharp, '追剧'),
                SizedBox(height: 20.w),
                _interactionWidget(Icons.chat, '174'),
                SizedBox(height: 20.w),
                _interactionWidget(Icons.favorite, '7828'),
                SizedBox(height: 40.w),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ProgressBar(controller: controller),
            ),
          ],
        ),
      ],
    );
  }

  Widget _interactionWidget(IconData icon, String title) {
    return SizedBox(
      width: 60.w,
      child: ColumnButton(
        top: Icon(
          icon,
          color: color,
          size: 30,
        ),
        bottom: Text(
          title,
          style: const TextStyle(color: color),
        ),
        onTap: () {
          print('123');
        },
      ),
    );
  }
}
