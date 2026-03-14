import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SystemAudioService {
  static final SystemAudioService _instance = SystemAudioService._internal();

  factory SystemAudioService() {
    return _instance;
  }

  SystemAudioService._internal();

  final AudioPlayer _uiPlayer = AudioPlayer();
  final AudioPlayer _alertPlayer = AudioPlayer();

  bool _isMuted = false;

  bool get isMuted => _isMuted;

  void toggleMute() {
    _isMuted = !_isMuted;
  }

  Future<void> init() async {
    try {
      _uiPlayer.setReleaseMode(ReleaseMode.stop);
      _alertPlayer.setReleaseMode(ReleaseMode.stop);
      if (kDebugMode) print('SYSTEM: Audio Service Initialized.');
    } catch (e) {
      if (kDebugMode) print('SYSTEM ERROR: Audio Init failed: $e');
    }
  }

  Future<void> playClick() async {
    if (_isMuted) return;
    try {
      if (kDebugMode) print('SYSTEM: Playing CLICK sound...');
      if (_uiPlayer.state == PlayerState.playing) {
        await _uiPlayer.stop();
      }
      await _uiPlayer.play(AssetSource('audio/solo_leveling_counter.mp3'));
    } catch (e) {
      if (kDebugMode) print('SYSTEM ERROR: Error playing click sound: $e');
    }
  }

  Future<void> playSwish() async {
    if (_isMuted) return;
    try {
      if (kDebugMode) print('SYSTEM: Playing SWISH sound...');
      if (_uiPlayer.state == PlayerState.playing) {
        await _uiPlayer.stop();
      }
      await _uiPlayer.play(AssetSource('audio/solo_leveling_menu_pop.mp3'));
    } catch (e) {
      if (kDebugMode) print('SYSTEM ERROR: Error playing swish sound: $e');
    }
  }

  Future<void> playAlert() async {
    if (_isMuted) return;
    try {
      if (kDebugMode) print('SYSTEM: Playing ALERT sound...');
      if (_alertPlayer.state == PlayerState.playing) {
        await _alertPlayer.stop();
      }
      await _alertPlayer.play(AssetSource('audio/solo_leveling_system.mp3'));
    } catch (e) {
      if (kDebugMode) print('SYSTEM ERROR: Error playing alert sound: $e');
    }
  }

  Future<void> playLevelUp() async {
    if (_isMuted) return;
    try {
      if (kDebugMode) print('SYSTEM: Playing LEVEL UP sound...');
      await _alertPlayer
          .play(AssetSource('audio/solo_leveling_notification.mp3'));
    } catch (e) {
      if (kDebugMode) print('SYSTEM ERROR: Error playing level up sound: $e');
    }
  }
}
