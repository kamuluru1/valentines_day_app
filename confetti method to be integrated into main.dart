import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class ConfettiExplosion extends StatefulWidget {
  const ConfettiExplosion({super.key});

  @override
  _ConfettiExplosionState createState() => _ConfettiExplosionState();
}

class _ConfettiExplosionState extends State<ConfettiExplosion> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  void triggerConfetti() {
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirection: -pi / 2, 
          emissionFrequency: 0.1,
          numberOfParticles: 30,
          gravity: 0.1,
        ),
        ElevatedButton(
          onPressed: triggerConfetti, 
          child: const Text("Confetti"),
        ),
      ],
    );
  }
}
