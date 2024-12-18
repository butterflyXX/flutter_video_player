import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/model/series_model.dart';
import 'package:video_player/video_list_controller.dart';
import 'package:video_player/video_player_controller.dart';

late BuildContext baseContext;
final navigatorKey = GlobalKey<NavigatorState>();

const color = Color(0xFFFDFBFC);
int count = 0;
setCount(bool add) {
  if (add) {
    count++;
  } else {
    count--;
  }
  print('播放器数量变化: $count');
}

/// 仅适用于read
T readProvider<T>(ProviderListenable<T> provider) {
  return ProviderScope.containerOf(baseContext, listen: false).read(provider);
}

class PositionModel {
  final VideoPlayerController? controller;

  PositionModel({this.controller,});

  PositionModel copyWith({String? groupId, VideoPlayerController? controller,}) {
    return PositionModel(controller: controller ?? this.controller,);
  }
}

final homeVideoController = VideoListController();
final detailVideoController = VideoListController();

final currentControllerProvider = NotifierProvider<CurrentControllerProviderNotifier, VideoPlayerController?>(CurrentControllerProviderNotifier.new);

class CurrentControllerProviderNotifier extends Notifier<VideoPlayerController?> {
  @override
  VideoPlayerController? build() {
    return null;
  }

  Future<void> setState(VideoPlayerController? controller) async {
    await state?.groupController.pause();
    state = controller;
  }
}