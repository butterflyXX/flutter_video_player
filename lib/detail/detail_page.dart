
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

const detailPageRoute = '/detailPageRoute';

class DetailPage extends ConsumerStatefulWidget {
  final SeriesModel model;
  final VideoListController? listController;

  const DetailPage({
    required this.model,
    this.listController,
    super.key,
  });

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  late PageController _pageController;
  late final VideoListController _listController = widget.listController ?? VideoListController();

  VideoListController get controller => ref.read(homeVideoListProvider.notifier).listController;

  @override
  void initState() {
    final item = widget.model.episodeList.firstWhere((it) => it.videoUrl == widget.model.episode.videoUrl);
    final index = widget.model.episodeList.indexOf(item);
    _pageController = PageController(initialPage: index);
    setCurrentVideoPlayerController(index);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setCurrentVideoPlayerController(int index) {
    final item = widget.model.episodeList[index];
    final current = _listController.getController(item.videoUrl);
    _listController.setCurrentVideoPlayerController(current);
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
            listController: _listController,
            model: model,
          );
        },
        onPageChanged: setCurrentVideoPlayerController,
      ),
    );
  }
}
