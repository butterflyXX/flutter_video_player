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
    }
    setSpeed(speed.value);
    return _controllers[url]!;
  }

  updateCache(VideoPlayerController controller) {
    print('控制器数量 ${_controllers.length}');
    if (_controllers.length > maxCacheCount) {
      print('清除播放器 ${urls.indexOf(controller.url!)}');
      _controllers.remove(controller.url);
      controller.dispose();
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