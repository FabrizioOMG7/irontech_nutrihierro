double estimatedDailyIronGoalMg(int ageInMonths) {
  if (ageInMonths < 6) return 0;
  if (ageInMonths <= 11) return 11;
  if (ageInMonths <= 35) return 7;
  return 10;
}

enum IronGoalStatus { low, inProgress, completed }

IronGoalStatus ironGoalStatus({
  required double consumedMg,
  required double goalMg,
}) {
  if (goalMg <= 0) return IronGoalStatus.completed;
  final ratio = consumedMg / goalMg;
  if (ratio >= 1) return IronGoalStatus.completed;
  if (ratio >= 0.4) return IronGoalStatus.inProgress;
  return IronGoalStatus.low;
}
