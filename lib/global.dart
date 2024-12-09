import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_list_controller.dart';
import 'package:video_player/video_player_controller.dart';

late BuildContext baseContext;

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

final positionProvider = NotifierProvider<PositionNotifier, PositionModel>(PositionNotifier.new);

class PositionNotifier extends Notifier<PositionModel> {
  @override
  PositionModel build() {
    return PositionModel();
  }

  update({String? groupId, VideoPlayerController? controller,}) {
    state = state.copyWith(groupId: groupId, controller: controller,);
  }
}

final homeVideoListProvider = NotifierProvider<HomeVideoNotifier, bool>(HomeVideoNotifier.new);

class HomeVideoNotifier extends Notifier<bool> {
  VideoListController listController = VideoListController();

  @override
  bool build() {
    return true;
  }
}

final subVideoListProvider = NotifierProvider<SubVideoNotifier, bool>(SubVideoNotifier.new);

class SubVideoNotifier extends Notifier<bool> {
  late VideoListController listController;

  @override
  bool build() {
    listController = VideoListController();
    return true;
  }
}