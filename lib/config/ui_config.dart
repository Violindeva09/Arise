import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AriseUI {
  // Colors
  static const Color background = Color(0xFF070707);
  static const Color surface = Color(0xFF0F0F0F);
  static const Color primary = Color(0xFF00A0FF);
  static const Color secondary = Color(0xFF00FFD1);
  static const Color accent = Color(0xFFFF006B);
  static const Color danger = Color(0xFFFF2E2E);
  static const Color hp = danger;
  static const Color mana = secondary;

  // Attribute Emojis
  static const Map<String, String> emojis = {
    'strength': '💪',
    'agility': '⚡',
    'vitality': '❤️',
    'sense': '👁️',
    'intelligence': '🧠',
  };

  // Shadows & Glows
  static List<BoxShadow> glow(Color color) => [
        BoxShadow(
            color: color.withOpacity(0.3), blurRadius: 10, spreadRadius: 2),
        BoxShadow(
            color: color.withOpacity(0.1), blurRadius: 20, spreadRadius: 5),
      ];

  static const List<BoxShadow> glassShadow = [
    BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 5)),
  ];

  // Decorations
  static BoxDecoration holographic({Color? color, double opacity = 0.05}) =>
      BoxDecoration(
        color: (color ?? Colors.white).withOpacity(opacity),
        border: Border.all(color: (color ?? Colors.white).withOpacity(0.15)),
        borderRadius: BorderRadius.circular(4),
      );

  static BoxDecoration hudPanel() => BoxDecoration(
        color: background.withOpacity(0.95),
        border: Border.all(color: primary.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: primary.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: -5),
        ],
      );

  static BoxDecoration glassHUD({double blur = 10, double opacity = 0.05}) =>
      BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        border: Border.all(color: primary.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      );

  static LinearGradient liquidGradient(Color color) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color,
          color.withOpacity(0.6),
          color.withOpacity(0.9),
          color,
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      );

  static List<BoxShadow> monarchGlow(Color color) => [
        BoxShadow(
            color: color.withOpacity(0.5), blurRadius: 15, spreadRadius: 2),
        BoxShadow(
            color: color.withOpacity(0.2), blurRadius: 30, spreadRadius: 5),
      ];

  static Widget ornament() => Container(
        height: 10,
        width: 2,
        color: primary,
      );

  // Text Styles
  static final TextStyle heading = GoogleFonts.orbitron(
    color: primary,
    fontSize: 24,
    fontWeight: FontWeight.w900,
    letterSpacing: 4.0,
  );

  static final TextStyle subHeading = GoogleFonts.orbitron(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );

  static final TextStyle label = GoogleFonts.orbitron(
    color: primary,
    fontSize: 10,
    fontWeight: FontWeight.w900,
    letterSpacing: 2.0,
  );

  static final TextStyle body = GoogleFonts.orbitron(
    color: Colors.white70,
    fontSize: 14,
    letterSpacing: 1.2,
  );
}
