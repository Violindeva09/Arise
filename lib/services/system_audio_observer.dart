import 'package:flutter/material.dart';
import 'system_audio_service.dart';

class SystemAudioObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    // Don't play sound on the very first route push (app start)
    if (previousRoute != null) {
      SystemAudioService().playSwish();
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    SystemAudioService().playSwish();
  }
}
