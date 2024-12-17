import 'dart:async';

import 'package:flutter/material.dart';

class CountDownWidget extends StatefulWidget {
  final int initCount;
  final IndexedWidgetBuilder builder;
  final VoidCallback? onFinished;
  final ValueChanged<int>? onChanged;

  const CountDownWidget({
    required this.builder,
    required this.initCount,
    this.onFinished,
    this.onChanged,
    super.key,
  });

  @override
  State<CountDownWidget> createState() => _CommonCountDownWidgetState();
}

class _CommonCountDownWidgetState extends State<CountDownWidget> {
  late int _count = widget.initCount;
  Timer? _timer;
  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_count == 0) {
        _disposeTimer();
        widget.onFinished?.call();
      } else {
        setState(() {
          _count--;
        });
        widget.onChanged?.call(_count);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _disposeTimer();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _count);
  }

  _disposeTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }
}
