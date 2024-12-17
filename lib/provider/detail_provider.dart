import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/model/ad_item_model.dart';

final detailProvider = AutoDisposeNotifierProvider.family<DetailProviderNotifier, bool, String>(DetailProviderNotifier.new);

class DetailProviderNotifier extends AutoDisposeFamilyNotifier<bool, String> {

  Timer? _timer;

  @override
  bool build(String arg) {
    return true;
  }

  void setScroll(bool canScroll) {
    state = canScroll;
  }

  countDownAdItem(AdItemModel adItemModel) {
    setScroll(false);
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      adItemModel.watchCount.value--;
      if (adItemModel.watchCount.value == 0) {
        _timer?.cancel();
        _timer = null;
        setScroll(true);
      }
    });
  }
}