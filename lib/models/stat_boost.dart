class StatBoost {
  final int strength;
  final int agility;
  final int vitality;
  final int sense;
  final int intelligence;

  const StatBoost({
    this.strength = 0,
    this.agility = 0,
    this.vitality = 0,
    this.sense = 0,
    this.intelligence = 0,
  });

  static const StatBoost zero = StatBoost();

  factory StatBoost.fromJson(Map<String, dynamic> json) {
    return StatBoost(
      strength: (json['strength'] as num?)?.toInt() ?? 0,
      agility: (json['agility'] as num?)?.toInt() ?? 0,
      vitality: (json['vitality'] as num?)?.toInt() ?? 0,
      sense: (json['sense'] as num?)?.toInt() ?? 0,
      intelligence: (json['intelligence'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, int> toJson() => {
        'strength': strength,
        'agility': agility,
        'vitality': vitality,
        'sense': sense,
        'intelligence': intelligence,
      };

  StatBoost operator +(StatBoost other) {
    return StatBoost(
      strength: strength + other.strength,
      agility: agility + other.agility,
      vitality: vitality + other.vitality,
      sense: sense + other.sense,
      intelligence: intelligence + other.intelligence,
    );
  }
}
