import 'package:flutter/material.dart';

class SetSpeedWidget extends StatelessWidget {
  static const _list = <double>[0.25, 0.5, 1, 1.5, 2];
  final double selected;
  final ValueChanged<double>? onTap;

  const SetSpeedWidget({
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
              },
              child: SizedBox(
                height: 40,
                child: Text(
                  _list[index].toString(),
                ),
              ),
            );
          }),
          SafeArea(child: Container()),
        ],
      ),
    );
  }
}
