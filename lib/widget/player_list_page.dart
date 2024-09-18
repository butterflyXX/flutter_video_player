import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_video_player/controller/player_controller.dart';
import 'package:flutter_video_player/global.dart';
import 'package:flutter_video_player/widget/hero_player.dart';

class PlayerListPage extends ConsumerStatefulWidget {
  const PlayerListPage({super.key});

  @override
  ConsumerState createState() => _VideoListPageState();
}

class _VideoListPageState extends ConsumerState<PlayerListPage> {
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.position.isScrollingNotifier.addListener(_onScroll);
    });
    super.initState();
  }

  late PlayerController controller = ref.read(controllerProvider);

  setData(int index) {
    final cache = getCacheList(index);
    cache.forEach(print);
    currentController.value = controller.getItem(_videoUrls[index], cache: cache);
  }

  @override
  void dispose() {
    pageController.position.isScrollingNotifier.removeListener(_onScroll);
    pageController.dispose();
    super.dispose();
  }

  void _onScroll() {
    ref.read(isScrollProvider.notifier).state = pageController.position.isScrollingNotifier.value;
  }

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