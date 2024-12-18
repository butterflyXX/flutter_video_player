
import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/global.dart';
import 'package:video_player/model/ad_item_model.dart';
import 'package:video_player/model/item_model.dart';
import 'package:video_player/model/series_model.dart';
import 'package:video_player/my_navigator_observer.dart';
import 'package:video_player/provider/detail_provider.dart';
import 'package:video_player/source.dart';
import 'package:video_player/video_list_controller.dart';
import 'package:video_player/widget/ad_item.dart';
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

  final List<dynamic> dataList = [];

  @override
  void initState() {

    for (var item in widget.model.episodeList) {
      final index = widget.model.episodeList.indexOf(item);
      dataList.add(item);

      // 模拟广告位插入
      if (index == 2 || index == 8 || index == 12 || index == 17 || index == 24 || index == 33) {
        dataList.insert(index+1, AdItemModel());
      }
    }

    final item = widget.model.episodeList.firstWhere((it) => it.videoUrl == widget.model.episode.videoUrl);
    final index = dataList.indexOf(item);
    _pageController = PageController(initialPage: index);
    setCurrentVideoPlayerController(index);
    subController.onPlayStart = () {
      subController.currentController?.url.let((url) {
        final lastUrl = dataList.last.videoUrl;
        if (lastUrl == url) {
          // 最后一集播放开始
          loadNext();
        }
      });
    };
    subController.onPlayFinished = () {
      subController.currentController?.url.let((url) {
        //判断是否是最后一集
        final lastUrl = dataList.last.videoUrl;
        if (lastUrl == url) {
          // 最后一集播放完毕
        } else {
          _pageController.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
        }
      });
    };
    super.initState();
  }

  Future<void> loadNext() async {
    print('[loadNext] 加载下一部剧');
    // 模拟请求下一部剧
    await Future.delayed(Durations.extralong4);
    final nextIndex = (data.indexOf(widget.model) + 1) % data.length;
    final next = data[nextIndex];

    final baseIndex = dataList.length;
    for (var item in next.episodeList) {
      dataList.add(item);
      final index = next.episodeList.indexOf(item);
      // 模拟广告位插入
      if (index == 2 || index == 8 || index == 12 || index == 17 || index == 24 || index == 33) {
        dataList.insert(baseIndex + index+1, AdItemModel());
      }
    }
    setState(() {

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setCurrentVideoPlayerController(int index) {
    final item = dataList[index];
    if (item is ItemModel) {
      final current = subController.getController(item.videoUrl);
      subController.setCurrentVideoPlayerController(controller: current);
      final old = widget.model.episode.videoUrl;
      if (old != item.videoUrl) {
        widget.model.episode = item;
        controller.replaceController(old, item.videoUrl);
      }
    } else {
      if (item is AdItemModel && item.watchCount.value != 0) {
        ref.read(detailProvider(widget.model.id).notifier).countDownAdItem(item);
      }
      subController.setCurrentVideoPlayerController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer(
        builder: (context, ref, child) {
          final canScroll = ref.watch(detailProvider(widget.model.id));
          return PageView.builder(
            allowImplicitScrolling: true,
            controller: _pageController,
            physics: canScroll ? null : const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final model = dataList[index];
              if (model is ItemModel) {
                return PlayItem(
                  listController: subController,
                  model: model,
                  controlBuilder: (context, controller) {
                    return VideoControlWidget(controller: controller,);
                  },
                );
              } else {
                return AdItem(model: model);
              }
            },
            onPageChanged: setCurrentVideoPlayerController,
          );
        },
      )
    );
  }
}
