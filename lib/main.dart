import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: const MyHomePage(title: 'Happy Valentines Day!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Create a GlobalKey to access HeartBeatWidget's state
  final GlobalKey<_HeartBeatWidgetState> _heartBeatKey = GlobalKey<_HeartBeatWidgetState>();
  Timer? _timer;
  int _timePassed = 0;

  void _toggleAnimationAndTimer() {
    final currentlyAnimating = _heartBeatKey.currentState?.isAnimating ?? false;
    _heartBeatKey.currentState?.toggleAnimation();

    if (!currentlyAnimating) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _timePassed++;
        });
      });
    } else {
      _timer?.cancel();
      _timer = null;
      setState(() {
        _timePassed = 0;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final isAnimating = _heartBeatKey.currentState?.isAnimating ?? false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: FloatingActionButton.extended(
              label: Text(isAnimating? 'Stop Animation' : 'Start Animation'),
              icon: Icon(isAnimating? Icons.pause : Icons.play_arrow),
              onPressed: () {
                _toggleAnimationAndTimer();
                setState(() {});
              },
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Enter a message',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton.extended(
                    onPressed: () {},
                    label: const Text("Enter"),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: HeartBeatWidget(key: _heartBeatKey),
                ),
              ),
              const SizedBox(height: 16,),
              Expanded(
                child: Text(
                  '$_timePassed',
                  style: TextStyle(
                    fontSize: 50,
                  ),
                ),
              )
            ],
          ),
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
  bool get isAnimating => _isAnimating;

  @override
  void initState() {
    super.initState();

    // Initialize the controller with a duration of 1 second.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Define the scale animation from 1.0 to 1.3.
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  // Public method to toggle the animation.
  void toggleAnimation() {
    if (!_isAnimating) {
      // Start the animation with a repeating cycle (reverse creates the pulsing effect)
      _controller.repeat(reverse: true);
    } else {
      // Stop the animation and reset the value.
      _controller.stop();
      _controller.reset();
    }
    setState(() {
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
    // Use AnimatedBuilder to rebuild when the animation changes.
    return AnimatedBuilder(
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
