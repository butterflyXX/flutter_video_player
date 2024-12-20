import 'package:flutter/material.dart';

class ColumnButton extends StatelessWidget {
  final Widget top;
  final Widget bottom;
  final VoidCallback? onTap;

  const ColumnButton({
    required this.top,
    required this.bottom,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: [
          top,
          bottom,
        ],
      ),
    );
  }
}
