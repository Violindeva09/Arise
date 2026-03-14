import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/system_provider.dart';
import '../config/ui_config.dart';
import '../data/quest_data.dart';
import '../models/quest.dart';
import '../services/system_audio_service.dart';

class QuestScreen extends StatefulWidget {
  const QuestScreen({super.key});

  @override
  _QuestScreenState createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;

  // Task definitions moved to QuestScreen for UI logic,
  // but rewards remain in QuestData
  final Map<String, List<Map<String, dynamic>>> _routines = {
    "HOME": [
      {"id": "pushups", "title": "PUSH-UPS", "goal": 100, "sets": 4},
      {"id": "situps", "title": "SIT-UPS", "goal": 100, "sets": 4},
      {"id": "squats", "title": "SQUATS", "goal": 100, "sets": 4},
      {"id": "plank", "title": "PLANK", "goal": 300, "sets": 3, "unit": "s"},
    ],
    "CALISTHENICS": [
      {"id": "pullups", "title": "PULL-UPS", "goal": 50, "sets": 5},
      {"id": "dips", "title": "DIPS", "goal": 80, "sets": 4},
      {"id": "muscleups", "title": "MUSCLE-UPS", "goal": 10, "sets": 2},
      {
        "id": "handstand",
        "title": "HANDSTAND HOLD",
        "goal": 180,
        "sets": 3,
        "unit": "s"
      },
    ],
    "GYM": [
      {"id": "bench", "title": "BENCH PRESS", "goal": 50, "sets": 5},
      {"id": "deadlift", "title": "DEADLIFT", "goal": 30, "sets": 3},
      {"id": "squats", "title": "BARBELL SQUATS", "goal": 50, "sets": 5},
      {"id": "press", "title": "OVERHEAD PRESS", "goal": 40, "sets": 4},
    ],
  };

  late Map<String, List<bool>> _taskCompletion;

  @override
  void initState() {
    super.initState();
    _updateTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _updateTimer();
        });
      }
    });

    // Initialize task completion states
    _taskCompletion = {};
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final system = Provider.of<SystemProvider>(context);
    final workoutType = system.stats.workoutType.toUpperCase();
    final quests = _routines[workoutType] ?? _routines["HOME"]!;

    // Initialize completion map if empty
    if (_taskCompletion.isEmpty) {
      for (final quest in quests) {
        _taskCompletion[quest['id']] = List.generate(
          quest['sets'] as int,
          (_) => false,
        );
      }
    }
  }

  void _updateTimer() {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    _timeLeft = tomorrow.difference(now);

    // Auto-trigger penalty at midnight if not complete
    if (_timeLeft.inSeconds <= 0) {
      final system = Provider.of<SystemProvider>(context, listen: false);
      if (!_isEveryQuestComplete()) {
        SystemAudioService().playAlert();
        system.activatePenalty();
      }
    }
  }

  bool _isEveryQuestComplete() {
    if (_taskCompletion.isEmpty) return false;
    return _taskCompletion.values.every((sets) => sets.every((s) => s));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(d.inHours);
    String minutes = twoDigits(d.inMinutes.remainder(60));
    String seconds = twoDigits(d.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final system = Provider.of<SystemProvider>(context);
    final workoutType = system.stats.workoutType.toUpperCase();
    final quests = _routines[workoutType] ?? _routines["HOME"]!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuestStats(workoutType),
              const SizedBox(height: 12),
              _buildAnnouncement(),
              const SizedBox(height: 32),
              Expanded(
                child: ListView.builder(
                  itemCount: quests.length,
                  itemBuilder: (context, index) {
                    return _buildQuestCard(
                        context, system, quests[index], workoutType);
                  },
                ),
              ),
              _buildTimerSection(system),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestStats(String workoutType) {
    return Row(
      children: [
        AriseUI.ornament(),
        const SizedBox(width: 12),
        Text("04 QUESTS: $workoutType", style: AriseUI.heading),
      ],
    );
  }

  Widget _buildAnnouncement() {
    return Text(
      "DAILY QUESTS\nFailure results in immediate penalty.",
      textAlign: TextAlign.center,
      style: TextStyle(
          color: AriseUI.primary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2),
    );
  }

  Widget _buildQuestCard(BuildContext context, SystemProvider system,
      Map<String, dynamic> quest, String path) {
    final List<bool> completion = _taskCompletion[quest['id']] ?? [];
    final bool isComplete = completion.isNotEmpty && completion.every((c) => c);
    final String goalText = isComplete
        ? "${quest['goal']}/${quest['goal']}${quest['unit'] ?? ''}"
        : "0/${quest['goal']}${quest['unit'] ?? ''}";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: AriseUI.glassHUD().copyWith(
        border: Border.all(
            color: isComplete
                ? Colors.greenAccent
                : AriseUI.primary.withOpacity(0.4),
            width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(quest['title'],
                  style: AriseUI.subHeading.copyWith(
                      color: isComplete
                          ? Colors.white
                          : Colors.white.withOpacity(0.9))),
              Text(goalText,
                  style: TextStyle(
                      color: isComplete
                          ? Colors.greenAccent
                          : Colors.white.withOpacity(0.7),
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Transform.scale(
              scale: 1.5,
              child: Checkbox(
                value: isComplete,
                activeColor: Colors.greenAccent,
                checkColor: Colors.black,
                side: BorderSide(
                    color: isComplete
                        ? Colors.greenAccent.withOpacity(0.8)
                        : AriseUI.primary.withOpacity(0.8),
                    width: 2),
                onChanged: (val) {
                  SystemAudioService().playClick();
                  setState(() {
                    for (int i = 0; i < completion.length; i++) {
                      completion[i] = val ?? false;
                    }
                    if (_isEveryQuestComplete()) {
                      _grantPathRewards(system, path);
                      _showCompletionSnackBar(
                          context, "DAILY TRAINING COMPLETE");
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _grantPathRewards(SystemProvider system, String path) {
    // Resolve quest from QuestData
    String questId =
        path == "CALISTHENICS" ? "agility_training" : "preparations_strength";
    Quest? quest = QuestData.getQuestById(questId);

    if (quest != null) {
      SystemAudioService().playLevelUp();
      system.addRewards(quest.reward, questName: quest.title);
    }
  }

  void _showCompletionSnackBar(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AriseUI.primary,
        duration: const Duration(seconds: 2),
        content: Text(title,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTimerSection(SystemProvider system) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 16),
      decoration: AriseUI.glassHUD().copyWith(
        border: Border.all(color: AriseUI.danger.withOpacity(0.3)),
        color: AriseUI.danger.withOpacity(0.05),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer_outlined, color: AriseUI.danger, size: 20),
          const SizedBox(width: 12),
          Text("TIME LIMIT: ${_formatDuration(_timeLeft)}",
              style: TextStyle(
                  color: AriseUI.danger,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'monospace',
                  shadows: [
                    Shadow(
                        color: AriseUI.danger.withOpacity(0.5), blurRadius: 10)
                  ])),
          if (!_isEveryQuestComplete()) ...[
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                SystemAudioService().playAlert();
                system.activatePenalty();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AriseUI.danger.withOpacity(0.1),
                side: BorderSide(color: AriseUI.danger, width: 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: const Size(0, 0),
              ),
              child: Text("OUT",
                  style: TextStyle(
                      color: AriseUI.danger,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
    );
  }
}
