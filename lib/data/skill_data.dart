import '../models/skill.dart';

class SkillData {
  static final List<Skill> activeSkills = [
    Skill(
      id: "dash",
      name: "DASH (LV.1)",
      type: SkillType.ACTIVE,
      description:
          "Burst of speed. Movement speed increases by 30%. Costs 10 MP per second.",
      icon: "zap",
      levelReq: 1,
      mpCost: 10,
    ),
    Skill(
      id: "vital-strike",
      name: "VITAL STRIKE",
      type: SkillType.ACTIVE,
      description:
          "A powerful attack targeting vital points. Deals 150% damage.",
      icon: "sword",
      levelReq: 3,
      statReq: StatRequirement(stat: "strength", value: 6),
      mpCost: 15,
    ),
    Skill(
      id: "quick-step",
      name: "QUICK STEP",
      type: SkillType.ACTIVE,
      description:
          "Dodge incoming attacks with enhanced reflexes. Evasion +40% for 3 seconds.",
      icon: "wind",
      levelReq: 5,
      statReq: StatRequirement(stat: "agility", value: 7),
      mpCost: 20,
    ),
    Skill(
      id: "stealth",
      name: "STEALTH",
      type: SkillType.ACTIVE,
      description:
          "Conceal your presence temporarily. Detection range reduced by 80%.",
      icon: "eye",
      levelReq: 7,
      statReq: StatRequirement(stat: "sense", value: 5),
      mpCost: 25,
    ),
    Skill(
      id: "focus",
      name: "FOCUS",
      type: SkillType.ACTIVE,
      description:
          "Sharpen your mind to analyze enemy patterns. Reveals weak points.",
      icon: "activity",
      levelReq: 10,
      statReq: StatRequirement(stat: "intelligence", value: 6),
      mpCost: 30,
    ),
    Skill(
      id: "endurance-burst",
      name: "ENDURANCE BURST",
      type: SkillType.ACTIVE,
      description:
          "Temporarily boost stamina recovery. HP regeneration +50% for 10 seconds.",
      icon: "heart",
      levelReq: 12,
      statReq: StatRequirement(stat: "vitality", value: 10),
      mpCost: 40,
    ),
  ];

  static final List<Skill> passiveSkills = [
    // Strength-based
    Skill(
        id: "iron-grip",
        name: "IRON GRIP",
        type: SkillType.PASSIVE,
        description: "Carry capacity +20%, grip strength enhanced.",
        icon: "shield",
        levelReq: 1,
        statReq: StatRequirement(stat: "strength", value: 8)),
    Skill(
        id: "power-strike",
        name: "POWER STRIKE",
        type: SkillType.PASSIVE,
        description: "Physical damage +15%.",
        icon: "sword",
        levelReq: 1,
        statReq: StatRequirement(stat: "strength", value: 12)),
    Skill(
        id: "muscle-memory",
        name: "MUSCLE MEMORY",
        type: SkillType.PASSIVE,
        description: "Strength training efficiency +10%.",
        icon: "trending-up",
        levelReq: 1,
        statReq: StatRequirement(stat: "strength", value: 15)),

    // Agility-based
    Skill(
        id: "nimble-feet",
        name: "NIMBLE FEET",
        type: SkillType.PASSIVE,
        description: "Movement speed +10%.",
        icon: "wind",
        levelReq: 1,
        statReq: StatRequirement(stat: "agility", value: 7)),
    Skill(
        id: "evasion",
        name: "EVASION",
        type: SkillType.PASSIVE,
        description: "Dodge chance +15%.",
        icon: "wind",
        levelReq: 1,
        statReq: StatRequirement(stat: "agility", value: 10)),
    Skill(
        id: "reflex-boost",
        name: "REFLEX BOOST",
        type: SkillType.PASSIVE,
        description: "Reaction time improved. Critical hit chance +10%.",
        icon: "zap",
        levelReq: 1,
        statReq: StatRequirement(stat: "agility", value: 13)),

    // Vitality-based
    Skill(
        id: "reinforcement",
        name: "REINFORCEMENT",
        type: SkillType.PASSIVE,
        description: "Physical defense +20%.",
        icon: "shield",
        levelReq: 1,
        statReq: StatRequirement(stat: "vitality", value: 6)),
    Skill(
        id: "regeneration",
        name: "REGENERATION",
        type: SkillType.PASSIVE,
        description: "HP recovery +25%.",
        icon: "heart",
        levelReq: 1,
        statReq: StatRequirement(stat: "vitality", value: 10)),
    Skill(
        id: "iron-body",
        name: "IRON BODY",
        type: SkillType.PASSIVE,
        description: "Damage reduction +10%. Immune to minor status effects.",
        icon: "shield",
        levelReq: 1,
        statReq: StatRequirement(stat: "vitality", value: 14)),

    // Sense-based
    Skill(
        id: "keen-eye",
        name: "KEEN EYE",
        type: SkillType.PASSIVE,
        description: "Detect hidden objectives and traps.",
        icon: "eye",
        levelReq: 1,
        statReq: StatRequirement(stat: "sense", value: 5)),
    Skill(
        id: "danger-sense",
        name: "DANGER SENSE",
        type: SkillType.PASSIVE,
        description: "Warning before critical situations. Ambush detection.",
        icon: "eye",
        levelReq: 1,
        statReq: StatRequirement(stat: "sense", value: 8)),
    Skill(
        id: "perception",
        name: "PERCEPTION",
        type: SkillType.PASSIVE,
        description: "Awareness radius +30%. See enemy stats.",
        icon: "eye",
        levelReq: 1,
        statReq: StatRequirement(stat: "sense", value: 12)),

    // Intelligence-based
    Skill(
        id: "mana-efficiency",
        name: "MANA EFFICIENCY",
        type: SkillType.PASSIVE,
        description: "MP cost -10% for all skills.",
        icon: "activity",
        levelReq: 1,
        statReq: StatRequirement(stat: "intelligence", value: 6)),
    Skill(
        id: "quick-learner",
        name: "QUICK LEARNER",
        type: SkillType.PASSIVE,
        description: "EXP gain +5%. Learn faster from experience.",
        icon: "trending-up",
        levelReq: 1,
        statReq: StatRequirement(stat: "intelligence", value: 9)),
    Skill(
        id: "tactical-mind",
        name: "TACTICAL MIND",
        type: SkillType.PASSIVE,
        description: "Skill cooldown -15%. Strategic thinking enhanced.",
        icon: "activity",
        levelReq: 1,
        statReq: StatRequirement(stat: "intelligence", value: 13)),
  ];
}
