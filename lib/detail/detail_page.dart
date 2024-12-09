
import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/material.dart';
import 'package:video_player/my_navigator_observer.dart';
import 'package:video_player/source.dart';
import 'package:video_player/video_list_controller.dart';
import 'package:video_player/widget/play_item.dart';

const detailPageRoute = '/detailPageRoute';

class DetailPage extends StatefulWidget {
  final String? initialUrl;
  final VideoListController? listController;

  const DetailPage({
    this.initialUrl,
    this.listController,
    super.key,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late PageController _pageController;
  late final VideoListController _listController = widget.listController ?? VideoListController();

  @override
  void initState() {
    int index = 0;
    if (widget.initialUrl != null) {
      index = urls.indexOf(widget.initialUrl!);
    }
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
