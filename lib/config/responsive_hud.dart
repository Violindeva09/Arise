import 'package:flutter/material.dart';

class ResponsiveHUD extends StatelessWidget {
  final Widget child;

  const ResponsiveHUD({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
            maxWidth: 600), // Standard HUD width for desktop
        child: child,
      ),
    );
  }
}
