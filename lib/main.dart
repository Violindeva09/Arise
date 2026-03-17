import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/system_audio_service.dart';
import 'services/system_audio_observer.dart';
import 'providers/system_provider.dart';
import 'screens/status_screen.dart';
import 'screens/quest_screen.dart';
import 'screens/skill_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/login_screen.dart';
import 'screens/awakening_screen.dart';
import 'config/ui_config.dart';
import 'config/responsive_hud.dart';
import 'services/persistence_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screens/routine_selection_screen.dart';

import 'screens/penalty_screen.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemAudioService().init(); // Non-blocking
  runApp(
    ChangeNotifierProvider(
      create: (context) => SystemProvider(),
      child: const AriseApp(),
    ),
  );
}

class AriseApp extends StatelessWidget {
  const AriseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arise System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AriseUI.primary,
        textTheme: GoogleFonts.orbitronTextTheme(ThemeData.dark().textTheme),
        scaffoldBackgroundColor: AriseUI.background,
      ),
      navigatorObservers: [SystemAudioObserver()],
      home: SystemOrchestrator(),
    );
  }
}

class SystemOrchestrator extends StatefulWidget {
  const SystemOrchestrator({super.key});

  @override
  State<SystemOrchestrator> createState() => _SystemOrchestratorState();
}

class _SystemOrchestratorState extends State<SystemOrchestrator> {
  bool _isCheckingSession = true;

  @override
  void initState() {
    super.initState();
    _checkInitialSession();
  }

  Future<void> _checkInitialSession() async {
    final system = Provider.of<SystemProvider>(context, listen: false);
    
    // 1. Check Firebase Auth first
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await system.init(user.displayName ?? "Hunter", user.email ?? "");
    } else {
      // 2. Check local session
      final session = await PersistenceService.getSession();
      if (session != null) {
        await system.init(session['name']!, session['email']!);
      }
    }
    
    if (mounted) {
      setState(() => _isCheckingSession = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingSession) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: AriseUI.primary),
        ),
      );
    }

    final system = Provider.of<SystemProvider>(context);
    final stats = system.stats;

    // 1. Identification Flow (If no session and no player name)
    if (system.playerName == "Hunter") {
      return const LoginScreen();
    }

    // 2. Penalty Override
    if (system.isPenaltyActive) {
      return PenaltyScreen(onResolve: () => system.resolvePenalty());
    }

    // 3. Awakening Flow
    if (!stats.isAwakened) return const AwakeningScreen();

    // 4. Routine Selection
    if (stats.workoutType == "NONE") return const RoutineSelectionScreen();

    // 5. Main System Access
    return ResponsiveHUD(child: MainScaffold());
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    StatusScreen(),
    SkillScreen(),
    const InventoryScreen(),
    QuestScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Global Holographic Background
          _buildBackground(),

          // Particle Layer
          SystemParticles(),

          // Persistent Holographic Title (Background)
          Align(
            alignment: Alignment.center,
            child: Transform.scale(
              scale: MediaQuery.of(context).size.width < 600 ? 0.7 : 1.0,
              child: HolographicTitle(),
            ),
          ),

          IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),

          // Reality Sync Clock (Bottom Left)
          _buildRealitySync(),

          // Global Scanline Effect
          _buildScanline(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildRealitySync() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      right: 24,
      child: StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 1)),
        builder: (context, snapshot) {
          final now = DateTime.now();
          final timeStr =
              "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                        color: AriseUI.primary, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text("REALITY_SYNCING...",
                      style: TextStyle(
                          color: AriseUI.primary.withOpacity(0.3),
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2)),
                ],
              ),
              const SizedBox(height: 4),
              Text("[$timeStr]",
                  style: TextStyle(
                      color: AriseUI.primary.withOpacity(0.5),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace')),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScanline() {
    return IgnorePointer(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.white.withOpacity(0.02),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Opacity(
      opacity: 0.1,
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [AriseUI.primary.withOpacity(0.5), Colors.transparent],
            center: Alignment.center,
            radius: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AriseUI.background.withOpacity(0.9),
        border: Border(
            top: BorderSide(color: AriseUI.primary.withOpacity(0.2), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(0, Icons.person_outline, "01 STATUS"),
          _navItem(1, Icons.bolt, "02 SKILL"),
          _navItem(2, Icons.inventory_2_outlined, "03 INVENTORY"),
          _navItem(3, Icons.assignment_outlined, "04 QUEST"),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        SystemAudioService().playClick();
        setState(() => _selectedIndex = index);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          transform: isSelected
              ? (Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(-0.1))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            border: isSelected
                ? Border(
                    bottom: BorderSide(color: AriseUI.primary, width: 2))
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  color: isSelected ? AriseUI.primary : Colors.white24,
                  size: 24),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                      color: isSelected ? AriseUI.primary : Colors.white24,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class SystemParticles extends StatefulWidget {
  const SystemParticles({super.key});

  @override
  _SystemParticlesState createState() => _SystemParticlesState();
}

class _SystemParticlesState extends State<SystemParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> particles = List.generate(30, (index) => Particle());

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(particles, _controller.value),
          child: Container(),
        );
      },
    );
  }
}

class Particle {
  double x = math.Random().nextDouble();
  double y = math.Random().nextDouble();
  double size = math.Random().nextDouble() * 2 + 1;
  double speed = math.Random().nextDouble() * 0.05 + 0.01;
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;

  ParticlePainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AriseUI.primary.withOpacity(0.2);
    for (var p in particles) {
      double py = (p.y - (progress * p.speed)) % 1.0;
      canvas.drawCircle(
          Offset(p.x * size.width, py * size.height), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HolographicTitle extends StatefulWidget {
  const HolographicTitle({super.key});

  @override
  _HolographicTitleState createState() => _HolographicTitleState();
}

class _HolographicTitleState extends State<HolographicTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: 0.8 + (_controller.value * 0.2),
          child: Stack(
            children: [
              Text(
                "ARISE",
                style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.w900,
                  color: Colors.white.withOpacity(0.1),
                  fontStyle: FontStyle.italic,
                  letterSpacing: -5,
                ),
              ),
              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Text(
                    "ARISE",
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.w900,
                      color: AriseUI.primary.withOpacity(0.15),
                      fontStyle: FontStyle.italic,
                      letterSpacing: -5,
                      shadows: [
                        Shadow(
                            color: AriseUI.primary,
                            blurRadius: 20 * _controller.value),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
