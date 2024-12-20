import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/detail/detail_data_provider.dart';
import 'package:video_player/gen/assets.gen.dart';
import 'package:video_player/global.dart';
import 'package:video_player/model/item_model.dart';
import 'package:video_player/provider/clear_screen_provider.dart';
import 'package:video_player/provider/detail_provider.dart';
import 'package:video_player/util/color.dart';
import 'package:video_player/util/safe_size.dart';
import 'package:video_player/widget/ad_item.dart';
import 'package:video_player/widget/play_item.dart';
import 'package:video_player/widget/speed_dialog.dart';
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
          if (vm.isInitSeries()) {
            await it.position.value.let((position) async => await homeVideoController.seek(position));
          }
          homeVideoController.resume();
        });
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            ValueListenableBuilder(
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
                        Widget child;
                        if (model is ItemModel) {
                          child = PlayItem(
                            listController: detailVideoController,
                            model: model,
                            controlBuilder: (context, controller) {
                              return VideoControlWidget(
                                controller: controller,
                              );
                            },
                          );
                        } else {
                          child = AdItem(model: model);
                        }
                        return Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.w), bottomRight: Radius.circular(10.w)),
                                child: child,
                              ),
                            ),
                            bottomWidget(),
                          ],
                        );
                      },
                      onPageChanged: vm.setCurrentVideoPlayerController,
                    );
                  },
                );
              },
            ),
            appbar(),
          ],
        ),
      ),
    );
  }

  Widget bottomWidget() {
    return Container(
      padding: EdgeInsets.only(left: 16.w),
      height: 50 + SafeSize.bottomBarHeight(),
      child: Column(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: surface5,
                        borderRadius: BorderRadius.circular(8.w),
                      ),
                      height: 40,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: ValueListenableBuilder(
                              valueListenable: vm.currentSeries,
                              builder: (context, currentSeries, _) {
                                return Text(
                                  '选集·全${currentSeries?.episodeList.length ?? 0}集·永久免费',
                                  style: const TextStyle(
                                    color: color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                );
                              },
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_up_rounded,
                            color: color,
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(clearScreenProvider.notifier).state = !ref.read(clearScreenProvider.notifier).state;
                    },
                    icon: Consumer(
                      builder: (context, ref, _) {
                        var svg = Assets.svg.expandContent;
                        final isClear = ref.watch(clearScreenProvider);
                        if (isClear) {
                          svg = Assets.svg.collapseContent;
                        }

                        return AnimatedSwitcher(
                          duration: Durations.medium1,
                          child: svg.svg(
                            key: UniqueKey(),
                            width: 28,
                            fit: BoxFit.cover,
                            colorFilter: const ColorFilter.mode(color, BlendMode.srcIn),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget appbar() {
    return ValueListenableBuilder(
      valueListenable: vm.current,
      builder: (context, current, _) {
        return Padding(
          padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
          child: Row(
            children: [
              (ModalRoute.of(context)?.canPop ?? false)
                  ? IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: color,
                      ),
                    )
                  : const SizedBox(
                      width: 10,
                    ),
              Expanded(
                child: Text(
                  current is ItemModel ? '第${current.index}集' : '',
                  style: const TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Opacity(
                opacity: current is ItemModel ? 1 : 0,
                child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        const speeds = <double>[0.25, 0.5, 1, 1.5, 2, 2.5, 3];
                        return SpeedDialog(
                          source: speeds,
                          selected: detailVideoController.speed.value,
                          onTap: (index) {
                            detailVideoController.setSpeed(speeds[index]);
                          },
                        );
                      },
                    );
                  },
                  icon: Row(
                    children: [
                      Icon(
                        Icons.speed,
                        color: color,
                      ),
                      Text(
                        '倍速',
                        style: TextStyle(color: color),
                      ),
                    ],
                  ),
                ),
              ),
              Opacity(
                opacity: current is ItemModel ? 1 : 0,
                child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SpeedDialog(
                          source: detailVideoController.bitrateList.map((item) => '${item.height}P').toList(),
                          selected: '${detailVideoController.currentBitrate.value?.height.toString()}P',
                          onTap: (index) {
                            detailVideoController.setBitrateIndex(detailVideoController.bitrateList[index]);
                          },
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
