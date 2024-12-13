import 'package:flutter/material.dart';

class SpeedDialog<T> extends StatelessWidget {
  final List<T> source;
  final T selected;
  final ValueChanged<int>? onTap;

  const SpeedDialog({
    required this.source,
    required this.selected,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20,),
          ...List.generate(source.length, (index) {
            return GestureDetector(
              onTap: () {
                onTap?.call(index);
                Navigator.of(context).pop();
              },
              child: _item(index),
            );
          }),
          SafeArea(child: Container()),
        ],
      ),
    );
  }

  Widget _item(int index) {
    final selectIndex = source.indexOf(selected);
    final isSelected = selectIndex == index;
    final textColor = isSelected ? Colors.redAccent : Colors.black;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 40,
          child: Center(
            child: Text(
              source[index].toString(),
              style: TextStyle(color: textColor),
            ),
          ),
        ),
        if(isSelected) const Positioned(
          left: 150,
          child: Icon(Icons.check_rounded, color: Colors.redAccent,),
        ),
      ],
    );
  }
}
