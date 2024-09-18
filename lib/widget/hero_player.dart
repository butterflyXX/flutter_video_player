import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_video_player/global.dart';
import 'package:flutter_video_player/model/player_item.dart';
import 'package:flutter_video_player/widget/set_speed.dart';
import 'package:video_player/video_player.dart';

class HeroPlayer extends ConsumerStatefulWidget {
  final PlayerItem controller;

  const HeroPlayer({required this.controller, super.key});

  @override
  ConsumerState<HeroPlayer> createState() => _HeroPlayerState();
}

class _HeroPlayerState extends ConsumerState<HeroPlayer> {
  final color = const Color(0xFFFDFBFC);

  int flag = 0;
  final position = ValueNotifier<Duration>(Duration.zero);
  final isPlaying = ValueNotifier(true);
  var isDrag = false;
  var base = 0.0;
  int _task = 0;

  double? offset;

  @override
  void initState() {
    widget.controller.controller.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.controller.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    if (!isDrag) {
      position.value = widget.controller.controller.value.position;
      isPlaying.value = widget.controller.controller.value.isPlaying;
    }
  }

  Future<void> play() async {
    isPlaying.value = !isPlaying.value;
    if (isPlaying.value) {
      await widget.controller.controller.play();
    } else {
      await widget.controller.controller.pause();
    }
  }

  Future<void> seekTo(Duration position) async {
    widget.controller.controller.seekTo(position);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: play,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.black,
            child: Center(
              child: ValueListenableBuilder(
                valueListenable: currentController,
                builder: (_, current, child) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (current!.url == widget.controller.url) {
                      widget.controller.controller.play();
                    } else {
                      widget.controller.controller.pause();
                    }
                  });
                  return child!;
                },
                child: ValueListenableBuilder(
                  valueListenable: widget.controller.controller,
                  builder: (_, value, child) {
                    return AspectRatio(
                      aspectRatio: value.aspectRatio,
                      child: Hero(
                        tag: widget.controller.url,
                        child: VideoPlayer(widget.controller.controller),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Consumer(
              builder: (context, ref, child) {
                final scrolling = ref.watch(isScrollProvider);
                return Opacity(
                  opacity: scrolling ? 0.3 : 1,
                  child: child!,
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ValueListenableBuilder(
                            valueListenable: ref.read(controllerProvider).speed,
                            builder: (context, value, child) {
                              return IconButton(
                                onPressed: () async {
                                  final speed = await showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return SetSpeedWidget(
                                          selected: 1,
                                          onTap: (newSpeed) {
                                            Navigator.of(context).pop(newSpeed);
                                          },
                                        );
                                      });
                                  if (speed != null && ref.read(controllerProvider).speed != speed) {
                                    ref.read(controllerProvider).setSpeed(speed);
                                  }
                                },
                                icon: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: Text('${value.toString()}x'),
                                  ),
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: isPlaying,
                      builder: (context, value, child) {
                        return Opacity(opacity: value?0:1,child: child!,);
                      },
                      child: Center(
                        child: SizedBox(
                          height: 80,
                          width: 80,
                          child: ValueListenableBuilder(
                            valueListenable: isPlaying,
                            builder: (_, value, __) {
                              if (value) {
                                return Image.asset("assets/images/ic_pause.png");
                              } else {
                                return Image.asset("assets/images/ic_play.png");
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  _progressBar(),
                  const SafeArea(
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ValueListenableBuilder(
        valueListenable: position,
        builder: (context, value, _) {
          var ratio = value.inMilliseconds / widget.controller.controller.value.duration.inMilliseconds;
          if (widget.controller.controller.value.duration.inMilliseconds == 0 || ratio < 0) {
            ratio = 0;
          }
          return Row(
            children: [
              _timeItem(value),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: color,
                    // 激活轨道颜色
                    inactiveTrackColor: color.withOpacity(0.2),
                    // 非激活轨道颜色
                    thumbColor: color,
                    // 滑块颜色
                    overlayColor: color,
                    // 滑块拖拽时的覆盖层颜色
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4.0),
                    // 滑块形状
                    trackHeight: 2,
                    // 轨道高度
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 8),
                  ),
                  child: Slider(
                    value: ratio,
                    min: 0.0,
                    max: 1.0,
                    onChanged: (value) {
                      print("onChanged");
                      final a = getRealRatio(value) * widget.controller.controller.value.duration.inMilliseconds;
                      position.value = Duration(milliseconds: a.toInt());
                      _listener();
                      _task++;
                    },
                    onChangeStart: (value) {
                      print("onChangeStart");
                      base = ratio;
                      isDrag = true;
                    },
                    onChangeEnd: (value) {
                      print("onChangeEnd");
                      var ratio = getRealRatio(value);
                      if (_task == 1) {
                        ratio = value;
                      }
                      final a = ratio * widget.controller.controller.value.duration.inMilliseconds;
                      _task = 0;
                      seekTo(Duration(milliseconds: a.toInt())).then((_) {
                        isDrag = false;
                        offset = null;
                      });
                    },
                  ),
                ),
              ),
              _timeItem(widget.controller.controller.value.duration.inMilliseconds == 0 ? null : widget.controller.controller.value.duration),
            ],
          );
        },
      ),
    );
  }

  Widget _timeItem(Duration? duration) {
    return SizedBox(
      width: 100,
      child: Center(
        child: Text(
          (duration == null) ? "--:--:--" : formatDuration(duration),
          style: TextStyle(color: color),
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes % 60;
    final int seconds = duration.inSeconds % 60;

    final String hoursStr = hours.toString().padLeft(2, '0');
    final String minutesStr = minutes.toString().padLeft(2, '0');
    final String secondsStr = seconds.toString().padLeft(2, '0');
    return '$hoursStr:$minutesStr:$secondsStr';
  }

  double getRealRatio(double ratio) {
    offset ??= ratio - base;
    var realRatio = ratio - offset!;
    if (realRatio < 0) realRatio = 0;
    if (realRatio > 1) realRatio = 1;
    return realRatio;
  }
}
