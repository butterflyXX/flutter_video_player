import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_demo/hero_player.dart';
import 'package:video_player_demo/main.dart';

class DetailPage extends StatelessWidget {
  final PlayerItem controller;
  final String tag;
  const DetailPage({required  this.controller, required this.tag, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("detail"),),
      body: Column(
        children: [
          HeroPlayer(controller: controller),
        ],
      ),
    );
  }
}
