import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    vm.loadData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(homeDataProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: ValueListenableBuilder(valueListenable: vm.dataList, builder: (context, dataList, _) {
        return ClipRRect(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.w), bottomRight: Radius.circular(10.w)),
          child: PageView.builder(
            allowImplicitScrolling: true,
            controller: vm.pageController,
            scrollDirection: Axis.vertical,
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final model = dataList[index];
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
      }),
    );
  }
}
