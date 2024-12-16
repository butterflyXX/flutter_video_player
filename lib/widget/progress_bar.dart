import 'package:flutter/material.dart';
import 'package:super_player/super_player.dart';
import 'package:video_player/global.dart';
import 'package:video_player/video_player_controller.dart';
import 'package:video_player/widget/buffering_widget.dart';

class ProgressBar extends StatefulWidget {
  final VideoPlayerController controller;

  const ProgressBar({
    required this.controller,
    super.key,
  });

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {

  final _targetValue = ValueNotifier<double>(0);
  int _task = 0;

  double? _offset;
  double? _base;

  @override
  void initState() {
    _addListener();
    super.initState();
  }

  _addListener() => widget.controller.position.addListener(_listener);

  _removeListener() => widget.controller.position.removeListener(_listener);

  _listener() {
    double ratio = 0;
    final duration = widget.controller.duration;
    if (duration != 0) {
      ratio = widget.controller.position.value / duration;
    }
    if (ratio < 0) {
      ratio = 0;
    }
    if (ratio > 1) {
      ratio = 1;
    }
    _targetValue.value = ratio;
  }

  @override
  Widget build(BuildContext context) {
    const radius = 8.0;
    return StreamBuilder(stream: widget.controller.onPlayerState, builder: (context, snap) {
      final canPlay = snap.data != TXPlayerState.buffering;
      return SizedBox(
        height: 16,
        child: Stack(
          children: [
            if (!canPlay) const Center(
              child: Padding(padding: EdgeInsets.symmetric(horizontal: radius), child: BufferingWidget(),),
            ),
            if (canPlay) ValueListenableBuilder(
              valueListenable: _targetValue,
              builder: (context, value, _) {
                return SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: color,
                    // 激活轨道颜色
                    inactiveTrackColor: color.withOpacity(0.2),
                    // 非激活轨道颜色
                    thumbColor: color,
                    // 滑块颜色
                    overlayColor: color,
                    // 滑块拖拽时的覆盖层颜色
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    // 滑块形状
                    trackHeight: 2,
                    // 轨道高度
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: radius),
                  ),
                  child: Slider(
                    value: value,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (value) {
                      _targetValue.value = getRealRatio(value);
                      _task++;
                    },
                    onChangeStart: (value) {
                      _base = value;
                      _removeListener();
                    },
                    onChangeEnd: (value) {
                      var ratio = getRealRatio(value);
                      if (_task == 1) {
                        ratio = value;
                      }
                      final newPosition = ratio * widget.controller.duration;
                      _task = 0;
                      widget.controller.seek(newPosition).then((_) {
                        endDrag();
                        _addListener();
                      });
                    },
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  endDrag() {
    _base = null;
    _offset = null;
  }

  double getRealRatio(double ratio) {
    _offset ??= ratio - _base!;
    var realRatio = ratio - _offset!;
    if (realRatio < 0) realRatio = 0;
    if (realRatio > 1) realRatio = 1;
    return realRatio;
  }
}
