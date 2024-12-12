import 'package:flutter/material.dart';

class SpeedDialog extends StatelessWidget {
  static const _list = <double>[0.25, 0.5, 1, 1.5, 2];
  final double selected;
  final ValueChanged<double>? onTap;

  const SpeedDialog({
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
          ...List.generate(_list.length, (index) {
            return GestureDetector(
              onTap: () {
                onTap?.call(_list[index]);
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
    final selectIndex = _list.indexOf(selected);
    final isSelected = selectIndex == index;
    final textColor = isSelected ? Colors.redAccent : Colors.black;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 40,
          child: Center(
            child: Text(
              _list[index].toString(),
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
