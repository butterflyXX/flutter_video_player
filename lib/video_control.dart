import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player_controller.dart';

class VideoControl {
  static final instance = VideoControl._();
  VideoControl._();
  int maxCacheCount = 3;

  VideoPlayerController? currentController;

  static initialize({int? maxCacheCount}) {
    if (maxCacheCount != null && maxCacheCount != instance.maxCacheCount) {
      instance.maxCacheCount = maxCacheCount;
    }
  }

  VideoPlayerController _inflateController(String url) {
    final controller = VideoPlayerController();
    controller.initialize().then((_) async {
      controller.setLoop(true);
      controller.setAutoPlay(isAutoPlay: false);
      controller.startVodPlay(url);
    });
    return controller;
  }

  final speed = ValueNotifier<double>(1);

  final Map<String, VideoPlayerController> _controllers = {};

  VideoPlayerController cacheItem(String url) {
    if (_controllers[url] != null) return _controllers[url]!;
    checkCache();
    final controller = _inflateController(url);
    _controllers[url] = controller..cacheDate = DateTime.now().millisecondsSinceEpoch;
    setSpeed(speed.value);
    return _controllers[url]!;
  }

  checkCache() {
    if (_controllers.length == maxCacheCount) {
      String? needDeleteItemKey;
      for (final item in _controllers.entries) {
        needDeleteItemKey ??= item.key;
        if (_controllers[needDeleteItemKey]!.cacheDate > item.value.cacheDate) {
          needDeleteItemKey = item.key;
        }
      }
      print("删除 $needDeleteItemKey");
      final item = _controllers.remove(needDeleteItemKey);
      item?.dispose();
    }
  }

  setSpeed(double newSpeed) {
    speed.value = newSpeed;
    for (final controller in _controllers.values) {
      if (controller.rate != speed.value) {
        controller.setRate(newSpeed);
      }
    }
  }
}