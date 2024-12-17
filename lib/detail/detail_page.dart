
import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/global.dart';
import 'package:video_player/model/item_model.dart';
import 'package:video_player/model/series_model.dart';
import 'package:video_player/my_navigator_observer.dart';
import 'package:video_player/source.dart';
import 'package:video_player/video_list_controller.dart';
import 'package:video_player/widget/play_item.dart';
import 'package:video_player/widget/video_control_widget.dart';

const detailPageRoute = '/detailPageRoute';

class DetailPage extends ConsumerStatefulWidget {
  final SeriesModel model;

  const DetailPage({
    required this.model,
    super.key,
  });

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  late PageController _pageController;

  VideoListController get subController => ref.read(subVideoListProvider.notifier).listController;

  VideoListController get controller => ref.read(homeVideoListProvider.notifier).listController;

  @override
  void initState() {
    final item = widget.model.episodeList.firstWhere((it) => it.videoUrl == widget.model.episode.videoUrl);
    final index = widget.model.episodeList.indexOf(item);
    _pageController = PageController(initialPage: index);
    setCurrentVideoPlayerController(index);
    subController.onPlayStart = () {
      subController.currentController?.url.let((url) {
        print('2开始播放 url: $url');
      });
    };
    subController.onPlayFinished = () {
      subController.currentController?.url.let((url) {
        //判断是否是最后一集
        final lastUrl = widget.model.episodeList.last.videoUrl;
        if (lastUrl == url) {
          // 最后一集播放完毕
        } else {
          _pageController.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
        }
      });
    };
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setCurrentVideoPlayerController(int index) {
    final item = widget.model.episodeList[index];
    final current = subController.getController(item.videoUrl);
    subController.setCurrentVideoPlayerController(current);
    final old = widget.model.episode.videoUrl;
    if (old != item.videoUrl) {
      widget.model.episode = item;
      controller.replaceController(old, item.videoUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        allowImplicitScrolling: true,
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: widget.model.episodeList.length,
        itemBuilder: (context, index) {
          final model = widget.model.episodeList[index];
          return PlayItem(
            listController: subController,
            model: model,
            controlBuilder: (context, controller) {
              return VideoControlWidget(controller: controller,);
            },
          );
        },
        onPageChanged: setCurrentVideoPlayerController,
      ),
    );
  }
}
