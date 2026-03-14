import '../models/item.dart';
import '../models/player_stats.dart';
import '../models/stat_boost.dart';

class ResolvedPlayerStats {
  final PlayerStats base;
  final int strength;
  final int agility;
  final int vitality;
  final int sense;
  final int intelligence;
  final int maxHp;
  final int maxMp;

  const ResolvedPlayerStats({
    required this.base,
    required this.strength,
    required this.agility,
    required this.vitality,
    required this.sense,
    required this.intelligence,
    required this.maxHp,
    required this.maxMp,
  });
}

class StatResolver {
  static StatBoost aggregateEquipmentBonuses(Iterable<Item> items) {
    return items.fold(StatBoost.zero, (prev, item) => prev + item.statBoost);
  }

  static ResolvedPlayerStats resolve({
    required PlayerStats baseStats,
    required Iterable<Item> equippedItems,
    int temporaryStrengthBuff = 0,
    int temporaryAgilityBuff = 0,
    int temporaryVitalityBuff = 0,
    int temporarySenseBuff = 0,
    int temporaryIntelligenceBuff = 0,
  }) {
    final equipmentBoost = aggregateEquipmentBonuses(equippedItems);

    final strength =
        baseStats.strength + equipmentBoost.strength + temporaryStrengthBuff;
    final agility =
        baseStats.agility + equipmentBoost.agility + temporaryAgilityBuff;
    final vitality =
        baseStats.vitality + equipmentBoost.vitality + temporaryVitalityBuff;
    final sense = baseStats.sense + equipmentBoost.sense + temporarySenseBuff;
    final intelligence = baseStats.intelligence +
        equipmentBoost.intelligence +
        temporaryIntelligenceBuff;

    final maxHp = 100 + (vitality * 10);
    final maxMp = 10 + (intelligence * 5) + (sense * 2);

    return ResolvedPlayerStats(
      base: baseStats,
      strength: strength,
      agility: agility,
      vitality: vitality,
      sense: sense,
      intelligence: intelligence,
      maxHp: maxHp,
      maxMp: maxMp,
    );
  }
}
