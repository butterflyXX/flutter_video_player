import 'dart:async';

import 'package:flutter/material.dart';
import 'package:super_player/super_player.dart';

class VideoPlayerController extends TXVodPlayerController {
  double rate = 1;
  String? url;
  final aspectRatio = ValueNotifier<double>(0);
  bool _canResume = false;
  final _initializeCompleter = Completer();

  StreamSubscription? _subscription;

  @override
  Future<void> initialize({bool? onlyAudio}) async {
     await super.initialize(onlyAudio: onlyAudio);
  }

  Future waitCanResume() async {
    if (_canResume) return;
    return _initializeCompleter.future;
  }

  VideoPlayerController() {
    _subscription = onPlayerEventBroadcast.listen((event) async {
      if(event["event"] == TXVodPlayEvent.PLAY_EVT_VOD_PLAY_PREPARED) {
        //加载完毕,可以执行播放或者暂停
        if (!_canResume) {
          _canResume = true;
          _initializeCompleter.complete();
        }
      }

      if(event["event"] == TXVodPlayEvent.PLAY_EVT_CHANGE_RESOLUTION) {
        //分辨率获取,获取完分辨率展示播放器UI
        double w = (event["EVT_PARAM1"]).toDouble();
        double h = (event["EVT_PARAM2"]).toDouble();
        if (aspectRatio.value == 0) {
          aspectRatio.value = 1.0 * w / h;
        }
      }

      if(event["event"] == TXVodPlayEvent.PLAY_EVT_PLAY_PROGRESS) {
        //播放进度

        // 播放位置 单位s
        final position = (event['EVT_PLAY_PROGRESS'] * 1000).round;

        // 视频可播放时长 单位s
        final duration = (event['PLAYABLE_DURATION'] * 1000).round;

        // 视频总时长 单位s
        final allDuration = (event['EVT_PLAY_DURATION'] * 1000).round;
      }

    });
  }

  @override
  Future<bool> startVodPlay(String url) async {
    this.url = url;
    final res = await super.startVodPlay(url);
    return res;
  }

  @override
  Future<void> setRate(double rate) async {
    this.rate = rate;
    return await super.setRate(rate);
  }

  @override
  Future<void> dispose() {
    _subscription?.cancel();
    return super.dispose();
  }
}