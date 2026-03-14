import '../models/item.dart';
import '../models/player_stats.dart';
import '../models/stat_boost.dart';

class EquipmentService {
  /// Reserved for future temporary buffs/debuffs.
  static PlayerStats applyAllBonuses(
    PlayerStats baseStats,
    List<Item> inventory, {
    StatBoost temporaryBuffs = StatBoost.zero,
  }) {
    final equipmentBoost = calculateTotalBoost(inventory);
    final totalBoost = equipmentBoost + temporaryBuffs;

    return baseStats.copyWith(
      strength: baseStats.strength + totalBoost.strength,
      agility: baseStats.agility + totalBoost.agility,
      vitality: baseStats.vitality + totalBoost.vitality,
      sense: baseStats.sense + totalBoost.sense,
      intelligence: baseStats.intelligence + totalBoost.intelligence,
    );
  }

  /// Returns total stat boost from equipped items.
  static StatBoost calculateTotalBoost(List<Item> inventory) {
    return inventory
        .where((item) => item.isEquipped && item.slot != null)
        .fold(StatBoost.zero, (total, item) => total + item.statBoost);
  }

  static bool toggleEquip(Item item, List<Item> inventory) {
    if (item.slot == null) return false;

    final shouldEquip = !item.isEquipped;

    for (final candidate in inventory) {
      if (candidate.slot == item.slot) {
        candidate.isEquipped = false;
      }
    }

    item.isEquipped = shouldEquip;
    return true;
  }
}
