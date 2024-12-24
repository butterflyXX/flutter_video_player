import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/model/bitrate_model.dart';
import 'package:video_player/util/color.dart';
import 'package:video_player/util/safe_size.dart';
import 'package:video_player/video_list_controller.dart';

class BitrateSelectWidget extends StatefulWidget {
  final VideoListController controller;

  const BitrateSelectWidget({
    required this.controller,
    super.key,
  });

  @override
  State<BitrateSelectWidget> createState() => _BitrateSelectWidgetState();
}

class _BitrateSelectWidgetState extends State<BitrateSelectWidget> {
  late List<BitrateModel> _data;

  int selectedIndex = 0;

  @override
  void initState() {
    _data = List<BitrateModel>.from(widget.controller.bitrateList);
    _data.insert(0, BitrateModel(index: -1, width: 0, height: 0, bitrate: 0));
    final currentBitRate = widget.controller.currentBitrate.value;
    if (currentBitRate != null) {
      selectedIndex = _data.indexWhere((it) => it.height == currentBitRate.height);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: surface2,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20.w,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(text: '当前分辨率'),
                TextSpan(text: ' · ${max(widget.controller.currentController!.width, widget.controller.currentController!.height).round()}P', style: TextStyle(color: text3)),
              ],
              style: TextStyle(fontSize: 16.w),
            ),
          ),
          SizedBox(
            height: 10.w,
          ),
          ...List.generate(
            _data.length,
            (index) {
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  BitrateModel? bitrate;
                  if (index != 0) {
                    bitrate = _data[index];
                  }
                  widget.controller.setBitrateIndex(bitrate: bitrate);
                  Navigator.of(context).pop();
                },
                child: index == 0 ? _autoItem() : _commonItem(index),
              );
            },
          ),
          SizedBox(
            height: SafeSize.bottomBarHeight(),
          ),
        ],
      ),
    );
  }

  Widget _autoItem() {
    return _item(
      0,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Auto(recommended)',
              style: TextStyle(color: text1, fontSize: 16.w),
            ),
            SizedBox(height: 4.w),
            Text(
              'Adjust to give you the best experience for your conditions',
              style: TextStyle(color: text3, fontSize: 12.w),
            )
          ],
        ),
      ),
    );
  }

  Widget _commonItem(int index) {
    return _item(
      index,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.w),
        child: Text(
          '${_data[index].resolution}P',
          style: TextStyle(color: text1, fontSize: 16.w),
        ),
      ),
    );
  }

  Widget _item(int index, {required Widget child}) {
    final isSelected = selectedIndex == index;
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? surface3 : Colors.transparent,
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Row(
        children: [
          SizedBox(width: 8.w),
          Opacity(
            opacity: isSelected ? 1 : 0,
            child: const Icon(
              Icons.check_rounded,
              color: Colors.redAccent,
            ),
          ),
          SizedBox(width: 8.w),
          Flexible(child: child),
        ],
      ),
    );
  }
}
