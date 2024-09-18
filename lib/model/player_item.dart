import 'package:video_player/video_player.dart';

class PlayerItem {
  int cacheDate;
  String url = '';
  VideoPlayerController controller;
  PlayerItem(this.url,{required this.controller, required this.cacheDate,});
}