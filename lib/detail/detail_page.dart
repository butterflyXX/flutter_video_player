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
              allowImplicitScrolling: true,
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
