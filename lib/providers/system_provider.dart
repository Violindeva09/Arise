import 'dart:async';
import 'package:flutter/material.dart';
import '../models/player_stats.dart';
import '../models/item.dart';
import '../models/skill.dart';
import '../models/quest.dart';
import '../models/equipment_slot.dart';
import '../data/penalty_data.dart';
import '../data/inventory_data.dart';
import '../data/skill_data.dart';
import '../services/equipment_service.dart';
import '../services/game_logic.dart';
import '../services/persistence_service.dart';
import '../services/stat_resolver.dart';

class SystemProvider with ChangeNotifier {
  // State
  PlayerStats _stats = PlayerStats.defaultStats();
  List<Item> _inventory = [];
  final Map<ItemType, Item> _equippedItems = {};
  List<Map<String, dynamic>> _questHistory = [];
  bool _isPenaltyActive = false;
  String? _currentUser;

  // Getters
  PlayerStats get stats => _stats;
  String get playerName => _currentUser ?? "Hunter";
  List<Item> get inventory => _inventory;
  Map<ItemType, Item> get equippedItems => _equippedItems;
  List<Map<String, dynamic>> get questHistory => _questHistory;
  bool get isPenaltyActive => _isPenaltyActive;

  Item? get equippedWeapon => _equippedFor(EquipmentSlot.weapon);
  Item? get equippedArmor => _equippedFor(EquipmentSlot.armor);
  Item? get equippedAccessory => _equippedFor(EquipmentSlot.accessory);

  Penalty? get currentPenalty =>
      _isPenaltyActive ? PenaltyData.getCurrentPenalty() : null;

  // Base vs modified stat separation via resolver
  ResolvedPlayerStats get resolvedStats => StatResolver.resolve(
      baseStats: _stats, equippedItems: _equippedItems.values);

  int get maxHp => resolvedStats.maxHp;
  int get maxMp => resolvedStats.maxMp;
  double get expProgress => GameLogic.getExpProgress(_stats.exp, _stats.level);

  Future<void> init(String name, String email) async {
    if (name.isEmpty) return;
    _currentUser = name;
    final savedState = await PersistenceService.loadPlayerState(name);
    if (savedState != null) {
      _stats = savedState.stats;
      _questHistory = savedState.questHistory;
      _isPenaltyActive = savedState.isPenaltyActive;
      _inventory = InventoryData.getItemsForType(_stats.workoutType);
      _updateInventoryFromIds(savedState.equippedItemIds);

      // Offline recovery calculation (rough estimate: 1 point per 10 mins offline)
      // Implementation skipped for brevity but would go here using timestamp
    } else {
      _updateInventory();
    }
    _startRegenTimer();
    notifyListeners();
  }

  void _updateInventoryFromIds(List<String> equippedItemIds) {
    final availableItems = _inventory;
    for (final id in equippedItemIds) {
      final matches = availableItems.where((item) => item.id == id);
      if (matches.isEmpty) continue;
      final item = matches.first;
      if (_isEquippable(item.type) && _equippedItems[item.type] == null) {
        _equippedItems[item.type] = item;
      }
    }
    _syncInventoryEquipFlags();
  }

  void _updateInventory() {
    _inventory = InventoryData.getItemsForType(_stats.workoutType);
    _syncInventoryEquipFlags();
  }

  void setWorkoutType(String type) {
    _stats = _stats.copyWith(workoutType: type);
    _updateInventory();
    _syncEquippedWithInventory();
    _saveAndNotify();
  }

  void _syncEquippedWithInventory() {
    final inventoryIds = _inventory.map((item) => item.id).toSet();
    _equippedItems.removeWhere((_, item) => !inventoryIds.contains(item.id));
    _syncInventoryEquipFlags();
  }

  void _syncInventoryEquipFlags() {
    for (final item in _inventory) {
      item.isEquipped = false;
    }

    final equippedIds = _equippedItems.values.map((item) => item.id).toSet();
    for (final item in _inventory) {
      if (equippedIds.contains(item.id)) {
        item.isEquipped = true;
      }
    }
  }

  bool equipOrUnequip(Item item) {
    final changed = EquipmentService.toggleEquip(item, _inventory);
    if (changed) {
      _equippedItems
        ..clear()
        ..addEntries(
          _inventory
              .where((candidate) =>
                  candidate.isEquipped && _isEquippable(candidate.type))
              .map((candidate) => MapEntry(candidate.type, candidate)),
        );
      _saveAndNotify();
    }
    return changed;
  }

  bool equipItem(Item item) {
    if (!_isEquippable(item.type)) return false;
    _equippedItems[item.type] = item;
    _syncInventoryEquipFlags();
    _saveAndNotify();
    return true;
  }

  bool unequipItem(ItemType type) {
    final removed = _equippedItems.remove(type);
    if (removed == null) return false;
    _syncInventoryEquipFlags();
    _saveAndNotify();
    return true;
  }

  void awakenPlayer() {
    _stats = _stats.copyWith(isAwakened: true);
    _saveAndNotify();
  }

  void setHunterClass(String newClass) {
    _stats = _stats.copyWith(hunterClass: newClass);
    _saveAndNotify();
  }

  void addRewards(Reward reward, {String? questName}) {
    final oldStats = _stats;
    _stats = GameLogic.applyQuestRewards(_stats, reward.exp, reward.statBoost);
    // GameLogic.applyQuestRewards now auto-triggers levelUp check

    if (questName != null) {
      _addToHistory(
        questName: questName,
        status: "COMPLETED",
        xp: reward.exp,
      );
    }

    _checkClassPromotion();
    _checkSkillUnlocks(oldStats);
    _saveAndNotify();
  }

  bool isEquipped(Item item) => _equippedItems[item.type]?.id == item.id;

  Item? _equippedFor(EquipmentSlot slot) {
    switch (slot) {
      case EquipmentSlot.weapon:
        return _equippedItems[ItemType.weapon];
      case EquipmentSlot.armor:
        return _equippedItems[ItemType.armor];
      case EquipmentSlot.accessory:
        return _equippedItems[ItemType.accessory];
    }
  }

  bool _isEquippable(ItemType type) {
    return type == ItemType.weapon ||
        type == ItemType.armor ||
        type == ItemType.accessory;
  }

  void _checkClassPromotion() {
    if (_stats.level >= GameLogic.CLASS_CHANGE_LEVEL &&
        _stats.hunterClass == "NONE") {
      String eligibleClass = GameLogic.determineEligibleClass(_stats);
      setHunterClass(eligibleClass);
    }
  }

  void _checkSkillUnlocks(PlayerStats oldStats) {
    final allSkills = [...SkillData.activeSkills, ...SkillData.passiveSkills];

    for (final skill in allSkills) {
      final wasUnlocked = GameLogic.isSkillUnlocked(oldStats, skill);
      final isUnlockedNow = GameLogic.isSkillUnlocked(_stats, skill);
      if (!wasUnlocked && isUnlockedNow) {
        _addToHistory(
          questName: "SKILL UNLOCKED: ${skill.name}",
          status: "SYSTEM",
          xp: "UNLOCKED",
        );
      }
    }
  }

  void activatePenalty() {
    _isPenaltyActive = true;
    notifyListeners();
  }

  void resolvePenalty() {
    _isPenaltyActive = false;
    _stats = GameLogic.calculateLevelUp(_stats.copyWith(
      exp: GameLogic.getExpRequired(_stats.level),
    )).copyWith(exp: 0);

    _addToHistory(
      questName: "PENALTY ESCAPED",
      status: "COMPLETED",
      xp: "SECRET LEVEL UP",
    );

    _saveAndNotify();
  }

  void _saveAndNotify() {
    PersistenceService.savePlayerState(
      _currentUser!,
      stats: _stats,
      equippedItemIds: _equippedItems.values.map((e) => e.id).toList(),
      questHistory: _questHistory,
      isPenaltyActive: _isPenaltyActive,
    );
    notifyListeners();
  }

  void _addToHistory(
      {required String questName,
      required String status,
      required dynamic xp}) {
    final entry = {
      'date': DateTime.now().toString().split(' ')[0],
      'quest': questName,
      'status': status,
      'xp': xp is int ? (xp > 0 ? "+$xp" : xp.toString()) : xp.toString(),
    };
    _questHistory.insert(0, entry);
    if (_questHistory.length > 50) _questHistory.removeLast();
  }

  void assignStatPoint(String stat) {
    if (_stats.statPoints > 0) {
      _stats = _stats.copyWith(
        strength: stat == 'strength' ? _stats.strength + 1 : _stats.strength,
        agility: stat == 'agility' ? _stats.agility + 1 : _stats.agility,
        vitality: stat == 'vitality' ? _stats.vitality + 1 : _stats.vitality,
        sense: stat == 'sense' ? _stats.sense + 1 : _stats.sense,
        intelligence: stat == 'intelligence'
            ? _stats.intelligence + 1
            : _stats.intelligence,
        statPoints: _stats.statPoints - 1,
      );
      _saveAndNotify();
    }
  }

  Timer? _regenTimer;

  bool isSkillUnlocked(Skill skill) {
    return GameLogic.isSkillUnlocked(_stats, skill);
  }

  void _startRegenTimer() {
    _regenTimer?.cancel();
    _regenTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      bool changed = false;
      if (_stats.currentHp < maxHp) {
        _stats =
            _stats.copyWith(currentHp: (_stats.currentHp + 1).clamp(0, maxHp));
        changed = true;
      }
      if (_stats.currentMp < maxMp) {
        _stats =
            _stats.copyWith(currentMp: (_stats.currentMp + 1).clamp(0, maxMp));
        changed = true;
      }
      if (changed) notifyListeners();
    });
  }

  @override
  void dispose() {
    _regenTimer?.cancel();
    super.dispose();
  }
}
