import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final detailDataProvider = AutoDisposeNotifierProvider<DetailDataProviderNotifier, bool>(DetailDataProviderNotifier.new);

class DetailDataProviderNotifier extends AutoDisposeNotifier<bool> {
  List dataList = [];
  PageController? pageController;
  @override
  bool build() {
    return true;
  }



}