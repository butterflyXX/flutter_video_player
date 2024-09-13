import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_demo/global.dart';
import 'package:video_player_demo/main.dart';

class HeroPlayer extends StatefulWidget {
  final PlayerItem controller;

  const HeroPlayer({required this.controller, super.key});

  @override
  State<HeroPlayer> createState() => _HeroPlayerState();
}

class _HeroPlayerState extends State<HeroPlayer> {
  final color = const Color(0xFFFDFBFC);

  int flag = 0;
  final showControl = ValueNotifier(true);
  final position = ValueNotifier<Duration>(Duration.zero);
  final isPlaying = ValueNotifier(true);

  @override
  void initState() {
    widget.controller.controller.addListener(_listener);
    show();
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.controller.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    position.value = widget.controller.controller.value.position;
    isPlaying.value = widget.controller.controller.value.isPlaying;
    if (widget.controller.controller.value.isCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        play();
      });
    }
  }

  show({bool? isShow}) {
    final toShow = isShow ??= showControl.value;
    flag++;
    if (!toShow) {
      showControl.value = true;
      final tag = flag;
      Future.delayed(const Duration(seconds: 3)).then((_) {
        if (showControl.value && tag == flag) {
          show();
        }
      });
    } else {
      showControl.value = false;
    }
  }

  void play() async {
    show(isShow: false);
    isPlaying.value = !isPlaying.value;
    if (isPlaying.value) {
      await widget.controller.controller.play();
    } else {
      await widget.controller.controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: show,
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
            child: ValueListenableBuilder(
              valueListenable: showControl,
              builder: (context, show, child) {
                return AnimatedOpacity(
                  opacity: show ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: IgnorePointer(
                          ignoring: !show,
                          child: Center(
                            child: GestureDetector(
                              onTap: play,
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
                      ),
                      _progressBar(),
                      SafeArea(
                        child: SizedBox(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressBar() {
    const tagSize = 10.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ValueListenableBuilder(
        valueListenable: position,
        builder: (context, value, _) {
          var ratio = value.inMilliseconds / widget.controller.controller.value.duration.inMilliseconds;
          if (widget.controller.controller.value.duration.inMilliseconds == 0) {
            ratio = 0;
          }
          return Row(
            children: [
              _timeItem(value),
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  print(constraints);
                  final width = constraints.maxWidth - tagSize;
                  return SizedBox(
                    height: tagSize,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Positioned(
                          left: tagSize / 2,
                          right: tagSize / 2,
                          child: Container(
                            height: 2,
                            decoration: ShapeDecoration(
                              color: color.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: tagSize / 2,
                          child: Container(
                            width: ratio * width,
                            height: 2,
                            decoration: ShapeDecoration(
                              color: color,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: ratio * width,
                          child: Container(
                            width: tagSize,
                            height: tagSize,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(tagSize / 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              _timeItem(widget.controller.controller.value.duration.inMilliseconds == 0 ? null : widget.controller.controller.value.duration),
            ],
          );
        },
      ),
    );
  }

  Widget _timeItem(Duration? duration) {
    return Text(
      (duration == null) ? "--:--:--" : formatDuration(duration),
      style: TextStyle(color: color),
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
}
