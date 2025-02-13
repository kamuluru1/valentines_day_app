import 'dart:async';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

void main() {
  runApp(const HeartBeatAnimationApp());
}

class HeartBeatAnimationApp extends StatelessWidget {
  const HeartBeatAnimationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Valentine's Day Heartbeat",
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin {
  late final AnimationController _heartbeatController;
  late final Animation<double> _heartbeatAnimation;

  Timer? _timer;
  int _countdown = 10;

  late final ConfettiController _confettiController;

  late final AnimationController _textFadeController;
  late final Animation<double> _textFadeAnimation;
  String _selectedGreeting = "";

  final List<String> greetings = const [
    "Happy Valentine's Day!",
    "Love is in the air!",
    "Be my Valentine!",
    "You are loved!",
  ];

  @override
  void initState() {
    super.initState();

    _heartbeatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _heartbeatAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _heartbeatController, curve: Curves.easeInOut),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
        _heartbeatController.stop();
        _confettiController.stop();
      }
    });

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    _confettiController.play();

    _textFadeController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _textFadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_textFadeController);
  }

  @override
  void dispose() {
    _heartbeatController.dispose();
    _timer?.cancel();
    _confettiController.dispose();
    _textFadeController.dispose();
    super.dispose();
  }

  void _onGreetingSelected(String message) {
    setState(() {
      _selectedGreeting = message;
    });
    _textFadeController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Valentine's Day Heartbeat"),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: true,
            colors: const [Colors.red, Colors.pink, Colors.white, Colors.purple],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Countdown: $_countdown",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ScaleTransition(
                scale: _heartbeatAnimation,
                child: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 100,
                ),
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _textFadeAnimation,
                child: Text(
                  _selectedGreeting,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.center,
                  children: greetings
                      .map(
                        (greeting) => ElevatedButton(
                      onPressed: () => _onGreetingSelected(greeting),
                      child: Text(
                        greeting,
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


