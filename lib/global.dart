import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player_demo/player_item.dart';
import 'package:video_player_demo/video_controller.dart';

final currentController = ValueNotifier<PlayerItem?>(null);
final controllerProvider = Provider((_)=>VideoController(maxCacheCount: 5));