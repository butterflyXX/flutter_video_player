import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/widget/button/interaction_button.dart';

class InteractionWidget extends StatelessWidget {
  const InteractionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InteractionButton(icon: Icons.star_purple500_sharp, title: '追剧', onTap: (){},),
        SizedBox(height: 20.w),
        InteractionButton(icon: Icons.chat, title: '174', onTap: (){},),
        SizedBox(height: 20.w),
        InteractionButton(icon: Icons.favorite, title: '7828', onTap: (){},),
      ],
    );
  }
}
