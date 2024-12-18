
import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/detail/detail_data_provider.dart';
import 'package:video_player/global.dart';
import 'package:video_player/home/home_data_provider.dart';
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
  final String seriesId;
  final double? initPosition;

  const DetailPage({
    required this.seriesId,
    this.initPosition,
    super.key,
  });

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {

  late final vm = ref.read(detailDataProvider.notifier);

  @override
  void initState() {
    load();
    detailVideoController.onPlayStart = () {
      detailVideoController.currentController?.url.let((url) {
        final lastUrl = vm.dataList.last.videoUrl;
        if (lastUrl == url) {
          // 最后一集播放开始
          loadNext();
        }
      });
    };
    detailVideoController.onPlayFinished = () {
      detailVideoController.currentController?.url.let((url) {
        //判断是否是最后一集
        final lastUrl = vm.dataList.last.videoUrl;
        if (lastUrl == url) {
          // 最后一集播放完毕
        } else {
          vm.pageController?.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
        }
      });
    };
    super.initState();
  }

  /// 模拟请求剧
  Future<void> load() async {
    print('[load] 加载剧');
    await Future.delayed(Durations.short1);
    final model = data.firstWhere((item) => item.id == widget.seriesId);

    final baseIndex = vm.dataList.length;
    for (var item in model.episodeList) {
      final index = model.episodeList.indexOf(item);
      vm.dataList.add(item);

      // 模拟广告位插入
      if (index == 2 || index == 8 || index == 12 || index == 17 || index == 24 || index == 33) {
        vm.dataList.insert(baseIndex + index+1, AdItemModel());
      }
    }
    final item = model.episodeList.firstWhere((it) => it.videoUrl == model.episode.videoUrl);
    final index = vm.dataList.indexOf(item);
    vm.pageController = PageController(initialPage: index);
    await setCurrentVideoPlayerController(index);
    if (widget.initPosition != null) {
      print('[set seek]');
      await detailVideoController.currentController?.seek(widget.initPosition!);
    }
    setState(() {});
  }

  Future<void> loadNext() async {
    print('[loadNext] 加载下一部剧');
    // 模拟请求下一部剧
    await Future.delayed(Durations.extralong4);
    final model = data.firstWhere((item) => item.id == widget.seriesId);
    final nextIndex = (data.indexOf(model) + 1) % data.length;
    final next = data[nextIndex];

    final baseIndex = vm.dataList.length;
    for (var item in next.episodeList) {
      vm.dataList.add(item);
      final index = next.episodeList.indexOf(item);
      // 模拟广告位插入
      if (index == 2 || index == 8 || index == 12 || index == 17 || index == 24 || index == 33) {
        vm.dataList.insert(baseIndex + index+1, AdItemModel());
      }
    }
    setState(() {

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> setCurrentVideoPlayerController(int index) async {
    final item = vm.dataList[index];
    if (item is ItemModel) {
      final current = detailVideoController.getController(item.videoUrl);
      await detailVideoController.setCurrentVideoPlayerController(controller: current);
      ref.read(homeDataProvider.notifier).updateCurrentData(item);
    } else {
      if (item is AdItemModel && item.watchCount.value != 0) {
        ref.read(detailProvider(widget.seriesId).notifier).countDownAdItem(item);
      }
      await detailVideoController.setCurrentVideoPlayerController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: vm.pageController != null ? Consumer(
        builder: (context, ref, child) {
          final canScroll = ref.watch(detailProvider(widget.seriesId));
          return PageView.builder(
            allowImplicitScrolling: true,
            controller: vm.pageController,
            physics: canScroll ? null : const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: vm.dataList.length,
            itemBuilder: (context, index) {
              final model = vm.dataList[index];
              if (model is ItemModel) {
                return PlayItem(
                  listController: detailVideoController,
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
      ) : Container(),
    );
  }
}
