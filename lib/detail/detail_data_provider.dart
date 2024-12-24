import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/global.dart';
import 'package:video_player/home/home_data_provider.dart';
import 'package:video_player/model/ad_item_model.dart';
import 'package:video_player/model/item_model.dart';
import 'package:video_player/model/series_model.dart';
import 'package:video_player/provider/detail_provider.dart';
import 'package:video_player/source.dart';

final detailDataProvider = AutoDisposeNotifierProvider<DetailDataProviderNotifier, bool>(DetailDataProviderNotifier.new);

class DetailDataProviderNotifier extends AutoDisposeNotifier<bool> {
  final dataList = ValueNotifier([]);
  PageController? pageController;
  late String seriesId;
  final current = ValueNotifier<dynamic>(null);
  final seriesModels = <SeriesModel>[];
  final currentSeries = ValueNotifier<SeriesModel?>(null);
  final showPlaceholderImage = ValueNotifier(false);

  int firstSeriesMaxIndex = 0;
  @override
  bool build() {
    detailVideoController.onPlayStart = () {
      detailVideoController.currentController?.url.let((url) {
        final lastUrl = dataList.value.last.videoUrl;
        if (lastUrl == url) {
          // 最后一集播放开始
          loadNext();
        }
      });
    };
    detailVideoController.onPlayFinished = () {
      detailVideoController.currentController?.url.let((url) {
        //判断是否是最后一集
        final lastUrl = dataList.value.last.videoUrl;
        if (lastUrl == url) {
          // 最后一集播放完毕
        } else {
          pageController?.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
        }
      });
    };
    return true;
  }

  /// 模拟请求剧
  Future<void> load({double? position}) async {
    await Future.delayed(Durations.long4);
    Future.delayed(Durations.medium1).then((_) {
      showPlaceholderImage.value = true;
    });
    final model = data.firstWhere((item) => item.id == seriesId);
    seriesModels.add(model);
    final newData = [];
    for (var item in model.episodeList) {
      final index = model.episodeList.indexOf(item);
      newData.add(item);

      // 模拟广告位插入
      if (index == 2 || index == 8 || index == 12 || index == 17 || index == 24 || index == 33) {
        newData.insert(index + 1, AdItemModel());
      }
    }
    final item = model.episodeList.firstWhere((it) => it.videoUrl == model.episode.videoUrl);
    final index = newData.indexOf(item);
    firstSeriesMaxIndex = newData.length;
    dataList.value = newData;
    pageController = PageController(initialPage: index);
    await setCurrentVideoPlayerController(index, position: position);
  }

  Future<void> loadNext() async {
    // 模拟请求下一部剧
    await Future.delayed(Durations.extralong4);
    final model = data.firstWhere((item) => item.id == seriesId);
    final nextIndex = (data.indexOf(model) + 1) % data.length;
    final next = data[nextIndex];
    seriesModels.add(next);

    final nextData = [];
    for (var item in next.episodeList) {
      nextData.add(item);
      final index = next.episodeList.indexOf(item);
      // 模拟广告位插入
      if (index == 2 || index == 8 || index == 12 || index == 17 || index == 24 || index == 33) {
        nextData.insert(index + 1, AdItemModel());
      }
    }
    dataList.value = dataList.value + nextData;
  }

  Future<void> setCurrentVideoPlayerController(int index, {double? position}) async {
    final item = dataList.value[index];
    final last = current.value;
    current.value = item;
    if (item is ItemModel) {
      currentSeries.value = getCurrentSeries(item.seriesId);
    }
    if (item is ItemModel) {
      final current = detailVideoController.getController(item.videoUrl, position: position);
      if (last is ItemModel && (last.seriesId == seriesId && item.seriesId != seriesId)) {
        //开始播放下一部剧,同步上一部剧播放进度
        homeVideoController.currentController?.seek(detailVideoController.currentController!.position.value);
      }
      await detailVideoController.setCurrentVideoPlayerController(controller: current);
      ref.read(homeDataProvider.notifier).updateCurrentData(item);
    } else {
      if (item is AdItemModel && item.watchCount.value != 0) {
        ref.read(detailProvider(seriesId).notifier).countDownAdItem(item);
      }
      await detailVideoController.setCurrentVideoPlayerController();
    }

  }

  bool isInitSeries() {
    final currentIndex = dataList.value.indexOf(current);
    if (currentIndex < firstSeriesMaxIndex) {
      return true;
    }
    return false;
  }

  SeriesModel getCurrentSeries(String seriesId) {
    return seriesModels.firstWhere((item) => item.id == seriesId);
  }
}