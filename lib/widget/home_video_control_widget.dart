import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_player/super_player.dart';
import 'package:video_player/global.dart';
import 'package:video_player/model/series_model.dart';
import 'package:video_player/util/safe_size.dart';
import 'package:video_player/video_player_controller.dart';
import 'package:video_player/widget/interaction_widget.dart';
import 'package:video_player/widget/progress_bar.dart';
import 'package:video_player/widget/speed_dialog.dart';
import 'package:video_player/widget/tag_widget.dart';

class HomeVideoControlWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final SeriesModel seriesModel;
  final VoidCallback? onTap;

  const HomeVideoControlWidget({
    required this.controller,
    required this.seriesModel,
    this.onTap,
    super.key,
  });

  @override
  State<HomeVideoControlWidget> createState() => _HomeVideoControlWidgetState();
}

class _HomeVideoControlWidgetState extends State<HomeVideoControlWidget> {
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
    return Padding(
      padding: EdgeInsets.only(left: 10.w),
      child: GestureDetector(
        onTap: widget.onTap,
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
                          height: 45.w,
                          width: 30.w,
                          child: Image.network(
                            widget.seriesModel.cover,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.seriesModel.episode.name,
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
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
                            SizedBox(height: 2.w),
                            Row(
                              children: [
                                TagWidget(text: '玄幻仙侠'),
                                SizedBox(width: 4.w),
                                TagWidget(text: '演员·周朕'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.w),
                  Text(
                    '第${widget.seriesModel.episode.index}集 | ${widget.seriesModel.desc}',
                    style: TextStyle(color: color),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.w),
                  toDetailWidget(),
                  SizedBox(height: 10.w),
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

  Widget toDetailWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.w),
        color: color.withOpacity(0.2),
      ),
      child: Row(
        children: [
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              '观看完整短剧·全${widget.seriesModel.episodeCount}集',
              style: const TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: color,
          ),
        ],
      ),
    );
  }
}
