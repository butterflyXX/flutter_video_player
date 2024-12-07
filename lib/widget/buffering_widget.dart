import 'package:flutter/material.dart';

class BufferingWidget extends StatefulWidget {
  const BufferingWidget({super.key});

  @override
  State createState() => _LoadingEffectState();
}

class _LoadingEffectState extends State<BufferingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 初始化动画控制器
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(); // 循环动画

    // 创建动画
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6,
      child: Center(
        child: Container(
          height: 1.5,
          width: double.infinity,
          color: Colors.white.withOpacity(0.2),
          child: CustomPaint(
            painter: LoadingEffectPainter(animation: _animation),
          ),
        ),
      ),
    );
  }
}

class LoadingEffectPainter extends CustomPainter {
  final Animation<double> animation;

  LoadingEffectPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = size.height
      ..strokeCap = StrokeCap.round;

    // 动态位置
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double progress = animation.value;

    // 左右短线的位置
    double leftX = centerX - progress * centerX;
    double rightX = centerX + progress * centerX;

    // 渐隐效果
    double opacity = 1 - progress;

    paint.color = Colors.white.withOpacity(opacity);

    // 绘制左侧短线
    canvas.drawLine(
      Offset(leftX, centerY), // 上端点
      Offset(rightX, centerY), // 下端点
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}