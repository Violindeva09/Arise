import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/system_provider.dart';
import '../config/ui_config.dart';
import '../services/system_audio_service.dart';

class AwakeningScreen extends StatefulWidget {
  const AwakeningScreen({super.key});

  @override
  _AwakeningScreenState createState() => _AwakeningScreenState();
}

class _AwakeningScreenState extends State<AwakeningScreen> {
  final List<Offset> _errors = [];
  bool _isForced = false;
  bool _isSpawning = false;
  final math.Random _random = math.Random();

  void _triggerErrorCascade() async {
    if (_isSpawning) return;
    setState(() => _isSpawning = true);

    for (int i = 0; i < 120; i++) {
      await Future.delayed(Duration(milliseconds: 30 + (i % 10)));
      if (!mounted) return;
      SystemAudioService().playClick(); // Fast rapid click for errors
      setState(() {
        _errors.add(Offset(
          _random.nextDouble() * (MediaQuery.of(context).size.width - 150),
          _random.nextDouble() * (MediaQuery.of(context).size.height - 80),
        ));
      });
    }

    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    SystemAudioService().playAlert(); // Final alert when forced
    setState(() {
      _errors.clear();
      _isForced = true;
      _isSpawning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final system = Provider.of<SystemProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main Notice
          Center(
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: AriseUI.hudPanel(),
              width: 700,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: AriseUI.primary, size: 80),
                  const SizedBox(height: 24),
                  Text("NOTICE",
                      style: AriseUI.heading.copyWith(color: AriseUI.primary)),
                  const SizedBox(height: 32),
                  Text(
                    "You have met all the requirements of the Secret Quest: \"Courage of the Weak.\"",
                    textAlign: TextAlign.center,
                    style: AriseUI.body,
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style:
                          AriseUI.subHeading.copyWith(fontFamily: 'Orbitron'),
                      children: [
                        TextSpan(
                            text: "You have earned the right to become a "),
                        TextSpan(
                            text: "Player",
                            style: TextStyle(
                                color: AriseUI.danger,
                                fontWeight: FontWeight.bold)),
                        TextSpan(text: ". Will you accept?"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  Row(
                    children: [
                      if (!_isForced) ...[
                        Expanded(
                          child: OutlinedButton(
                            onPressed:
                                _isSpawning ? null : _triggerErrorCascade,
                            style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white24)),
                            child: const Text("DECLINE",
                                style: TextStyle(color: Colors.white24)),
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSpawning
                              ? null
                              : () {
                                  SystemAudioService().playLevelUp();
                                  system.awakenPlayer();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AriseUI.primary,
                            foregroundColor: Colors.black,
                          ),
                          child: const Text("ACCEPT",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Error Cascade Overlay
          ..._errors.map((pos) => Positioned(
                left: pos.dx,
                top: pos.dy,
                child: _buildErrorBox(),
              )),
        ],
      ),
    );
  }

  Widget _buildErrorBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: AriseUI.danger, width: 2),
        boxShadow: [
          BoxShadow(color: AriseUI.danger.withOpacity(0.5), blurRadius: 10)
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: AriseUI.danger, size: 16),
          SizedBox(height: 4),
          Text("ACCESS DENIED",
              style: TextStyle(
                  color: AriseUI.danger,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace')),
          Text("CANNOT DECLINE SYSTEM",
              style: TextStyle(color: Colors.white, fontSize: 8)),
        ],
      ),
    );
  }
}
