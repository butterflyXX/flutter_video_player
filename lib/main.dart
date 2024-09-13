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
  final controller = VideoController(maxCacheCount: 5);
  final pageController = PageController();

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
    setData(0);
    super.initState();
  }

  setData(int index) {
    final cache = getCacheList(index);
    cache.forEach(print);
    currentController.value = controller.getItem(_videoUrls[index], cache: cache);
  }

  @override
  void dispose() {
    super.dispose();
  }
  //
  // void _checkPlaybackState(PlayerItem item) {
  //   // print("isBuffering ${item.index} ${item.controller?.value.isBuffering}");
  //   if (item.index == 2 && item.controller?.value.buffered.isNotEmpty == true) {
  //     final list = item.controller?.value.buffered.last;
  //     print("${item.index} isBuffering ${list?.end} ${item.controller?.value.isInitialized} ${item.controller?.value.position}");
  //   }
  // }

  List<String> getCacheList(int index) {
    if (index == 0) {
      return _videoUrls.take(3).toList();
    } else if (index == 1) {
      return _videoUrls.take(4).toList();
    } else {
      final list = [_videoUrls[index - 2], _videoUrls[index - 1], _videoUrls[index]];
      if (index + 1 < _videoUrls.length) {
        list.add(_videoUrls[index + 1]);
      }
      if (index + 2 < _videoUrls.length) {
        list.add(_videoUrls[index + 2]);
      }
      return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: pageController,
        scrollDirection: Axis.vertical,
        itemCount: _videoUrls.length,
        itemBuilder: (context, index) {
          print("index = $index");
          final tag = index.toString();
          final url = _videoUrls[index];
          return GestureDetector(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              //   return DetailPage(controller: currentController.value!, tag: tag);
              // }));
            },
            child: HeroPlayer(
              controller: controller.getItem(url,position: Duration.zero),
            ),
          );
        },
        onPageChanged: setData,
      ),
    );
  }
}

class PlayerItem {
  int cacheDate;
  String url = '';
  VideoPlayerController controller;
  PlayerItem(this.url,{required this.controller, required this.cacheDate,});
}

class VideoController {
  int maxCacheCount;
  VideoController({this.maxCacheCount = 9});
  final Map<String, PlayerItem> _controllers = {};
  PlayerItem getItem(String url,{Duration? position, List<String>? cache}) {
    final date = DateTime.now().millisecondsSinceEpoch;
    PlayerItem item = cacheItem(url);
    item.cacheDate = date;
    if (position != null) {
      item.controller.seekTo(position);
    }
    cache?.forEach((item) {
      cacheItem(item);
    });
    //查看混存
    checkCache();
    return item;
  }

  PlayerItem cacheItem(String url) {
    if (_controllers[url] != null) return _controllers[url]!;
    VideoPlayerController controller = VideoPlayerController.networkUrl(Uri.parse(url));
    controller.initialize();
    _controllers[url] = PlayerItem(url, controller: controller, cacheDate: DateTime.now().millisecondsSinceEpoch);
    return _controllers[url]!;
  }

  checkCache() {
    if (_controllers.length > maxCacheCount) {
      String? needDeleteItemKey;
      for (final item in _controllers.entries) {
        needDeleteItemKey ??= item.key;
        if (_controllers[needDeleteItemKey]!.cacheDate > item.value.cacheDate) {
          needDeleteItemKey = item.key;
        }
      }
      print("删除 $needDeleteItemKey");
      final item = _controllers.remove(needDeleteItemKey);
      item?.controller.dispose();
    }
  }
}
