import 'package:collection/collection.dart';
import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/global.dart';
import 'package:video_player/model/bitrate_model.dart';
import 'package:video_player/video_player_controller.dart';

class VideoListController {
  int maxCacheCount;

  VideoPlayerController? currentController;

  VideoListController({this.maxCacheCount = 3});

  final speed = ValueNotifier<double>(1);
  final currentBitrate = ValueNotifier<BitrateModel?>(null);
  final List<BitrateModel> bitrateList = [];

  final Map<String, VideoPlayerController> _controllers = {};

  setCurrentVideoPlayerController(VideoPlayerController controller) async {
    await currentController?.pause();
    currentController = controller;
    await controller.waitCanResume();
    if (currentController == controller) controller.resume();
  }

  VideoPlayerController getController(String url) {
    if (_controllers[url] == null) {
      final controller = VideoPlayerController(groupController: this, url: url);
      _controllers[url] = controller;
    }
    return _controllers[url]!;
  }

  VideoPlayerController replaceController(String oldUrl, String newUrl) {
    final old = _controllers.remove(oldUrl)!;
    if (oldUrl != newUrl) {
      old.startVodPlay(newUrl);
      _controllers[newUrl] = old;
    }
    return old;
  }

  VideoPlayerController cacheDetailController(String url) {
    currentBitrate.value = null;
    speed.value = 1;
    clearExcept();
    return getController(url);
  }

  VideoPlayerController? getControllerIfHave(String url) {
    return _controllers[url];
  }

  disposeCache(VideoPlayerController controller) {
    if (_controllers.length > maxCacheCount) {
      disposeController(controller);
    }
  }

  disposeController(VideoPlayerController controller) {
    setCount(false);
    _controllers.remove(controller.url);
    controller.dispose();
  }

  /// 清空播放器列表,只留一个当前返回时正在播放的控制器
  clearExcept({VideoPlayerController? controller}) {
    final keys = _controllers.keys.toList();
    for (final key in keys) {
      final target = _controllers[key]!;
      if (target != controller) {
        disposeController(target);
      }
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

  setBitrateIndex(BitrateModel bitrate) {
    currentBitrate.value = bitrate;
    bitrateList.firstWhereOrNull((it) => (it.height == bitrate.height && it.width == bitrate.width))?.index.let((index) {
      for (final controller in _controllers.values) {
        controller.setBitrateIndex(index);
      }
    });
  }
}