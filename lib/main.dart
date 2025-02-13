import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Animated Beating Heart')),
        body: const Center(
          child: HeartBeatWidget(),
        ),
      ),
    );
  }
}

class HeartBeatWidget extends StatefulWidget {
  const HeartBeatWidget({super.key});

  @override
  _HeartBeatWidgetState createState() => _HeartBeatWidgetState();
}

class _HeartBeatWidgetState extends State<HeartBeatWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
  }

  void _toggleAnimation() {
    setState(() {
      if (_isAnimating) {
        _controller.stop();
      } else {
        _controller.forward();
      }
      _isAnimating = !_isAnimating;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleAnimation,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: CustomPaint(
              size: const Size(100, 100),
              painter: HeartPainter(),
            ),
          );
        },
      ),
    );
  }
}

class HeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint fillPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    Paint outlinePaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    double width = size.width;
    double height = size.height;

    Path path = Path();
    path.moveTo(width / 2, height * 0.8);
    path.cubicTo(-0.3 * width, height * 0.3, width * 0.2, height * -0.2,
        width / 2, height * 0.3);
    path.cubicTo(width * 0.8, height * -0.2, width * 1.3, height * 0.3,
        width / 2, height * 0.8);

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, outlinePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

