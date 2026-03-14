import 'stat_boost.dart';

enum QuestStatus { pending, completed, failed, penalty }

class Reward {
  final int exp;
  final StatBoost statBoost;
  final List<String> itemDrops; // IDs of items

  const Reward({
    this.exp = 0,
    this.statBoost = StatBoost.zero,
    this.itemDrops = const [],
  });

  Map<String, dynamic> toJson() => {
        'exp': exp,
        'statBoost': statBoost.toJson(),
        'itemDrops': itemDrops,
      };

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
        exp: json['exp'] ?? 0,
        statBoost: StatBoost.fromJson(
            Map<String, dynamic>.from(json['statBoost'] ?? {})),
        itemDrops: List<String>.from(json['itemDrops'] ?? []),
      );
}

class Quest {
  final String id;
  final String title;
  final String description;
  final QuestStatus status;
  final Reward reward;
  final DateTime? completedAt;

  const Quest({
    required this.id,
    required this.title,
    required this.description,
    this.status = QuestStatus.pending,
    required this.reward,
    this.completedAt,
  });

  Quest copyWith({
    QuestStatus? status,
    DateTime? completedAt,
  }) {
    return Quest(
      id: id,
      title: title,
      description: description,
      status: status ?? this.status,
      reward: reward,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'status': status.name,
        'reward': reward.toJson(),
        'completedAt': completedAt?.toIso8601String(),
      };

  factory Quest.fromJson(Map<String, dynamic> json) => Quest(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        status: QuestStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => QuestStatus.pending,
        ),
        reward: Reward.fromJson(json['reward']),
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'])
            : null,
      );
}
