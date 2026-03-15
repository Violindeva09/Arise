import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../config/ui_config.dart';
import '../data/penalty_data.dart';

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
  int _penaltyIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize with a random index for variety
    _penaltyIndex = math.Random().nextInt(PenaltyData.penalties.length);
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeLeft > 0) _timeLeft--;
          
          // Glitch effect every 5 seconds
          if (timer.tick % 5 == 0) {
            _glitchToggle = !_glitchToggle;
            
            // Demo Mode: Cycle to next penalty every 5 seconds
            _penaltyIndex = (_penaltyIndex + 1) % PenaltyData.penalties.length;
          }
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
                  const SizedBox(height: 32),
                  if (PenaltyData.penalties.isNotEmpty) ...[
                    Text(
                      PenaltyData.penalties[_penaltyIndex].title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      PenaltyData.penalties[_penaltyIndex].desc,
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
