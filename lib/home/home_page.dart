import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/material.dart';
import 'package:video_player/detail/detail_page.dart';
import 'package:video_player/global.dart';
import 'package:video_player/my_navigator_observer.dart';
import 'package:video_player/source.dart';
import 'package:video_player/video_list_controller.dart';
import 'package:video_player/widget/play_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TGRouteAware {
  final _pageController = PageController();

  @override
  void initState() {
    setCurrentVideoPlayerController(0);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageRouter.subscribe(this, ModalRoute.of(context));
    });
  }

  @override
  void dispose() {
    pageRouter.unsubscribe(this);
    super.dispose();
  }

  void setCurrentVideoPlayerController(index) {
    final url = urls[index];
    final current = homeVideoListController.getController(url);
    homeVideoListController.setCurrentVideoPlayerController(current);
    //缓冲详情页播放器
    subVideoListController.getController(url);
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
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: detailPageRoute),
                  builder: (_) {
                    return DetailPage(
                      initialUrl: url,
                      listController: subVideoListController,
                    );
                  },
                ),
              );
            },
            child: PlayItem(
              listController: homeVideoListController,
              url: url,
            ),
          );
        },
        onPageChanged: setCurrentVideoPlayerController,
      ),
    );
  }

  @override
  void didPopNext() {
    subVideoListController.currentController?.let((it) async {
      await it.pause();
      subVideoListController.clearExcept(it);
    });
    homeVideoListController.currentController?.resume();
  }

  @override
  void didPushNext() {
    homeVideoListController.currentController?.pause();
  }
}
