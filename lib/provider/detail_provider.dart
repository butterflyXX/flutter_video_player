import 'package:flutter_riverpod/flutter_riverpod.dart';

final detailProvider = AutoDisposeNotifierProvider.family<DetailProviderNotifier, bool, String>(DetailProviderNotifier.new);

class DetailProviderNotifier extends AutoDisposeFamilyNotifier<bool, String> {
  @override
  bool build(String arg) {
    return true;
  }

  void setScroll(bool canScroll) {
    state = canScroll;
  }
}