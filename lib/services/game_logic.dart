import '../models/player_stats.dart';
import '../models/skill.dart';
import '../models/stat_boost.dart';

class GameLogic {
  static const int CLASS_CHANGE_LEVEL = 40;
  static const int BASE_XP = 100;
  static const int BASE_HP = 100;
  static const int BASE_MP = 10;
  static const double HP_SCALING = 10.0;
  static const double MP_SCALING = 5.0;
  static const double INTEL_MP_SCALING = 5.0;
  static const double SENSE_MP_SCALING = 2.0;

  static const Map<String, Map<String, int>> CLASS_THRESHOLDS = {
    'ASSASSIN': {'agility': 50, 'sense': 30},
    'TANK': {'vitality': 50, 'strength': 30},
    'ARCHER': {'sense': 50, 'agility': 30},
    'MAGE': {'intelligence': 50, 'sense': 30},
    'FIGHTER': {'strength': 50, 'vitality': 30},
  };

  /// Formula: XP_required = baseXP * level^2
  static int getExpRequired(int level) => BASE_XP * (level * level);

  /// Formula: MaxHP = baseHP + vitality * scalingFactor
  static int getMaxHp(int vitality) =>
      BASE_HP + (vitality * HP_SCALING).toInt();

  /// Formula: MaxMP = baseMP + intelligence * scalingFactor + sense * scalingFactor
  static int getMaxMp(int intelligence, int sense) =>
      BASE_MP +
      (intelligence * INTEL_MP_SCALING).toInt() +
      (sense * SENSE_MP_SCALING).toInt();

  static double getExpProgress(int currentExp, int level) {
    int required = getExpRequired(level);
    if (required == 0) return 0.0;
    return (currentExp / required).clamp(0.0, 1.0);
  }

  static PlayerStats calculateLevelUp(PlayerStats stats) {
    int currentExp = stats.exp;
    int currentLevel = stats.level;
    int strength = stats.strength;
    int agility = stats.agility;
    int vitality = stats.vitality;
    int sense = stats.sense;
    int intelligence = stats.intelligence;
    int statPoints = stats.statPoints;

    // Guard against negative XP
    if (currentExp < 0) currentExp = 0;

    // Handle multi-level jumps
    while (currentExp >= getExpRequired(currentLevel)) {
      currentExp -= getExpRequired(currentLevel);
      currentLevel += 1;

      // Every level-up increases all primary stats by 1
      strength += 1;
      agility += 1;
      vitality += 1;
      sense += 1;
      intelligence += 1;

      // Bonus stat points for manual assignment
      statPoints += 3;

      // Prevent overflow (e.g., max level 999) - optional safety
      if (currentLevel >= 1000) break;
    }

    return stats.copyWith(
      level: currentLevel,
      rank: calculateRank(currentLevel),
      exp: currentExp,
      strength: strength,
      agility: agility,
      vitality: vitality,
      sense: sense,
      intelligence: intelligence,
      statPoints: statPoints,
    );
  }

  static String calculateRank(int level) {
    if (level < 20) return "E";
    if (level < 40) return "D";
    if (level < 60) return "C";
    if (level < 80) return "B";
    if (level < 100) return "A";
    return "S";
  }

  static PlayerStats applyQuestRewards(
      PlayerStats stats, int expGain, StatBoost statBoost) {
    var newStats = stats.copyWith(
      exp: stats.exp + expGain,
      strength: stats.strength + statBoost.strength,
      agility: stats.agility + statBoost.agility,
      vitality: stats.vitality + statBoost.vitality,
      sense: stats.sense + statBoost.sense,
      intelligence: stats.intelligence + statBoost.intelligence,
    );

    // Auto-trigger level-up check
    return calculateLevelUp(newStats);
  }

  static String determineEligibleClass(PlayerStats stats) {
    if (stats.level < CLASS_CHANGE_LEVEL) return "NONE";

    String bestClass = "FIGHTER"; // Default
    int highestMatch = 0;

    CLASS_THRESHOLDS.forEach((className, thresholds) {
      int metCount = 0;
      thresholds.forEach((stat, val) {
        int currentVal = 0;
        switch (stat) {
          case 'strength':
            currentVal = stats.strength;
            break;
          case 'agility':
            currentVal = stats.agility;
            break;
          case 'vitality':
            currentVal = stats.vitality;
            break;
          case 'sense':
            currentVal = stats.sense;
            break;
          case 'intelligence':
            currentVal = stats.intelligence;
            break;
        }
        if (currentVal >= val) metCount++;
      });
      if (metCount > highestMatch) {
        highestMatch = metCount;
        bestClass = className;
      }
    });

    return bestClass;
  }

  static bool isSkillUnlocked(PlayerStats stats, Skill skill) {
    bool levelMet = stats.level >= skill.levelReq;
    if (skill.statReq == null) return levelMet;

    int currentVal = 0;
    switch (skill.statReq!.stat.toLowerCase()) {
      case 'strength':
        currentVal = stats.strength;
        break;
      case 'agility':
        currentVal = stats.agility;
        break;
      case 'vitality':
        currentVal = stats.vitality;
        break;
      case 'sense':
        currentVal = stats.sense;
        break;
      case 'intelligence':
        currentVal = stats.intelligence;
        break;
    }
    return levelMet && currentVal >= skill.statReq!.value;
  }
}
