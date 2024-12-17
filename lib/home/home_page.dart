import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_player/super_player.dart';
import 'package:video_player/detail/detail_page.dart';
import 'package:video_player/global.dart';
import 'package:video_player/model/series_model.dart';
import 'package:video_player/my_navigator_observer.dart';
import 'package:video_player/source.dart';
import 'package:video_player/video_list_controller.dart';
import 'package:video_player/video_list_controller.dart';
import 'package:video_player/widget/home_video_control_widget.dart';
import 'package:video_player/widget/play_item.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with TGRouteAware {
  final _pageController = PageController();

  VideoListController get controller => ref.read(homeVideoListProvider.notifier).listController;
  VideoListController get subController => ref.read(subVideoListProvider.notifier).listController;

  @override
  void initState() {
    setCurrentVideoPlayerController(0);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageRouter.subscribe(this, ModalRoute.of(context));
    });
    controller.onPlayStart = () {
      controller.currentController?.url.let((url) {
        print('开始播放 url: $url');
      });
    };
    controller.onPlayFinished = () {
      controller.currentController?.url.let((url) {
        //寻找当前下一集
        final pageIndex = _pageController.page!.round();
        final model = data[pageIndex];
        final currentIndex = model.episodeList.indexWhere((item) => item.videoUrl == url);
        if (currentIndex < model.episodeList.length - 1) {
          //说明后面还有剧
          final needItem = model.episodeList[currentIndex + 1];
          model.episode = needItem;
          pushDetail(model);
          Future.delayed(Durations.medium1).then((_) {
            controller.replaceController(url, needItem.videoUrl);
          });
        }
      });
    };
  }

  @override
  void dispose() {
    pageRouter.unsubscribe(this);
    super.dispose();
  }

  void setCurrentVideoPlayerController(index) {
    final url = data[index].episode.videoUrl;
    final current = controller.getController(url);
    controller.setCurrentVideoPlayerController(current);
    subController.cacheDetailController(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        allowImplicitScrolling: true,
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: data.length,
        itemBuilder: (context, index) {
          final model = data[index];
          return GestureDetector(
            onTap: () {
              pushDetail(model);
            },
            child: PlayItem(
              listController: controller,
              model: model.episode,
              controlBuilder: (context, controller) {
                return HomeVideoControlWidget(controller: controller,);
              },
            ),
          );
        },
        onPageChanged: setCurrentVideoPlayerController,
      ),
    );
  }

  @override
  void didPopNext() {
    subController.currentController?.let((it) async {
      await it.pause();
      await it.position.value.let((position) async => await controller.currentController?.seek(position));
      controller.currentController?.resume();
      subController.clearExcept(controller: it);
    });
  }

  @override
  void didPushNext() {
    controller.currentController?.let((it) async {
      await Future.delayed(Durations.short1);
      await it.pause();
      await it.position.value.let((position) async => await subController.currentController?.seek(position));
      subController.currentController?.resume();
    });
  }

  pushDetail(SeriesModel model) {
    Navigator.of(context).push(
      MaterialPageRoute(
        settings: const RouteSettings(name: detailPageRoute),
        builder: (_) {
          return DetailPage(
            model: model,
            listController: subController,
          );
        },
      ),
    );
  }
}
