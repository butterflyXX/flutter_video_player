import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_player/super_player.dart';
import 'package:video_player/global.dart';
import 'package:video_player/video_player_controller.dart';
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
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ProgressBar(controller: controller),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ValueListenableBuilder(
                  valueListenable: widget.controller.groupController.speed,
                  builder: (context, speed, _) {
                    return speedWidget(
                      "${speed}x",
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            const speeds = <double>[0.25, 0.5, 1, 1.5, 2];
                            return SpeedDialog(
                              source: speeds,
                              selected: speed,
                              onTap: (index) {
                                controller.groupController.setSpeed(speeds[index]);
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                const SizedBox(width: 20),
                ValueListenableBuilder(
                  valueListenable: controller.groupController.currentBitrate,
                  builder: (context, value, _) {
                    return speedWidget(
                       '${value?.height.toString()}P',
                      onTap: () async {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SpeedDialog(
                              source: controller.groupController.bitrateList.map((item) => '${item.height}P').toList(),
                              selected: '${value?.height.toString()}P',
                              onTap: (index) {
                                controller.groupController.setBitrateIndex(controller.groupController.bitrateList[index]);
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                const SizedBox(width: 20),
              ],
            ),
            SizedBox(
              height: ScreenUtil().bottomBarHeight,
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
                    controller.resume();
                  } else {
                    controller.pause();
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

  Widget speedWidget(String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // color: Colors.white,
            border: Border.all(color: color)),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: color),
          ),
        ),
      ),
    );
  }
}
