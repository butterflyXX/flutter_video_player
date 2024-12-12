import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_player/super_player.dart';
import 'package:video_player/detail/detail_page.dart';
import 'package:video_player/global.dart';
import 'package:video_player/my_navigator_observer.dart';
import 'package:video_player/source.dart';
import 'package:video_player/video_list_controller.dart';
import 'package:video_player/video_list_controller.dart';
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
          final group = data[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: detailPageRoute),
                  builder: (_) {
                    return DetailPage(
                      model: group,
                      listController: subController,
                    );
                  },
                ),
              );
            },
            child: PlayItem(
              listController: controller,
              url: group.episode.videoUrl,
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
      await it.position.value?.let((position) async => await controller.currentController?.seek(position));
      controller.currentController?.resume();
      subController.clearExcept(it);
    });
  }

  @override
  void didPushNext() {
    controller.currentController?.let((it) async {
      await it.pause();
      await it.position.value?.let((position) async => await subController.currentController?.seek(position));
      subController.currentController?.resume();
    });
  }

  // @override
  // void willPopFromNext() {
  //   subController.currentController?.let((it) async {
  //     await it.pause();
  //     it.position.value?.let((position) => controller.currentController?.seek(position));
  //     subController.clearExcept(it);
  //   });
  //   controller.currentController?.resume();
  //   super.willPopFromNext();
  // }
  //
  // @override
  // void cancelPopFromNext() {
  //   controller.currentController?.let((it) async {
  //     await it.pause();
  //     it.position.value?.let((position) => subController.currentController?.seek(position));
  //   });
  //   subController.currentController?.resume();
  //   super.cancelPopFromNext();
  // }
}
