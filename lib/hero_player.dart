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

  int flag = 0;
  final showControl = ValueNotifier(true);
  final position = ValueNotifier<Duration>(Duration.zero);
  
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
    position.value = widget.controller.controller.value.position;
  }

  show() {
    if (!showControl.value) {
      showControl.value = true;
      final tag = flag;
      Future.delayed(const Duration(seconds: 3)).then((_) {
        if (showControl.value && tag == flag) {
          show();
        }
      });
    } else {
      showControl.value = false;
      flag++;
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
                valueListenable: widget.controller.controller,
                builder: (_, value, child) {
                  if (value.isInitialized) {
                    return ValueListenableBuilder(
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
                      child: AspectRatio(
                        aspectRatio: value.aspectRatio,
                        child: Hero(
                          tag: widget.controller.url,
                          child: VideoPlayer(widget.controller.controller),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(), // Displays the loading spinner
                    );
                  }
                },
              ),
            ),
          ),
          Positioned.fill(
            child: ValueListenableBuilder(
              valueListenable: showControl,
              builder: (context, value, child) {
                return AnimatedOpacity(
                  opacity: value ? 1 : 0,
                  duration: Duration(milliseconds: 200),
                  child: child!,
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 300,),
                  _progressBar(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressBar() {
    const tagSize = 10.0;
    const color = Color(0xFFFDFBFC);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: SizedBox(
        height: tagSize,
        child: ValueListenableBuilder(
          valueListenable: position,
          builder: (context, value, _) {
            var ratio = value.inMilliseconds/widget.controller.controller.value.duration.inMilliseconds;
            if (widget.controller.controller.value.duration.inMilliseconds == 0) {
              ratio = 0;
            }
            return LayoutBuilder(
              builder: (context,constraints) {
                print(constraints);
                final width = constraints.maxWidth - tagSize;
                return Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Positioned(
                      left: tagSize/2,
                      right: tagSize/2,
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
                      left: tagSize/2,
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
                          borderRadius: BorderRadius.circular(tagSize/2),
                        ),
                      ),
                    ),
                  ],
                );
              }
            );
          },
        ),
      ),
    );
  }
}
