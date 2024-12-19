import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/detail/detail_data_provider.dart';
import 'package:video_player/global.dart';
import 'package:video_player/model/item_model.dart';
import 'package:video_player/provider/detail_provider.dart';
import 'package:video_player/util/color.dart';
import 'package:video_player/util/safe_size.dart';
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
            Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10.w), bottomRight: Radius.circular(10.w)),
                    child: ValueListenableBuilder(
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
                ),
                Container(
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
                                        child: Text(
                                          '选集·全${vm.dataList.value.length}集·永久免费',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_up_rounded,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.content_copy_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            appbar(),
          ],
        ),
      ),
    );
  }

  Widget appbar() {
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
            child: ValueListenableBuilder(
              valueListenable: vm.current,
              builder: (context, current, _) {
                return Text(
                  (current as ItemModel?)?.name ?? '',
                  style: const TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              }
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: color,
              )),
        ],
      ),
    );
  }
}
