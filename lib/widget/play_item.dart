import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_player/super_player.dart';
import 'package:video_player/global.dart';
import 'package:video_player/model/item_model.dart';
import 'package:video_player/video_list_controller.dart';
import 'package:video_player/widget/video_control_widget.dart';

class PlayItem extends StatefulWidget {
  final ItemModel model;
  final VideoListController listController;

  const PlayItem({
    required this.model,
    required this.listController,
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
            if (aspectRatio != 0)
              Center(
                child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: TXPlayerVideo(controller: controller),
                ),
              ),
            child!,
            appbar(),
          ],
        );
      },
      child: VideoControlWidget(
        controller: controller,
      ),
    );
  }

  Widget appbar() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
      child: Row(
        children: [
          (ModalRoute.of(context)?.canPop ?? false) ? IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: color,
            ),
          ): const SizedBox(width: 10,),
          Expanded(
            child: Text(
              widget.model.name,
              style: const TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: color,
              )),
        ],
      ),
    );
  }
}
