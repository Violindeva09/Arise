import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/system_provider.dart';
import '../models/skill.dart';
import '../data/skill_data.dart';
import '../config/ui_config.dart';
import '../services/system_audio_service.dart';

class SkillScreen extends StatefulWidget {
  const SkillScreen({super.key});

  @override
  _SkillScreenState createState() => _SkillScreenState();
}

class _SkillScreenState extends State<SkillScreen>
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildTabBar(),
              const SizedBox(height: 8),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildSkillList(system, SkillData.activeSkills),
                    _buildSkillList(system, SkillData.passiveSkills),
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
        Text("02 SKILL", style: AriseUI.heading),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white10))),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AriseUI.primary,
        onTap: (index) {
          SystemAudioService().playClick();
        },
        indicatorWeight: 3,
        labelColor: AriseUI.primary,
        unselectedLabelColor: Colors.white24,
        labelStyle: AriseUI.label.copyWith(fontSize: 12),
        tabs: const [
          Tab(text: "ACTIVE"),
          Tab(text: "PASSIVE"),
        ],
      ),
    );
  }

  Widget _buildSkillList(SystemProvider system, List<Skill> skills) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: skills.length,
      itemBuilder: (context, index) {
        final skill = skills[index];
        final isUnlocked = system.isSkillUnlocked(skill);
        return _buildSkillCard(skill, isUnlocked);
      },
    );
  }

  Widget _buildSkillCard(Skill skill, bool isUnlocked) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: isUnlocked
          ? AriseUI.glassHUD()
          : AriseUI.glassHUD().copyWith(
              color: Colors.black.withOpacity(0.5),
              border: Border.all(color: Colors.white.withOpacity(0.2))),
      child: Opacity(
        opacity: isUnlocked ? 1.0 : 0.75,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                    color: isUnlocked ? AriseUI.primary : Colors.white24),
                borderRadius: BorderRadius.circular(0),
              ),
              child: Icon(_getIconForSkill(skill.icon),
                  color: isUnlocked ? AriseUI.primary : Colors.white38,
                  size: 28),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(skill.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              color:
                                  isUnlocked ? AriseUI.primary : Colors.white70,
                              letterSpacing: 1)),
                      if (isUnlocked)
                        Text("ACTIVE",
                            style: TextStyle(
                                color: AriseUI.primary,
                                fontSize: 8,
                                fontWeight: FontWeight.bold))
                      else
                        _buildRequirementLabel(skill),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(skill.description,
                      style: TextStyle(
                          fontSize: 10,
                          color: isUnlocked ? Colors.white54 : Colors.white30,
                          height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementLabel(Skill skill) {
    List<String> reqs = [];
    if (skill.levelReq > 1) reqs.add("LVL ${skill.levelReq}");
    if (skill.statReq != null) {
      reqs.add("${skill.statReq!.stat.toUpperCase()} ${skill.statReq!.value}");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // "LOCKED" removed per user request
        ...reqs.map((r) => Text("REQ: $r",
            style: const TextStyle(
                color: Colors.yellowAccent,
                fontSize: 8,
                fontWeight: FontWeight.bold) // Yellow requirements
            )),
      ],
    );
  }

  IconData _getIconForSkill(String iconName) {
    switch (iconName) {
      case "zap":
        return Icons.bolt;
      case "sword":
        return Icons.shield;
      case "wind":
        return Icons.air;
      case "eye":
        return Icons.visibility;
      case "activity":
        return Icons.analytics;
      case "heart":
        return Icons.favorite;
      case "trending-up":
        return Icons.trending_up;
      default:
        return Icons.auto_awesome;
    }
  }
}
