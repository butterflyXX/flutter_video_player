import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_player/super_player.dart';
import 'package:video_player/global.dart';
import 'package:video_player/model/bitrate_model.dart';
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
  double height = 0;
  double width = 0;

  StreamSubscription? _eventSubscription;
  StreamSubscription? _statusSubscription;
  StreamSubscription? _netStatusSubscription;

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
      // setLoop(true);
      setAutoPlay(isAutoPlay: false);
      setStartTime(position.value);
      startVodPlay(url);
      groupController.currentBitrate.value?.let((it) {
        setBitrateIndex(it.index);
      });
    });
  }

  VideoPlayerController({
    required this.groupController,
    required this.url,
    double? startPosition,
  }) {
    position.value = startPosition ?? 0;
    _inflateController();
    _eventSubscription = onPlayerEventBroadcast.listen((event) async {
      if (event["event"] == TXVodPlayEvent.PLAY_EVT_VOD_PLAY_PREPARED) {
        //加载完毕,可以执行播放或者暂停
        if (!_canResume) {
          _canResume = true;
          _initializeCompleter.complete();
        }
        getSupportedBitrates().then((bitrateList) {
          groupController.bitrateList.clear();
          bitrateList?.let((list) {
            for (var item in list) {
              groupController.bitrateList.add(BitrateModel.fromJson(Map<String, dynamic>.from(item)));
              groupController.bitrateList.sort((a, b) => a.height > b.height ? -1 : 1);
            }
          });
        });
      }

      if (event["event"] == TXVodPlayEvent.PLAY_EVT_CHANGE_RESOLUTION) {
        //分辨率获取,获取完分辨率展示播放器UI
        width = (event["EVT_PARAM1"]).toDouble();
        height = (event["EVT_PARAM2"]).toDouble();
        setRate(groupController.speed.value);
        if (playState == TXPlayerState.playing) resume();
      }

      if (event["event"] == TXVodPlayEvent.PLAY_EVT_PLAY_PROGRESS) {
        //播放进度

        // 视频总长, 单位是秒
        duration = event[TXVodPlayEvent.EVT_PLAY_DURATION].toDouble();
        // 播放进度, 单位是秒
        position.value = event[TXVodPlayEvent.EVT_PLAY_PROGRESS].toDouble();
      }

      if (event['event'] == TXVodPlayEvent.PLAY_EVT_PLAY_END) {
        groupController.playFinished();
      }
    });

    _statusSubscription = onPlayerState.listen((event) async {});

    _netStatusSubscription = onPlayerNetStatusBroadcast.listen((event) async {
      double w = (event["VIDEO_WIDTH"]).toDouble();
      double h = (event["VIDEO_HEIGHT"]).toDouble();
      if (w > 0 && h > 0) {
        aspectRatio.value = w / h;
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
    _eventSubscription?.cancel();
    _statusSubscription?.cancel();
    _netStatusSubscription?.cancel();
    return super.dispose();
  }
}
