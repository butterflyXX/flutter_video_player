import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_video_player/controller/player_controller.dart';
import 'package:flutter_video_player/model/player_item.dart';

final currentController = ValueNotifier<PlayerItem?>(null);
final controllerProvider = Provider((_)=>PlayerController(maxCacheCount: 5));