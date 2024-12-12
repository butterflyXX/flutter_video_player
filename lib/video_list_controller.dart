import 'package:flutter/cupertino.dart';
import 'package:video_player/global.dart';
import 'package:video_player/source.dart';
import 'package:video_player/video_player_controller.dart';

class VideoListController {
  int maxCacheCount;

  VideoPlayerController? currentController;

  VideoListController({this.maxCacheCount = 5});

  VideoPlayerController _inflateController(String url) {
    setCount(true);
    final controller = VideoPlayerController(this);
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

  VideoPlayerController replaceController(String oldUrl, String newUrl) {
    final old = _controllers.remove(oldUrl)!;
    if (oldUrl != newUrl) {
      old.startVodPlay(newUrl);
      _controllers[newUrl] = old;
    }
    return old;
  }

  VideoPlayerController replaceOrCreateController(String url) {
    if (_controllers.isEmpty) {
      return getController(url);
    } else {
      return replaceController(_controllers.values.first.url!, url);
    }
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
  clearExcept(VideoPlayerController controller) {
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
}