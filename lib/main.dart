import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:super_player/super_player.dart';
import 'package:video_player/home/home_page.dart';
import 'package:video_player/video_control.dart';
import 'package:video_player/widget/buffering_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String licenceURL = "https://license.vod2.myqcloud.com/license/v2/1311477396_1/v_cube.license"; // 获取到的 licence url
  String licenceKey = "616d85285280f69e09ccd76bb05f2394"; // 获取到的 licence key
  await SuperPlayerPlugin.setGlobalLicense(licenceURL, licenceKey);
  VideoControl.initialize(maxCacheCount: 9);
  runApp(const ProviderScope(child: MyApp()));
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
      home: const HomePage(),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final _controller = TXVodPlayerController();

  final _aspectRatio = ValueNotifier<double?>(null);

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  initializePlayer() async {
    _controller.onPlayerNetStatusBroadcast.listen((event) async {
      double w = (event["VIDEO_WIDTH"]).toDouble();
      double h = (event["VIDEO_HEIGHT"]).toDouble();
      if (w > 0 && h > 0) {
        _aspectRatio.value = 1.0 * w / h;
      }
    });
    await _controller.initialize();
    _controller.setAutoPlay(isAutoPlay: false);
    String url = "https://video-v1.mydramawave.com/vt/video/convert-test/ofHuiO1SwI_839bb12d-37c7-4db3-b9ac-861073978264/h264/master.m3u8";
    await _controller.startVodPlay(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: ValueListenableBuilder(
          valueListenable: _aspectRatio,
          builder: (context, value, child) {
            if (value != null) {
              return Center(
                child: AspectRatio(
                  aspectRatio: value,
                  child: TXPlayerVideo(controller: _controller),
                ),
              );
            } else {
              return Column(
                children: [
                  child!,
                  const SizedBox(height: 100,),
                ],
              );
            }
          },
          child: const BufferingWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
      ),
    );
  }
}