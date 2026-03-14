import 'dart:math';

class Penalty {
  final String title;
  final String desc;
  final Map<String, int> rewards;

  Penalty({
    required this.title,
    required this.desc,
    required this.rewards,
  });
}

class PenaltyData {
  static final List<Penalty> penalties = [
    // Physical Discipline
    Penalty(
      title: "100 BURPEES",
      desc:
          "Complete 100 burpees in sets of 10. No excuses. Film yourself and keep the video as proof of discipline.",
      rewards: {
        "strength": 3,
        "agility": 1,
        "vitality": 2,
        "sense": 0,
        "intelligence": 0,
        "exp": 250
      },
    ),
    Penalty(
      title: "PLANK ENDURANCE",
      desc:
          "Hold a plank position for a cumulative total of 10 minutes. You may break into sets, but complete all 10 minutes today.",
      rewards: {
        "strength": 2,
        "agility": 0,
        "vitality": 3,
        "sense": 1,
        "intelligence": 0,
        "exp": 250
      },
    ),
    Penalty(
      title: "WALL SIT PUNISHMENT",
      desc:
          "Complete 5 minutes of wall sits (cumulative). Your legs will remember this failure.",
      rewards: {
        "strength": 2,
        "agility": 1,
        "vitality": 2,
        "sense": 1,
        "intelligence": 0,
        "exp": 250
      },
    ),

    // Mental Discipline
    Penalty(
      title: "DIGITAL DETOX",
      desc:
          "Zero social media, YouTube, or entertainment for the next 24 hours. Only educational content allowed.",
      rewards: {
        "strength": 0,
        "agility": 0,
        "vitality": 1,
        "sense": 3,
        "intelligence": 2,
        "exp": 250
      },
    ),
    Penalty(
      title: "COLD SHOWER PROTOCOL",
      desc:
          "Take a 5-minute cold shower immediately. Embrace the discomfort you've been avoiding.",
      rewards: {
        "strength": 1,
        "agility": 0,
        "vitality": 2,
        "sense": 2,
        "intelligence": 1,
        "exp": 250
      },
    ),
    Penalty(
      title: "EARLY WAKE-UP CALL",
      desc:
          "Wake up at 5:00 AM tomorrow. No snooze button. Prove you can control your impulses.",
      rewards: {
        "strength": 0,
        "agility": 1,
        "vitality": 2,
        "sense": 2,
        "intelligence": 1,
        "exp": 250
      },
    ),

    // Productivity Discipline
    Penalty(
      title: "DEEP WORK SESSION",
      desc:
          "Complete 2 hours of focused work/study with zero distractions. Phone off, door closed. Pomodoro technique mandatory.",
      rewards: {
        "strength": 0,
        "agility": 0,
        "vitality": 1,
        "sense": 2,
        "intelligence": 3,
        "exp": 250
      },
    ),
    Penalty(
      title: "ROOM INSPECTION",
      desc:
          "Clean and organize your entire living space to military standards. Bed made with hospital corners. Everything in its place.",
      rewards: {
        "strength": 1,
        "agility": 1,
        "vitality": 1,
        "sense": 2,
        "intelligence": 1,
        "exp": 250
      },
    ),
    Penalty(
      title: "KNOWLEDGE DEBT",
      desc:
          "Read 30 pages of a non-fiction book or complete an online course module. Ignorance is not an option.",
      rewards: {
        "strength": 0,
        "agility": 0,
        "vitality": 0,
        "sense": 2,
        "intelligence": 4,
        "exp": 250
      },
    ),

    // Accountability Discipline
    Penalty(
      title: "PUBLIC DECLARATION",
      desc:
          "Post on social media admitting your failure and your commitment to improve. Accountability breeds discipline.",
      rewards: {
        "strength": 0,
        "agility": 0,
        "vitality": 1,
        "sense": 3,
        "intelligence": 2,
        "exp": 250
      },
    ),
    Penalty(
      title: "GRATITUDE PUNISHMENT",
      desc:
          "Write 50 things you're grateful for by hand. Remember what you're taking for granted by being lazy.",
      rewards: {
        "strength": 0,
        "agility": 1,
        "vitality": 1,
        "sense": 2,
        "intelligence": 2,
        "exp": 250
      },
    ),
    Penalty(
      title: "FUTURE SELF LETTER",
      desc:
          "Write a 500-word letter to your future self explaining why you failed and what you'll do differently. Be brutally honest.",
      rewards: {
        "strength": 0,
        "agility": 0,
        "vitality": 1,
        "sense": 2,
        "intelligence": 3,
        "exp": 250
      },
    ),
  ];

  static Penalty getCurrentPenalty() {
    // Randomly select a penalty from the list
    final random = Random();
    return penalties[random.nextInt(penalties.length)];
  }
}
