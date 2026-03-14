import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/system_provider.dart';
import '../config/ui_config.dart';
import '../services/system_audio_service.dart';

class RoutineSelectionScreen extends StatelessWidget {
  const RoutineSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final system = Provider.of<SystemProvider>(context);

    return Scaffold(
      backgroundColor: AriseUI.background,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: AriseUI.hudPanel(),
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("PATH SELECTION", style: AriseUI.heading),
              const SizedBox(height: 12),
              Text(
                "Select your training environment. This decision will define your specialty.",
                textAlign: TextAlign.center,
                style: AriseUI.body.copyWith(color: Colors.white54),
              ),
              const SizedBox(height: 48),
              _buildOption(context, system, "HOME",
                  "Focus on core strength & bodyweight.", Icons.home_outlined),
              const SizedBox(height: 16),
              _buildOption(context, system, "CALISTHENICS",
                  "Master agility & explosive power.", Icons.fitness_center),
              const SizedBox(height: 16),
              _buildOption(context, system, "GYM",
                  "Absolute power & mass building.", Icons.apartment_outlined),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, SystemProvider system, String type,
      String desc, IconData icon) {
    return InkWell(
      onTap: () {
        SystemAudioService().playClick();
        system.setWorkoutType(type);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: AriseUI.primary.withOpacity(0.2)),
          color: Colors.black.withOpacity(0.3),
        ),
        child: Row(
          children: [
            Icon(icon, color: AriseUI.primary, size: 32),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type,
                      style: TextStyle(
                          color: AriseUI.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2)),
                  Text(desc,
                      style:
                          const TextStyle(color: Colors.white38, fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
