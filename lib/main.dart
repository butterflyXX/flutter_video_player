import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:super_player/super_player.dart';
import 'package:video_player/global.dart';
import 'package:video_player/home/home_page.dart';
import 'package:video_player/my_navigator_observer.dart';
import 'package:video_player/provider/audio_session_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
  String licenceURL = "https://license.vod2.myqcloud.com/license/v2/1311477396_1/v_cube.license"; // 获取到的 licence url
  String licenceKey = "616d85285280f69e09ccd76bb05f2394"; // 获取到的 licence key
  await SuperPlayerPlugin.setGlobalLicense(licenceURL, licenceKey);
  SuperPlayerPlugin.setLogLevel(6);
  SuperPlayerPlugin.setConsoleEnabled(false);
  //设置播放引擎的全局缓存目录和缓存大小，//单位MB
  SuperPlayerPlugin.setGlobalMaxCacheSize(1024);
//设置播放引擎的全局缓存目录
  SuperPlayerPlugin.setGlobalCacheFolderPath("postfixPath");
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    baseContext = context;
    readProvider(audioSessionProvider);
    return ScreenUtilInit(
      builder: (_ , child) {
        return MaterialApp(
          title: 'Flutter Video List Demo',
          navigatorKey: navigatorKey,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: child!,
          navigatorObservers: [pageRouter],
        );
      },
      child: const HomePage(),
    );
  }
}
