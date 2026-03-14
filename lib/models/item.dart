import 'equipment_slot.dart';
import 'stat_boost.dart';

enum ItemRarity { D, C, B, A, S }

enum ItemType { weapon, armor, accessory, consumable, material }

class Item {
  final String id;
  final String name;
  final ItemType type;
  final ItemRarity rarity;
  final String description;
  final EquipmentSlot? slot; // null means non-equippable
  final StatBoost statBoost;
  bool isEquipped;

  Item({
    required this.id,
    required this.name,
    required this.type,
    required this.rarity,
    required this.description,
    EquipmentSlot? slot,
    dynamic statBoost = StatBoost.zero,
    this.isEquipped = false,
  })  : slot = slot ?? _slotFromType(type),
        statBoost = _normalizeStatBoost(statBoost);

  factory Item.fromJson(Map<String, dynamic> json) {
    final parsedType = _safeItemType(json['type']);
    return Item(
      id: json['id'],
      name: json['name'],
      type: _safeItemType(json['type']),
      rarity: _safeItemRarity(json['rarity']),
      description: json['description'] ?? json['desc'] ?? "",
      slot: json['slot'] != null
          ? _safeSlot(json['slot'])
          : _slotFromType(parsedType),
      statBoost: StatBoost.fromJson(
        (json['statBoost'] as Map<String, dynamic>?) ?? const {},
      ),
      isEquipped: json['isEquipped'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'rarity': rarity.name,
      'description': description,
      'slot': slot?.name,
      'statBoost': statBoost.toJson(),
      'isEquipped': isEquipped,
    };
  }
}

ItemType _safeItemType(dynamic raw) {
  final value = raw?.toString() ?? '';
  for (final type in ItemType.values) {
    if (type.name == value) return type;
  }
  return ItemType.material;
}

ItemRarity _safeItemRarity(dynamic raw) {
  final value = raw?.toString() ?? '';
  for (final rarity in ItemRarity.values) {
    if (rarity.name == value) return rarity;
  }
  return ItemRarity.D;
}

EquipmentSlot? _slotFromType(ItemType type) {
  switch (type) {
    case ItemType.weapon:
      return EquipmentSlot.weapon;
    case ItemType.armor:
      return EquipmentSlot.armor;
    case ItemType.accessory:
      return EquipmentSlot.accessory;
    case ItemType.consumable:
    case ItemType.material:
      return null;
  }
}

EquipmentSlot? _safeSlot(dynamic raw) {
  final value = raw?.toString() ?? '';
  for (final slot in EquipmentSlot.values) {
    if (slot.name == value) return slot;
  }
  return null;
}

StatBoost _normalizeStatBoost(dynamic raw) {
  if (raw == null) return StatBoost.zero;
  if (raw is StatBoost) return raw;
  if (raw is Map<String, dynamic>) return StatBoost.fromJson(raw);
  if (raw is Map) {
    return StatBoost.fromJson(raw.map((k, v) => MapEntry(k.toString(), v)));
  }
  return StatBoost.zero;
}
