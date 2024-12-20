import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/widget/button/column_button.dart';

class InteractionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Color tintColor;

  const InteractionButton({
    required this.icon,
    required this.title,
    this.onTap,
    this.tintColor = Colors.white,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.w,
      child: ColumnButton(
        top: Icon(
          icon,
          color: tintColor,
          size: 30,
        ),
        bottom: Text(
          title,
          style: TextStyle(color: tintColor),
        ),
        onTap: onTap,
      ),
    );
  }
}
