import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/detail/detail_data_provider.dart';
import 'package:video_player/global.dart';
import 'package:video_player/model/item_model.dart';
import 'package:video_player/provider/detail_provider.dart';
import 'package:video_player/widget/ad_item.dart';
import 'package:video_player/widget/play_item.dart';
import 'package:video_player/widget/video_control_widget.dart';

const detailPageRoute = '/detailPageRoute';

class DetailPage extends ConsumerStatefulWidget {
  final String seriesId;
  final double? initPosition;

  const DetailPage({
    required this.seriesId,
    this.initPosition,
    super.key,
  });

  @override
  ConsumerState<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends ConsumerState<DetailPage> {
  late final vm = ref.read(detailDataProvider.notifier);

  @override
  void initState() {
    vm.seriesId = widget.seriesId;
    vm.load(position: widget.initPosition);
    super.initState();
  }

  @override
  void dispose() {
    detailVideoController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(detailDataProvider);
    return PopScope(
      onPopInvoked: (canPop) {
        detailVideoController.currentController?.let((it) async {
          readProvider(currentControllerProvider.notifier).setState(homeVideoController.currentController);
          await it.position.value.let((position) async => await homeVideoController.seek(position));
          homeVideoController.resume();
        });
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: ValueListenableBuilder(
          valueListenable: vm.dataList,
          builder: (context, dataList, _) {
            if (dataList.isEmpty) {
              return Container();
            }
            return Consumer(
              builder: (context, ref, child) {
                final canScroll = ref.watch(detailProvider(widget.seriesId));
                return PageView.builder(
                  allowImplicitScrolling: true,
                  controller: vm.pageController,
                  physics: canScroll ? null : const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    final model = dataList[index];
                    if (model is ItemModel) {
                      return PlayItem(
                        listController: detailVideoController,
                        model: model,
                        controlBuilder: (context, controller) {
                          return VideoControlWidget(
                            controller: controller,
                          );
                        },
                      );
                    } else {
                      return AdItem(model: model);
                    }
                  },
                  onPageChanged: vm.setCurrentVideoPlayerController,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
