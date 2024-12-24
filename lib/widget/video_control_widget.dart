import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_player/super_player.dart';
import 'package:video_player/global.dart';
import 'package:video_player/model/item_model.dart';
import 'package:video_player/model/series_model.dart';
import 'package:video_player/provider/clear_screen_provider.dart';
import 'package:video_player/video_player_controller.dart';
import 'package:video_player/widget/interaction_widget.dart';
import 'package:video_player/widget/progress_bar.dart';

class VideoControlWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final SeriesModel seriesModel;
  final ItemModel model;

  const VideoControlWidget({
    required this.controller,
    required this.seriesModel,
    required this.model,
    super.key,
  });

  @override
  State<VideoControlWidget> createState() => _VideoControlWidgetState();
}

class _VideoControlWidgetState extends State<VideoControlWidget> {
  late final controller = widget.controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      return SizedBox(
        height: cons.maxHeight,
        width: cons.maxWidth,
        child: Stack(
          alignment: Alignment.bottomCenter,
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
                    child: controller.playState == TXPlayerState.paused
                        ? const Icon(
                            Icons.play_arrow_rounded,
                            size: 60,
                            color: color,
                          )
                        : Container(),
                  );
                },
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _contentItem(),
                SizedBox(height: 4.w),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ProgressBar(controller: controller),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _contentItem() {
    return Consumer(
      builder: (context, ref, child) {
        return AnimatedOpacity(
          opacity: ref.watch(clearScreenProvider) ? 0 : 1,
          duration: Durations.medium1,
          child: IgnorePointer(
            ignoring: ref.watch(clearScreenProvider),
            child: child!,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.w),
                        child: SizedBox(
                          height: 25.w,
                          width: 20.w,
                          child: Image.network(
                            widget.seriesModel.cover,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Text(
                          widget.model.name,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: color,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.w),
                  Text(
                    '第${widget.model.index}集 | ${widget.seriesModel.desc}',
                    style: const TextStyle(color: color),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 20.w),
            Padding(
              padding: EdgeInsets.only(bottom: 30.w),
              child: const InteractionWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
