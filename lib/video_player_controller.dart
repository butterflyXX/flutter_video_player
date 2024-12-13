import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_player/super_player.dart';
import 'package:video_player/global.dart';
import 'package:video_player/video_list_controller.dart';

class VideoPlayerController extends TXVodPlayerController {
  final VideoListController groupController;
  double rate = 1;
  String url;
  final aspectRatio = ValueNotifier<double>(0);
  bool _canResume = false;
  final _initializeCompleter = Completer();

  double duration = 0;
  final position = ValueNotifier<double>(0);

  StreamSubscription? _subscription;

  @override
  Future<void> initialize({bool? onlyAudio}) async {
    await super.initialize(onlyAudio: onlyAudio);
  }

  Future waitCanResume() async {
    if (_canResume) return;
    return _initializeCompleter.future;
  }

  void _inflateController() {
    setCount(true);
    final playConfig = FTXVodPlayConfig();

    /// 设为true，可平滑切换码率, 设为false时，可提高多码率地址打开速度
    playConfig.smoothSwitchBitrate = true;
    setConfig(playConfig);
    initialize().then((_) async {
      setLoop(true);
      setAutoPlay(isAutoPlay: false);
      startVodPlay(url);
      setBitrateIndex(groupController.bitrateIndex.value).then((_) {
        setRate(groupController.speed.value);
      });
    });
  }

  VideoPlayerController({
    required this.groupController,
    required this.url,
  }) {
    _inflateController();
    _subscription = onPlayerEventBroadcast.listen((event) async {
      if (event["event"] == TXVodPlayEvent.PLAY_EVT_VOD_PLAY_PREPARED) {
        //加载完毕,可以执行播放或者暂停
        if (!_canResume) {
          _canResume = true;
          _initializeCompleter.complete();
        }
      }

      if (event["event"] == TXVodPlayEvent.PLAY_EVT_CHANGE_RESOLUTION) {
        //分辨率获取,获取完分辨率展示播放器UI
        double w = (event["EVT_PARAM1"]).toDouble();
        double h = (event["EVT_PARAM2"]).toDouble();
        aspectRatio.value = 1.0 * w / h;
      }

      if (event["event"] == TXVodPlayEvent.PLAY_EVT_PLAY_PROGRESS) {
        //播放进度

        // 视频总长, 单位是秒
        duration = event[TXVodPlayEvent.EVT_PLAY_DURATION];
        // 播放进度, 单位是秒
        position.value = event[TXVodPlayEvent.EVT_PLAY_PROGRESS];
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