import '../models/quest.dart';
import '../models/stat_boost.dart';

class QuestData {
  static final List<Quest> dailyQuests = [
    Quest(
      id: "preparations_strength",
      title: "PREPARATIONS FOR STRENGTH",
      description:
          "Push yourself beyond the limits to prepare for the path ahead.",
      reward: Reward(
        exp: 100,
        statBoost: StatBoost(strength: 2, vitality: 1),
      ),
    ),
    Quest(
      id: "agility_training",
      title: "AGILITY TRAINING",
      description:
          "Enhance your reflexes through intense cardio and calisthenics.",
      reward: Reward(
        exp: 100,
        statBoost: StatBoost(strength: 1, agility: 1, sense: 1),
      ),
    ),
    Quest(
      id: "power_building",
      title: "POWER BUILDING",
      description: "Focus on heavy compound movements to build absolute mass.",
      reward: Reward(
        exp: 150,
        statBoost: StatBoost(strength: 3, vitality: 2),
      ),
    ),
  ];

  static Quest? getQuestById(String id) {
    return dailyQuests.firstWhere((q) => q.id == id,
        orElse: () => dailyQuests.first);
  }
}
