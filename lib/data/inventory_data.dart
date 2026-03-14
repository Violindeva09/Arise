import '../models/item.dart';

class InventoryData {
  static final List<Item> allItems = [
    // HOME WORKOUT EQUIPMENT (12 items)
    Item(
        id: "home_1",
        name: "Yoga Mat",
        type: ItemType.accessory,
        rarity: ItemRarity.D,
        description: "Essential foundation for floor exercises. +5% Comfort.",
        statBoost: {"vitality": 1}),
    Item(
        id: "home_2",
        name: "Towel of Resilience",
        type: ItemType.accessory,
        rarity: ItemRarity.D,
        description: "Wipes away the sweat of effort. +5% Motivation.",
        statBoost: {"sense": 1}),
    Item(
        id: "home_3",
        name: "Water Bottle",
        type: ItemType.consumable,
        rarity: ItemRarity.D,
        description: "Hydration is key. +10% Stamina Recovery.",
        statBoost: {"vitality": 1}),
    Item(
        id: "home_4",
        name: "Jump Rope",
        type: ItemType.accessory,
        rarity: ItemRarity.C,
        description: "Cardio in its purest form. +15% Agility Training.",
        statBoost: {"agility": 2}),
    Item(
        id: "home_5",
        name: "Resistance Bands (Light)",
        type: ItemType.accessory,
        rarity: ItemRarity.C,
        description: "Elastic resistance for beginners. +10% Strength.",
        statBoost: {"strength": 2}),
    Item(
        id: "home_6",
        name: "Resistance Bands (Heavy)",
        type: ItemType.accessory,
        rarity: ItemRarity.B,
        description: "Advanced elastic training. +20% Strength.",
        statBoost: {"strength": 4}),
    Item(
        id: "home_7",
        name: "Adjustable Dumbbells (5-20kg)",
        type: ItemType.weapon,
        rarity: ItemRarity.B,
        description: "Versatile home strength training. +25% Power.",
        statBoost: {"strength": 5}),
    Item(
        id: "home_8",
        name: "Ab Roller",
        type: ItemType.accessory,
        rarity: ItemRarity.C,
        description: "Core destroyer. +15% Vitality.",
        statBoost: {"vitality": 3}),
    Item(
        id: "home_9",
        name: "Foam Roller",
        type: ItemType.accessory,
        rarity: ItemRarity.C,
        description: "Recovery tool. Reduces muscle soreness by 30%.",
        statBoost: {"vitality": 2}),
    Item(
        id: "home_10",
        name: "Kettlebell (16kg)",
        type: ItemType.weapon,
        rarity: ItemRarity.B,
        description: "Functional strength weapon. +20% Full-body Power.",
        statBoost: {"strength": 4, "vitality": 1}),
    Item(
        id: "home_11",
        name: "Push-up Bars",
        type: ItemType.accessory,
        rarity: ItemRarity.C,
        description: "Enhanced push-up depth. +15% Chest Gains.",
        statBoost: {"strength": 3}),
    Item(
        id: "home_12",
        name: "Exercise Ball",
        type: ItemType.accessory,
        rarity: ItemRarity.C,
        description: "Stability and core training. +10% Balance.",
        statBoost: {"agility": 2, "sense": 1}),

    // CALISTHENICS EQUIPMENT (12 items)
    Item(
        id: "cali_13",
        name: "Pull-up Bar",
        type: ItemType.accessory,
        rarity: ItemRarity.B,
        description: "The king of bodyweight exercises. +25% Back Strength.",
        statBoost: {"strength": 5}),
    Item(
        id: "cali_14",
        name: "Parallettes",
        type: ItemType.accessory,
        rarity: ItemRarity.B,
        description: "Advanced bodyweight control. +20% Core & Balance.",
        statBoost: {"agility": 3, "strength": 2}),
    Item(
        id: "cali_15",
        name: "Gymnastic Rings",
        type: ItemType.accessory,
        rarity: ItemRarity.A,
        description: "Ultimate instability training. +30% Full-body Control.",
        statBoost: {"agility": 5, "strength": 3}),
    Item(
        id: "cali_16",
        name: "Dip Station",
        type: ItemType.accessory,
        rarity: ItemRarity.B,
        description: "Chest and tricep builder. +25% Upper Body.",
        statBoost: {"strength": 5}),
    Item(
        id: "cali_17",
        name: "Resistance Bands (Loop)",
        type: ItemType.accessory,
        rarity: ItemRarity.C,
        description: "Assist or resist your movements. +15% Progression.",
        statBoost: {"strength": 2, "agility": 1}),
    Item(
        id: "cali_18",
        name: "Weighted Vest (10kg)",
        type: ItemType.armor,
        rarity: ItemRarity.B,
        description: "Increased gravity training. +20% Intensity.",
        statBoost: {"strength": 4, "vitality": 2}),
    Item(
        id: "cali_19",
        name: "Weighted Vest (20kg)",
        type: ItemType.armor,
        rarity: ItemRarity.A,
        description: "Heavy gravity training. +35% Intensity.",
        statBoost: {"strength": 7, "vitality": 4}),
    Item(
        id: "cali_20",
        name: "Ankle Weights",
        type: ItemType.armor,
        rarity: ItemRarity.C,
        description: "Leg exercise intensifier. +15% Lower Body.",
        statBoost: {"agility": 3, "strength": 1}),
    Item(
        id: "cali_21",
        name: "Wrist Wraps",
        type: ItemType.armor,
        rarity: ItemRarity.C,
        description: "Joint protection for handstands. +10% Safety.",
        statBoost: {"vitality": 1, "sense": 1}),
    Item(
        id: "cali_22",
        name: "Chalk Bag",
        type: ItemType.consumable,
        rarity: ItemRarity.D,
        description: "Better grip, better performance. +5% Grip.",
        statBoost: {"sense": 1}),
    Item(
        id: "cali_23",
        name: "Agility Ladder",
        type: ItemType.accessory,
        rarity: ItemRarity.C,
        description: "Footwork and coordination. +20% Agility.",
        statBoost: {"agility": 4}),
    Item(
        id: "cali_24",
        name: "Plyometric Box",
        type: ItemType.accessory,
        rarity: ItemRarity.B,
        description: "Explosive power training. +25% Jump Height.",
        statBoost: {"strength": 3, "agility": 2}),

    // GYM EQUIPMENT (12 items)
    Item(
        id: "gym_25",
        name: "Barbell (20kg)",
        type: ItemType.weapon,
        rarity: ItemRarity.B,
        description: "The foundation of strength. +25% Compound Lifts.",
        statBoost: {"strength": 6}),
    Item(
        id: "gym_26",
        name: "Weight Plates (100kg Set)",
        type: ItemType.weapon,
        rarity: ItemRarity.A,
        description: "Progressive overload arsenal. +30% Max Strength.",
        statBoost: {"strength": 10}),
    Item(
        id: "gym_27",
        name: "Lifting Belt",
        type: ItemType.armor,
        rarity: ItemRarity.B,
        description: "Core protection for heavy sets. +20% Safety.",
        statBoost: {"vitality": 5}),
    Item(
        id: "gym_28",
        name: "Lifting Straps",
        type: ItemType.accessory,
        rarity: ItemRarity.C,
        description: "Grip assistance for deadlifts. +15% Pull Strength.",
        statBoost: {"strength": 2, "sense": 1}),
    Item(
        id: "gym_29",
        name: "Knee Sleeves",
        type: ItemType.armor,
        rarity: ItemRarity.B,
        description: "Joint support for squats. +20% Leg Safety.",
        statBoost: {"vitality": 4}),
    Item(
        id: "gym_30",
        name: "Wrist Wraps (Heavy)",
        type: ItemType.armor,
        rarity: ItemRarity.C,
        description: "Wrist stability for pressing. +15% Press Power.",
        statBoost: {"strength": 2, "vitality": 2}),
    Item(
        id: "gym_31",
        name: "Gym Gloves",
        type: ItemType.armor,
        rarity: ItemRarity.D,
        description: "Hand protection. +5% Grip Comfort.",
        statBoost: {"sense": 1}),
    Item(
        id: "gym_32",
        name: "Dumbbell Set (5-50kg)",
        type: ItemType.weapon,
        rarity: ItemRarity.A,
        description: "Complete isolation arsenal. +30% Muscle Control.",
        statBoost: {"strength": 8, "agility": 2}),
    Item(
        id: "gym_33",
        name: "Cable Machine",
        type: ItemType.accessory,
        rarity: ItemRarity.S,
        description: "Constant tension mastery. +40% Muscle Activation.",
        statBoost: {"strength": 12, "agility": 5}),
    Item(
        id: "gym_34",
        name: "Squat Rack",
        type: ItemType.accessory,
        rarity: ItemRarity.A,
        description: "The throne of leg day. +35% Lower Body Gains.",
        statBoost: {"strength": 8, "vitality": 5}),
    Item(
        id: "gym_35",
        name: "Bench Press Station",
        type: ItemType.accessory,
        rarity: ItemRarity.A,
        description: "Chest development headquarters. +35% Upper Body.",
        statBoost: {"strength": 10, "vitality": 3}),
    Item(
        id: "gym_36",
        name: "Pre-Workout Supplement",
        type: ItemType.consumable,
        rarity: ItemRarity.B,
        description: "Energy and focus boost. +25% Workout Intensity.",
        statBoost: {"intelligence": 5, "sense": 5}),
  ];

  static List<Item> getItemsForType(String type) {
    final sourceItems = _itemsForType(type);
    return sourceItems.map(_cloneItem).toList();
  }

  static List<Item> _itemsForType(String type) {
    if (type == "NONE" || type.isEmpty) {
      return allItems; // Return all items as a fallback/default
    }

    // Map workout types to ID prefixes
    String prefix = type.toLowerCase();
    if (prefix == "calisthenics") {
      prefix = "cali";
    }

    return allItems.where((item) => item.id.startsWith(prefix)).toList();
  }

  static Item _cloneItem(Item item) {
    return Item(
      id: item.id,
      name: item.name,
      type: item.type,
      rarity: item.rarity,
      description: item.description,
      slot: item.slot,
      statBoost: item.statBoost,
      isEquipped: false,
    );
  }
}
