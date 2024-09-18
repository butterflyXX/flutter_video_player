import 'package:flutter/cupertino.dart';
import 'package:flutter_video_player/model/player_item.dart';
import 'package:video_player/video_player.dart';

class PlayerController {
  final speed = ValueNotifier<double>(1);
  int maxCacheCount;
  PlayerController({this.maxCacheCount = 9});
  final Map<String, PlayerItem> _controllers = {};
  PlayerItem getItem(String url,{Duration? position, List<String>? cache}) {
    final date = DateTime.now().millisecondsSinceEpoch;
    PlayerItem item = cacheItem(url);
    item.cacheDate = date;
    if (position != null) {
      item.controller.seekTo(position);
    }
    cache?.forEach((item) {
      cacheItem(item);
    });
    //查看混存
    checkCache();
    return item;
  }

  PlayerItem cacheItem(String url) {
    if (_controllers[url] != null) return _controllers[url]!;
    VideoPlayerController controller = VideoPlayerController.networkUrl(Uri.parse(url));
    controller.initialize();
    _controllers[url] = PlayerItem(url, controller: controller, cacheDate: DateTime.now().millisecondsSinceEpoch);
    setSpeed(speed.value);
    return _controllers[url]!;
  }

  checkCache() {
    if (_controllers.length > maxCacheCount) {
      String? needDeleteItemKey;
      for (final item in _controllers.entries) {
        needDeleteItemKey ??= item.key;
        if (_controllers[needDeleteItemKey]!.cacheDate > item.value.cacheDate) {
          needDeleteItemKey = item.key;
        }
      }
      print("删除 $needDeleteItemKey");
      final item = _controllers.remove(needDeleteItemKey);
      item?.controller.dispose();
    }
  }

  setSpeed(double newSpeed) {
    speed.value = newSpeed;
    for (final controller in _controllers.values) {
      if (controller.controller.value.playbackSpeed != speed.value) {
        controller.controller.setPlaybackSpeed(newSpeed);
      }
    }
  }
}