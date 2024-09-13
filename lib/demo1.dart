import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_demo/detail_page.dart';
import 'package:video_player_demo/global.dart';
import 'package:video_player_demo/hero_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Video List Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VideoListPage(),
    );
  }
}

class VideoListPage extends StatefulWidget {
  const VideoListPage({Key? key}) : super(key: key);

  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  List<PlayerItem> controllerList = List.generate(5, (index) {
    return PlayerItem()..index = index - 2;
  });

  final List<String> _videoUrls = [
    'https://media.w3.org/2010/05/sintel/trailer.mp4',
    'https://stream7.iqilu.com/10339/upload_transcode/202002/09/20200209105011F0zPoYzHry.mp4',
    'https://stream7.iqilu.com/10339/upload_transcode/202002/09/20200209104902N3v5Vpxuvb.mp4',
    "https://sf1-cdn-tos.huoshanstatic.com/obj/media-fe/xgplayer_doc_video/mp4/xgplayer-demo-360p.mp4",
    "https://www.w3schools.com/html/movie.mp4",
    'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
    'https://s8.fsvod1.com/20221218/fhaBXZGu/index.m3u8',
    "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4",
  ];

  @override
  void initState() {
    refresh(0, isFirst: true);
    super.initState();
  }

  refresh(int index, {bool isFirst = false}) async {
    if (!isFirst) {
      final isUp = currentController.value!.index < index;
      PlayerItem needRefreshedItem;
      if (isUp) {
        needRefreshedItem = controllerList.removeAt(0);
        needRefreshedItem.index = index + 2;
        controllerList.add(needRefreshedItem);
      } else {
        needRefreshedItem = controllerList.removeLast();
        needRefreshedItem.index = index - 2;
        controllerList.insert(0, needRefreshedItem);
      }
      needRefreshedItem.hasUse = false;
      needRefreshedItem.controller?.dispose();
    }

    for (final item in controllerList) {
      if (!item.hasUse && item.index >= 0 && item.index < _videoUrls.length) {
        // 需要激活
        item.hasUse = true;
        item.controller = VideoPlayerController.networkUrl(Uri.parse(_videoUrls[item.index]));
        item.controller?.addListener(() {
          _checkPlaybackState(item);
        });
        item.controller?.initialize();
      }
      if (item.index == index) {
        currentController.value = item;
      }
    }
  }

  PlayerItem getItem(index) {
    for (final item in controllerList) {
      if (index == item.index) return item;
    }
    return controllerList.first;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _checkPlaybackState(PlayerItem item) {
    // print("isBuffering ${item.index} ${item.controller?.value.isBuffering}");
    if (item.index == 2 && item.controller?.value.buffered.isNotEmpty == true) {
      final list = item.controller?.value.buffered.last;
      print("${item.index} isBuffering ${list?.end} ${item.controller?.value.isInitialized} ${item.controller?.value.position}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _videoUrls.length,
        itemBuilder: (context, index) {
          print(index);
          final tag = index.toString();
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return DetailPage(controller: currentController.value!, tag: tag);
              }));
            },
            child: HeroPlayer(
              controller: getItem(index),
            ),
          );
        },
        onPageChanged: refresh,
      ),
    );
  }
}

class PlayerItem {
  int index = 0;
  bool hasUse = false;
  dynamic data;
  VideoPlayerController? controller;
}
