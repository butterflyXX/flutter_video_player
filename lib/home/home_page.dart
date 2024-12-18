import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/global.dart';
import 'package:video_player/home/home_data_provider.dart';
import 'package:video_player/my_navigator_observer.dart';
import 'package:video_player/widget/home_video_control_widget.dart';
import 'package:video_player/widget/play_item.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with TGRouteAware {
  late final vm = ref.read(homeDataProvider.notifier);
  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void loadData() async {
    await vm.loadData();
    vm.setCurrentVideoPlayerController(0);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(homeDataProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        allowImplicitScrolling: true,
        controller: vm.pageController,
        scrollDirection: Axis.vertical,
        itemCount: vm.dataList.length,
        itemBuilder: (context, index) {
          final model = vm.dataList[index];
          return GestureDetector(
            onTap: () {
              vm.pushDetail(model.id, position: homeVideoController.currentController!.position.value);
            },
            child: PlayItem(
              listController: homeVideoController,
              model: model.episode,
              controlBuilder: (context, controller) {
                return HomeVideoControlWidget(
                  controller: controller,
                );
              },
            ),
          );
        },
        onPageChanged: vm.setCurrentVideoPlayerController,
      ),
    );
  }
}
