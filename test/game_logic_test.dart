import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_arise/models/item.dart';
import 'package:flutter_arise/models/player_stats.dart';
import 'package:flutter_arise/models/skill.dart';
import 'package:flutter_arise/services/game_logic.dart';
import 'package:flutter_arise/services/stat_resolver.dart';

void main() {
  group('XP scaling logic', () {
    test('uses quadratic growth', () {
      expect(GameLogic.getExpRequired(1), 100);
      expect(GameLogic.getExpRequired(10), 10000);
    });
  });

  group('multi-level overflow', () {
    test('levels up multiple times with overflow EXP carry', () {
      final stats = PlayerStats(
        level: 1,
        rank: 'E',
        exp: 550,
        strength: 5,
        agility: 5,
        vitality: 5,
        sense: 5,
        intelligence: 5,
        statPoints: 0,
      );

      final leveled = GameLogic.calculateLevelUp(stats);
      expect(leveled.level, 3);
      expect(leveled.exp, 50);
      expect(leveled.statPoints, 6);
    });

    test('caps with very high level without crashing', () {
      final stats = PlayerStats(
        level: 999,
        rank: 'S',
        exp: 1000000000,
        strength: 1,
        agility: 1,
        vitality: 1,
        sense: 1,
        intelligence: 1,
        statPoints: 0,
      );
      final leveled = GameLogic.calculateLevelUp(stats);
      expect(leveled.level, greaterThanOrEqualTo(1000));
    });
  });

  group('class change determination', () {
    test('returns NONE under class level threshold', () {
      final stats = PlayerStats(
        level: 39,
        rank: 'E',
        exp: 0,
        strength: 55,
        agility: 55,
        vitality: 55,
        sense: 55,
        intelligence: 55,
        statPoints: 0,
      );
      expect(GameLogic.determineEligibleClass(stats), 'NONE');
    });

    test('returns best matching class at threshold', () {
      final stats = PlayerStats(
        level: 40,
        rank: 'B',
        exp: 0,
        strength: 35,
        agility: 60,
        vitality: 10,
        sense: 40,
        intelligence: 10,
        statPoints: 0,
      );
      expect(GameLogic.determineEligibleClass(stats), 'ASSASSIN');
    });
  });

  group('skill unlock validation', () {
    test('enforces level and stat requirements', () {
      final skill = Skill(
        id: 's1',
        name: 'Shadow Step',
        type: SkillType.ACTIVE,
        description: '',
        icon: 'x',
        levelReq: 10,
        statReq: const StatRequirement(stat: 'agility', value: 20),
      );

      final locked = PlayerStats(
        level: 9,
        rank: 'E',
        exp: 0,
        strength: 5,
        agility: 100,
        vitality: 5,
        sense: 5,
        intelligence: 5,
        statPoints: 0,
      );
      final unlocked = locked.copyWith(level: 10);

      expect(GameLogic.isSkillUnlocked(locked, skill), isFalse);
      expect(GameLogic.isSkillUnlocked(unlocked, skill), isTrue);
    });
  });

  group('equipment stat aggregation', () {
    test('aggregates equipped bonuses and recalculates hp/mp', () {
      final base = PlayerStats(
        level: 1,
        rank: 'E',
        exp: 0,
        strength: 5,
        agility: 5,
        vitality: 5,
        sense: 5,
        intelligence: 5,
        statPoints: 0,
      );
      final equipped = [
        Item(
          id: 'w1',
          name: 'Sword',
          type: ItemType.weapon,
          rarity: ItemRarity.C,
          description: '',
          statBoost: {'strength': 3, 'vitality': 2},
        ),
        Item(
          id: 'a1',
          name: 'Amulet',
          type: ItemType.accessory,
          rarity: ItemRarity.C,
          description: '',
          statBoost: {'intelligence': 4, 'sense': 1},
        )
      ];

      final resolved = StatResolver.resolve(baseStats: base, equippedItems: equipped);
      expect(resolved.strength, 8);
      expect(resolved.vitality, 7);
      expect(resolved.intelligence, 9);
      expect(resolved.maxHp, 170);
      expect(resolved.maxMp, 65);
    });
  });
}
