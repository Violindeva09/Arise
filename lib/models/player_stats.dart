class PlayerStats {
  final int level;
  final String rank;
  final int exp;
  final int strength;
  final int agility;
  final int vitality;
  final int sense;
  final int intelligence;
  final int statPoints;
  final String hunterClass;
  final bool isAwakened;
  final String workoutType;
  final int currentHp;
  final int currentMp;

  const PlayerStats({
    required this.level,
    required this.rank,
    required this.exp,
    required this.strength,
    required this.agility,
    required this.vitality,
    required this.sense,
    required this.intelligence,
    required this.statPoints,
    this.hunterClass = "NONE",
    this.isAwakened = false,
    this.workoutType = "NONE",
    this.currentHp = 100,
    this.currentMp = 50,
  });

  factory PlayerStats.defaultStats() => const PlayerStats(
        level: 1,
        rank: "E",
        exp: 0,
        strength: 5,
        agility: 5,
        vitality: 5,
        sense: 5,
        intelligence: 5,
        statPoints: 0,
      );

  Map<String, dynamic> toJson() => {
        'level': level,
        'rank': rank,
        'exp': exp,
        'strength': strength,
        'agility': agility,
        'vitality': vitality,
        'sense': sense,
        'intelligence': intelligence,
        'statPoints': statPoints,
        'hunterClass': hunterClass,
        'isAwakened': isAwakened,
        'workoutType': workoutType,
        'currentHp': currentHp,
        'currentMp': currentMp,
      };

  factory PlayerStats.fromJson(Map<String, dynamic> json) => PlayerStats(
        level: json['level'] ?? 1,
        rank: json['rank'] ?? "E",
        exp: json['exp'] ?? 0,
        strength: json['strength'] ?? 5,
        agility: json['agility'] ?? 5,
        vitality: json['vitality'] ?? 5,
        sense: json['sense'] ?? 5,
        intelligence: json['intelligence'] ?? 5,
        statPoints: json['statPoints'] ?? 0,
        hunterClass: json['hunterClass'] ?? "NONE",
        isAwakened: json['isAwakened'] ?? false,
        workoutType:
            json['workoutType'] ?? json['preferredWorkoutType'] ?? "NONE",
        currentHp: json['currentHp'] ?? 100,
        currentMp: json['currentMp'] ?? 50,
      );

  PlayerStats copyWith({
    int? level,
    String? rank,
    int? exp,
    int? strength,
    int? agility,
    int? vitality,
    int? sense,
    int? intelligence,
    int? statPoints,
    String? hunterClass,
    bool? isAwakened,
    String? workoutType,
    int? currentHp,
    int? currentMp,
  }) {
    return PlayerStats(
      level: level ?? this.level,
      rank: rank ?? this.rank,
      exp: exp ?? this.exp,
      strength: strength ?? this.strength,
      agility: agility ?? this.agility,
      vitality: vitality ?? this.vitality,
      sense: sense ?? this.sense,
      intelligence: intelligence ?? this.intelligence,
      statPoints: statPoints ?? this.statPoints,
      hunterClass: hunterClass ?? this.hunterClass,
      isAwakened: isAwakened ?? this.isAwakened,
      workoutType: workoutType ?? this.workoutType,
      currentHp: currentHp ?? this.currentHp,
      currentMp: currentMp ?? this.currentMp,
    );
  }
}
