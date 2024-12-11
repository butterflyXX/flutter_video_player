import 'package:flutter/cupertino.dart';
import 'package:video_player/source.dart';
import 'package:video_player/video_player_controller.dart';

class VideoListController {
  int maxCacheCount;

  VideoPlayerController? currentController;

  VideoListController({this.maxCacheCount = 3});

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

  setCurrentVideoPlayerController(VideoPlayerController controller) async {
    await currentController?.pause();
    currentController = controller;
    await controller.waitCanResume();
    if (currentController == controller) controller.resume();
  }

  VideoPlayerController getController(String url) {
    if (_controllers[url] == null) {
      final controller = _inflateController(url);
      _controllers[url] = controller;
      controller.setRate(speed.value);
    }
    return _controllers[url]!;
  }

  replaceController(String oldUrl, String newUrl) async {
    if (oldUrl == newUrl) return;
    final old = _controllers.remove(oldUrl)!;
    old.startVodPlay(newUrl);
    _controllers[newUrl] = old;
  }

  VideoPlayerController? getControllerIfHave(String url) {
    return _controllers[url];
  }

  disposeCache(VideoPlayerController controller) {
    if (_controllers.length > maxCacheCount) {
      _controllers.remove(controller.url);
      controller.dispose();
    }
  }

  /// 清空播放器列表,只留一个当前返回时正在播放的控制器
  clearExcept(VideoPlayerController controller) {
    final keys = _controllers.keys.toList();
    for (final key in keys) {
      final target = _controllers[key]!;
      if (target != controller) {
        target.dispose();
        _controllers.remove(key);
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
}