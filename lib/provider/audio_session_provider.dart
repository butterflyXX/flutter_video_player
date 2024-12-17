import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/global.dart';

final audioSessionProvider = AsyncNotifierProvider<AudioSessionProviderNotifier, bool>(AudioSessionProviderNotifier.new);

class AudioSessionProviderNotifier extends AsyncNotifier<bool> with WidgetsBindingObserver {
  late AudioSession _audioSession;

  @override
  FutureOr<bool> build() async {
    WidgetsBinding.instance.addObserver(this);
    _audioSession = await AudioSession.instance;
    await _audioSession.configure(const AudioSessionConfiguration.music());
    AudioInterruptionType.duck;
    _audioSession.interruptionEventStream.listen((event) {
      if (event.begin) {
        ref.read(currentControllerProvider)?.groupController.pause();
      } else {
        ref.read(currentControllerProvider)?.groupController.resume();
      }
    });
    _audioSession.becomingNoisyEventStream.listen((_) {
      ref.read(currentControllerProvider)?.groupController.pause();
    });

    _audioSession.devicesChangedEventStream.listen((type) {
      final head = isHeadphones(type.devicesAdded);
      if (head) {
        _audioSession.setActive(true).then((_) async {
          await Future.delayed(Durations.medium1);
          ref.read(currentControllerProvider)?.groupController.resume();
        });
      }
    });
    return true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(currentControllerProvider)?.groupController.resume();
        break;
      case AppLifecycleState.inactive:
        ref.read(currentControllerProvider)?.groupController.pause();
        break;
      default:
        {}
    }
  }

  //音频输出到耳机(有线/无线/蓝牙)
  bool isHeadphones(Set<AudioDevice> devices) {
    try {
      for (final device in devices) {
        if (device.type == AudioDeviceType.wiredHeadset || device.type == AudioDeviceType.bluetoothA2dp) {
          return true;
        }
      }
    } catch (_) {}
    return false;
  }
}
