import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/system_provider.dart';
import '../config/ui_config.dart';

class PenaltyScreen extends StatefulWidget {
  final VoidCallback onResolve;

  const PenaltyScreen({super.key, required this.onResolve});

  @override
  _PenaltyScreenState createState() => _PenaltyScreenState();
}

class _PenaltyScreenState extends State<PenaltyScreen> {
  int _timeLeft = 14400; // 4 hours
  late Timer _timer;
  bool _glitchToggle = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft > 0) _timeLeft--;
          if (timer.tick % 5 == 0) _glitchToggle = !_glitchToggle;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int h = seconds ~/ 3600;
    int m = (seconds % 3600) ~/ 60;
    int s = seconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final system = Provider.of<SystemProvider>(context);
    final penalty = system.currentPenalty;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildGlitchOverlay(),
          if (_glitchToggle) _buildGlitchLines(),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(32),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: AriseUI.danger, width: 2),
                boxShadow: [
                  BoxShadow(
                      color: AriseUI.danger.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: AriseUI.danger, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    "PENALTY QUEST",
                    style: TextStyle(
                      color: AriseUI.danger,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 8.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "FAILURE IS NOT AN OPTION",
                    style: TextStyle(
                        color: AriseUI.danger.withOpacity(0.5),
                        fontSize: 10,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  if (penalty != null) ...[
                    Text(
                      penalty.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      penalty.desc,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          height: 1.4),
                    ),
                  ],
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration:
                        BoxDecoration(color: AriseUI.danger.withOpacity(0.05)),
                    child: Center(
                      child: Text(
                        _formatTime(_timeLeft),
                        style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            fontFamily: 'monospace'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: widget.onResolve,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AriseUI.danger.withOpacity(0.1),
                        side: BorderSide(color: AriseUI.danger, width: 2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      child: Text(
                        "DISCIPLINE COMPLETED",
                        style: TextStyle(
                            color: AriseUI.danger,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlitchOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: AriseUI.danger.withOpacity(0.05),
      ),
    );
  }

  Widget _buildGlitchLines() {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              AriseUI.danger.withOpacity(0.1),
              Colors.transparent,
            ],
            stops: const [0.45, 0.5, 0.55],
          ),
        ),
      ),
    );
  }
}
