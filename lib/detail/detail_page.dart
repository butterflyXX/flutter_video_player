
import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/global.dart';
import 'package:video_player/my_navigator_observer.dart';
import 'package:video_player/source.dart';
import 'package:video_player/video_list_controller.dart';
import 'package:video_player/widget/play_item.dart';

const detailPageRoute = '/detailPageRoute';

class DetailPage extends ConsumerStatefulWidget {
  final GroupModel groupInfo;
  final VideoListController? listController;

  const DetailPage({
    required this.groupInfo,
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
    final index = urls.indexOf(widget.groupInfo.currentUrl);
    _pageController = PageController(initialPage: index);
    setCurrentVideoPlayerController(index);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setCurrentVideoPlayerController(index) {
    final url = urls[index];
    final current = _listController.getController(url);
    _listController.setCurrentVideoPlayerController(current);
    final group = data.firstWhere((it) => it.groupId == widget.groupInfo.groupId);
    final old = group.currentUrl;
    if (old != url) {
      group.currentUrl = url;
      controller.replaceController(old, url);
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
        itemCount: urls.length,
        itemBuilder: (context, index) {
          final url = urls[index];
          return PlayItem(
            listController: _listController,
            url: url,
          );
        },
        onPageChanged: setCurrentVideoPlayerController,
      ),
    );
  }
}
