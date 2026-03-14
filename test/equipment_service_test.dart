import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_arise/models/equipment_slot.dart';
import 'package:flutter_arise/models/item.dart';
import 'package:flutter_arise/models/player_stats.dart';
import 'package:flutter_arise/models/stat_boost.dart';
import 'package:flutter_arise/services/equipment_service.dart';

void main() {
  test('EquipmentService aggregates boosts correctly', () {
    final inventory = [
      Item(
        id: '1',
        name: 'Sword',
        type: ItemType.weapon,
        rarity: ItemRarity.C,
        description: '',
        slot: EquipmentSlot.weapon,
        statBoost: const StatBoost(strength: 5),
        isEquipped: true,
      ),
      Item(
        id: '2',
        name: 'Armor',
        type: ItemType.armor,
        rarity: ItemRarity.C,
        description: '',
        slot: EquipmentSlot.armor,
        statBoost: const StatBoost(vitality: 3),
        isEquipped: true,
      ),
      Item(
        id: '3',
        name: 'Potion',
        type: ItemType.consumable,
        rarity: ItemRarity.D,
        description: '',
        slot: null,
        statBoost: const StatBoost(strength: 99),
        isEquipped: true,
      ),
    ];

    final total = EquipmentService.calculateTotalBoost(inventory);

    expect(total.strength, 5);
    expect(total.vitality, 3);
    expect(total.agility, 0);
  });

  test('applyAllBonuses returns computed stats from base + equipment + temp', () {
    final base = PlayerStats(
      level: 1,
      rank: 'E',
      exp: 0,
      strength: 10,
      agility: 10,
      vitality: 10,
      sense: 10,
      intelligence: 10,
      statPoints: 0,
    );

    final inventory = [
      Item(
        id: '1',
        name: 'Sword',
        type: ItemType.weapon,
        rarity: ItemRarity.C,
        description: '',
        statBoost: const StatBoost(strength: 2),
        isEquipped: true,
      )
    ];

    final computed = EquipmentService.applyAllBonuses(
      base,
      inventory,
      temporaryBuffs: const StatBoost(agility: 1),
    );

    expect(computed.strength, 12);
    expect(computed.agility, 11);
    expect(base.strength, 10);
  });
}
