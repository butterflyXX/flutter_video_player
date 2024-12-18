import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/detail/detail_page.dart';
import 'package:video_player/global.dart';
import 'package:video_player/model/item_model.dart';
import 'package:video_player/model/series_model.dart';
import 'package:video_player/source.dart';

final homeDataProvider = AutoDisposeNotifierProvider<HomeDataProviderNotifier, bool>(HomeDataProviderNotifier.new);

class HomeDataProviderNotifier extends AutoDisposeNotifier<bool> {
  final dataList = ValueNotifier<List<SeriesModel>>([]);
  SeriesModel? _current;
  PageController pageController = PageController();
  @override
  bool build() {
    homeVideoController.onPlayStart = () {
      homeVideoController.currentController?.url.let((url) {
        print('开始播放 url: $url');
      });
    };
    homeVideoController.onPlayFinished = () {
      homeVideoController.currentController?.url.let((url) {
        //寻找当前下一集
        final pageIndex = pageController.page!.round();
        final model = dataList.value[pageIndex];
        final currentIndex = model.episodeList.indexWhere((item) => item.videoUrl == url);
        if (currentIndex < model.episodeList.length - 1) {
          //说明后面还有剧
          final needItem = model.episodeList[currentIndex + 1];
          model.episode = needItem;
          pushDetail(model.id);
          Future.delayed(Durations.medium1).then((_) {
            homeVideoController.replaceController(url, needItem.videoUrl);
          });
        }
      });
    };
    return true;
  }

  loadData() async {
    await Future.delayed(const Duration(seconds: 3));
    dataList.value = data;
    setCurrentVideoPlayerController(0);
  }

  updateCurrentData(ItemModel model) {
    _current?.let((current) {
      final old = current.episode.videoUrl;
      final isSameSeries = current.id == model.seriesId;
      if (isSameSeries && old != model.videoUrl) {
        current.episode = ItemModel.fromJson(model.toJson());
        homeVideoController.replaceController(old, model.videoUrl);
      }
    });
  }

  void setCurrentVideoPlayerController(index) {
    _current = dataList.value[index];
    final url = dataList.value[index].episode.videoUrl;
    final current = homeVideoController.getController(url);
    homeVideoController.setCurrentVideoPlayerController(controller: current);
  }

  pushDetail(String seriesId,{double? position}) {
    navigatorKey.currentState?.context.let((context) {
      Navigator.of(context).push(
        MaterialPageRoute(
          settings: const RouteSettings(name: detailPageRoute),
          builder: (_) {
            return DetailPage(seriesId: seriesId, initPosition: position,);
          },
        ),
      );
    });
  }
}