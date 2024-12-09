import 'package:flutter/material.dart';
import 'package:video_player/detail/detail_page.dart';
import 'package:video_player/source.dart';
import 'package:video_player/video_control.dart';
import 'package:video_player/widget/play_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pageController = PageController();

  @override
  void initState() {
    setCurrentVideoPlayerController(0);
    super.initState();
  }

  void setCurrentVideoPlayerController(index) {
    final url = urls[index];
    final current = VideoControl.instance.cacheItem(url);
    VideoControl.instance.setCurrentVideoPlayerController(current);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        allowImplicitScrolling: true,
        controller: pageController,
        scrollDirection: Axis.vertical,
        itemCount: urls.length,
        itemBuilder: (context, index) {
          final url = urls[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return DetailPage(initialUrl: url,);
              }));
            },
            child: PlayItem(
              controller: VideoControl.instance.cacheItem(url),
            ),
          );
        },
        onPageChanged: setCurrentVideoPlayerController,
      ),
    );
  }
}
