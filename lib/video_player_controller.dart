import 'dart:async';

import 'package:flutter/material.dart';
import 'package:super_player/super_player.dart';

class VideoPlayerController extends TXVodPlayerController {
  int cacheDate = 0;
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
    _subscription = onPlayerNetStatusBroadcast.listen((event) async {
      double w = (event["VIDEO_WIDTH"]).toDouble();
      double h = (event["VIDEO_HEIGHT"]).toDouble();
      if (w > 0 && h > 0) {
        print('111111111');
        if (aspectRatio.value == 0) {
          aspectRatio.value = 1.0 * w / h;
        }
      }
    });
  }

  @override
  Future<bool> startVodPlay(String url) async {
    this.url = url;
    final res = await super.startVodPlay(url);
    _canResume = true;
    _initializeCompleter.complete();
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