enum SkillType { ACTIVE, PASSIVE }

class StatRequirement {
  final String stat;
  final int value;

  const StatRequirement({required this.stat, required this.value});

  Map<String, dynamic> toJson() => {'stat': stat, 'value': value};
  factory StatRequirement.fromJson(Map<String, dynamic> json) =>
      StatRequirement(stat: json['stat'], value: json['value']);
}

class Skill {
  final String id;
  final String name;
  final SkillType type;
  final String description;
  final String icon;
  final int levelReq;
  final StatRequirement? statReq;
  final int? mpCost;
  final bool isUnlocked;

  const Skill({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.icon,
    required this.levelReq,
    this.statReq,
    this.mpCost,
    this.isUnlocked = false,
  });

  Skill copyWith({bool? isUnlocked}) {
    return Skill(
      id: id,
      name: name,
      type: type,
      description: description,
      icon: icon,
      levelReq: levelReq,
      statReq: statReq,
      mpCost: mpCost,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.name,
        'description': description,
        'icon': icon,
        'levelReq': levelReq,
        'statReq': statReq?.toJson(),
        'mpCost': mpCost,
        'isUnlocked': isUnlocked,
      };

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
        id: json['id'],
        name: json['name'],
        type: SkillType.values.byName(json['type']),
        description: json['description'] ?? json['desc'] ?? "",
        icon: json['icon'],
        levelReq: json['levelReq'],
        statReq: json['statReq'] != null
            ? StatRequirement.fromJson(json['statReq'])
            : null,
        mpCost: json['mpCost'],
        isUnlocked: json['isUnlocked'] ?? false,
      );
}
