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

  setData(int index) {
    VideoControl.instance.currentController?.pause();
    final cache = getCacheList(index);
    for (var item in cache) {
      VideoControl.instance.cacheItem(item);
    }
    VideoControl.instance.currentController = VideoControl.instance.cacheItem(urls[index]);
    VideoControl.instance.currentController?.waitCanResume().then((_) {
      VideoControl.instance.currentController?.resume();
    });
  }

  List<String> getCacheList(int index) {
    if (index == 0) {
      return urls.take(3).toList();
    } else if (index == 1) {
      return urls.take(4).toList();
    } else {
      final list = [urls[index - 2], urls[index - 1], urls[index]];
      if (index + 1 < urls.length) {
        list.add(urls[index + 1]);
      }
      if (index + 2 < urls.length) {
        list.add(urls[index + 2]);
      }
      return list;
    }
  }

  @override
  void initState() {
    setData(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
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
        onPageChanged: setData,
      ),
    );
  }
}
