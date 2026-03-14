import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/system_provider.dart';
import '../config/ui_config.dart';
import '../services/system_audio_service.dart';
import '../services/game_logic.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final system = Provider.of<SystemProvider>(context);
    final stats = system.stats;
    final resolved = system.resolvedStats;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildTabBar(),
              const SizedBox(height: 24),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildStatsTab(system, stats, resolved),
                    _buildHistoryTab(system),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        AriseUI.ornament(),
        const SizedBox(width: 12),
        Text("01 STATUS", style: AriseUI.heading), // Numbered nav
        const Spacer(),
        Icon(Icons.wifi_tethering,
            color: AriseUI.primary.withOpacity(0.5), size: 16),
      ],
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      indicatorColor: AriseUI.primary,
      onTap: (index) {
        SystemAudioService().playClick();
      },
      indicatorWeight: 2,
      labelColor: AriseUI.primary,
      unselectedLabelColor: Colors.white24,
      labelStyle: const TextStyle(
          fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 2),
      tabs: const [
        Tab(text: "STATS"),
        Tab(text: "HISTORY"),
      ],
    );
  }

  Widget _buildStatsTab(SystemProvider system, stats, resolved) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileSection(system, stats),
          const SizedBox(height: 32),
          _buildMetersSection(system, resolved),
          const SizedBox(height: 32),
          _buildStatsGrid(stats, resolved),
          const SizedBox(height: 32),
          _buildClassGate(stats),
        ],
      ),
    );
  }

  Widget _buildProfileSection(SystemProvider system, stats) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AriseUI.glassHUD(),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AriseUI.primary, width: 1.5),
              color: AriseUI.primary.withOpacity(0.1),
            ),
            child: Text("${stats.level}",
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white)),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(system.playerName.toUpperCase(),
                    style: AriseUI.subHeading),
                const SizedBox(height: 4),
                Text("RANK: ${stats.rank}",
                    style: TextStyle(
                        color: AriseUI.secondary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                LiquidEnergyBar(
                    label: "EXP",
                    value: system.expProgress,
                    color: AriseUI.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetersSection(SystemProvider system, resolved) {
    final stats = system.stats; // Access stats from system provider
    return Column(
      children: [
        LiquidEnergyBar(
          label: "HP [${stats.currentHp} / ${system.maxHp}]",
          value: stats.currentHp / system.maxHp,
          color: AriseUI.danger,
        ),
        const SizedBox(height: 12),
        LiquidEnergyBar(
          label: "MP [${stats.currentMp} / ${system.maxMp}]",
          value: stats.currentMp / system.maxMp,
          color: AriseUI.mana,
        ),
      ],
    );
  }

  // Replaced with LiquidEnergyBar class below

  Widget _buildStatsGrid(stats, resolved) {
    final List<Map<String, dynamic>> statItems = [
      {
        "label": "Strength",
        "val": resolved.strength,
        "key": "strength",
        "emoji": "💪"
      },
      {
        "label": "Agility",
        "val": resolved.agility,
        "key": "agility",
        "emoji": "⚡"
      },
      {
        "label": "Vitality",
        "val": resolved.vitality,
        "key": "vitality",
        "emoji": "🛡️"
      },
      {"label": "Sense", "val": resolved.sense, "key": "sense", "emoji": "👁️"},
      {
        "label": "Intelligence",
        "val": resolved.intelligence,
        "key": "intelligence",
        "emoji": "🧠"
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: statItems.length,
      itemBuilder: (context, index) {
        final item = statItems[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: AriseUI.glassHUD().copyWith(
            border:
                Border.all(color: AriseUI.primary.withOpacity(0.4), width: 1.5),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item['label'].toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1)),
                    Text("${item['val']}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
              Text(item['emoji'], style: const TextStyle(fontSize: 20)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClassGate(stats) {
    bool isLocked = stats.level < GameLogic.CLASS_CHANGE_LEVEL;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isLocked
            ? Colors.white.withOpacity(0.05)
            : AriseUI.primary.withOpacity(0.05),
        border: Border.all(
            color: isLocked ? Colors.white24 : AriseUI.primary.withOpacity(0.3),
            style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Text(
              isLocked
                  ? "CLASS ADVANCEMENT LOCKED"
                  : "CLASS: ${stats.hunterClass}",
              style: TextStyle(
                  color: isLocked ? Colors.white60 : AriseUI.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  letterSpacing: 2)),
          if (isLocked) const SizedBox(height: 8),
          if (isLocked)
            Text("REACH LEVEL ${GameLogic.CLASS_CHANGE_LEVEL} TO UNLOCK",
                style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 8,
                    fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(SystemProvider system) {
    final logs = system.questHistory;
    if (logs.isEmpty) {
      return const Center(
        child: Text("NO RECORDS FOUND IN SYSTEM BUFFER",
            style: TextStyle(
                color: Colors.white12,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2)),
      );
    }

    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: AriseUI.hudPanel().copyWith(
            border:
                Border.all(color: AriseUI.primary.withOpacity(0.5), width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(log['date'],
                      style:
                          const TextStyle(color: Colors.white24, fontSize: 8)),
                  Text(log['quest'],
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(log['status'],
                      style: TextStyle(
                          color: log['status'] == "COMPLETED"
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 10)),
                  Text(log['xp'].toString(),
                      style: TextStyle(
                          color: AriseUI.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class LiquidEnergyBar extends StatefulWidget {
  final String label;
  final double value;
  final Color color;

  const LiquidEnergyBar(
      {super.key,
      required this.label,
      required this.value,
      required this.color});

  @override
  _LiquidEnergyBarState createState() => _LiquidEnergyBarState();
}

class _LiquidEnergyBarState extends State<LiquidEnergyBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: TextStyle(
                color: widget.color.withOpacity(0.8),
                fontSize: 9,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                border:
                    Border.all(color: widget.color.withOpacity(0.4), width: 1),
              ),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: widget.value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.color.withOpacity(0.8),
                            widget.color,
                            widget.color.withOpacity(0.8),
                          ],
                          stops: [
                            (0.0 + (0.5 * _controller.value)).clamp(0.0, 1.0),
                            (0.3 + (0.4 * _controller.value)).clamp(0.0, 1.0),
                            (0.6 + (0.4 * _controller.value)).clamp(0.0, 1.0),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: widget.color.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 1)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
