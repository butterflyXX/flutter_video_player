import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/global.dart';

class TagWidget extends StatelessWidget {
  final String text;

  const TagWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.w),
        color: color.withOpacity(0.2),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 10.sp,
            color: color
          ),
        ),
      ),
    );
  }
}
