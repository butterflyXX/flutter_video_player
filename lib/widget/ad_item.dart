import 'package:flutter/material.dart';
import 'package:video_player/model/ad_item_model.dart';

class AdItem extends StatefulWidget {
  final AdItemModel model;

  const AdItem({
    required this.model,
    super.key,
  });

  @override
  State<AdItem> createState() => _AdItemState();
}

class _AdItemState extends State<AdItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('广告位'),
            ValueListenableBuilder(valueListenable: widget.model.watchCount, builder: (context, watchCount, _) {
              return Text(widget.model.watchCount.value <= 0 ? '广告已播放,可以滑动' : '广告播放中,${widget.model.watchCount.value}s 后可滑动');
            })

          ],
        ),
      ),
    );
  }
}
