import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:video_player/source.dart';
import 'package:video_player/video_control.dart';
import 'package:video_player/widget/play_item.dart';

class DetailPage extends StatefulWidget {
  final String? initialUrl;

  const DetailPage({
    this.initialUrl,
    super.key,
  });

  @override
  State<DetailPage> createState() => _HomePageState();
}

class _HomePageState extends State<DetailPage> {
  late PageController pageController;
  final _screenshotController = ScreenshotController();

  final imageData = ValueNotifier<Uint8List?>(null);

  setData(int index, {bool needPauseLast = true}) {
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
    int index = 0;
    if (widget.initialUrl != null) {
      index = urls.indexOf(widget.initialUrl!);
    }
    pageController = PageController(initialPage: index);
    setData(index, needPauseLast: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Screenshot(
      controller: _screenshotController,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.black,
            body: PageView.builder(
              controller: pageController,
              scrollDirection: Axis.vertical,
              itemCount: urls.length,
              itemBuilder: (context, index) {
                final url = urls[index];
                return GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    //   return DetailPage(controller: currentController.value!, tag: tag);
                    // }));
                  },
                  child: PlayItem(
                    controller: VideoControl.instance.cacheItem(url),
                  ),
                );
              },
              onPageChanged: setData,
            ),
          ),
        ],
      ),
    );
  }

  void _captureScreenshot() async {
    final image = await _screenshotController.capture();
    if (image != null) {
      // 处理截图，保存到文件或显示
      print('截图成功');
      imageData.value = image;
    } else {
      print('截图失败');
    }
  }
}
