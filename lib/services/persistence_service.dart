import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player_stats.dart';

class PlayerSaveState {
  final PlayerStats stats;
  final List<String> equippedItemIds;
  final List<Map<String, dynamic>> questHistory;
  final bool isPenaltyActive;

  const PlayerSaveState({
    required this.stats,
    required this.equippedItemIds,
    this.questHistory = const [],
    this.isPenaltyActive = false,
  });
}

class PersistenceService {
  static const String _keyPrefix = "arise_v1_";
  static const int dataVersion = 3;

  static Future<void> savePlayerState(
    String playerName, {
    required PlayerStats stats,
    required List<String> equippedItemIds,
    List<Map<String, dynamic>> questHistory = const [],
    bool isPenaltyActive = false,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final payload = {
        'dataVersion': dataVersion,
        'stats': stats.toJson(),
        'equippedItemIds': equippedItemIds,
        'questHistory': questHistory,
        'isPenaltyActive': isPenaltyActive,
        'timestamp': DateTime.now().toIso8601String(),
      };
      await prefs.setString(
          "$_keyPrefix${playerName}_stats", jsonEncode(payload));
    } catch (e) {
      // ignore: avoid_print
      print("ERROR: Persistence failure: $e");
    }
  }

  static Future<void> saveSession(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("${_keyPrefix}current_user_session", jsonEncode({
      'name': name,
      'email': email,
    }));
  }

  static Future<Map<String, String>?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final session = prefs.getString("${_keyPrefix}current_user_session");
    if (session == null) return null;
    final Map<String, dynamic> data = jsonDecode(session);
    return {
      'name': data['name']?.toString() ?? "",
      'email': data['email']?.toString() ?? "",
    };
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("${_keyPrefix}current_user_session");
  }

  static Future<void> savePlayerStats(String playerName, PlayerStats stats) {
    return savePlayerState(
      playerName,
      stats: stats,
      equippedItemIds: const [],
      questHistory: const [],
      isPenaltyActive: false,
    );
  }

  static Future<PlayerSaveState?> loadPlayerState(String playerName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString("$_keyPrefix${playerName}_stats");
      if (jsonString == null) return null;

      final Map<String, dynamic> data = jsonDecode(jsonString);
      final migrated = _migrateToCurrent(data);
      if (!_isValidPayload(migrated)) return null;

      final statsJson = Map<String, dynamic>.from(migrated['stats']);
      final equippedRaw =
          migrated['equippedItemIds'] as List<dynamic>? ?? const [];
      final equippedItemIds = equippedRaw
          .map((id) => id.toString())
          .where((id) => id.isNotEmpty)
          .toList();

      final historyRaw = migrated['questHistory'] as List<dynamic>? ?? const [];
      final questHistory =
          historyRaw.map((e) => Map<String, dynamic>.from(e)).toList();

      return PlayerSaveState(
        stats: PlayerStats.fromJson(statsJson),
        equippedItemIds: equippedItemIds,
        questHistory: questHistory,
        isPenaltyActive: migrated['isPenaltyActive'] ?? false,
      );
    } catch (e) {
      // ignore: avoid_print
      print("ERROR: Load failure, using fallback: $e");
      return null;
    }
  }

  static Future<PlayerStats?> loadPlayerStats(String playerName) async {
    final state = await loadPlayerState(playerName);
    return state?.stats;
  }

  static Map<String, dynamic> _migrateToCurrent(Map<String, dynamic> payload) {
    final legacyVersion = payload['version'] as int?;
    var version = (payload['dataVersion'] as int?) ?? legacyVersion ?? 0;
    var next = Map<String, dynamic>.from(payload);

    while (version < dataVersion) {
      if (version == 0 || version == 1) {
        next['dataVersion'] = 2;
        next['equippedItemIds'] = next['equippedItemIds'] ?? <String>[];
        version = 2;
      } else if (version == 2) {
        next['dataVersion'] = 3;
        next['questHistory'] = next['questHistory'] ?? <Map<String, dynamic>>[];
        next['isPenaltyActive'] = next['isPenaltyActive'] ?? false;
        version = 3;
      } else {
        break;
      }
    }
    return next;
  }

  static bool _isValidPayload(Map<String, dynamic> payload) {
    final stats = payload['stats'];
    if (stats is! Map) return false;

    final level = stats['level'];
    final exp = stats['exp'];
    if (level is! int || level < 1) return false;
    if (exp is! int || exp < 0) return false;
    return true;
  }

  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
