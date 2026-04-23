const int _minimumTrackedAgeMonths = 6;
const int _goal11MgUpperLimitMonths = 11;
const int _goal7MgUpperLimitMonths = 47;
const double _goal11Mg = 11.0;
const double _goal7Mg = 7.0;
const double _goal10Mg = 10.0;

double estimatedDailyIronGoalMg(int ageInMonths) {
  // Metas MINSA:
  // 6-11 meses: 11 mg/día | 1-3 años: 7 mg/día | 4-5 años: 10 mg/día.
  if (ageInMonths < _minimumTrackedAgeMonths) return 0;
  if (ageInMonths <= _goal11MgUpperLimitMonths) return _goal11Mg;
  if (ageInMonths <= _goal7MgUpperLimitMonths) return _goal7Mg;
  return _goal10Mg;
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

double ironMissingMg({
  required double consumedMg,
  required double goalMg,
}) {
  if (goalMg <= 0) return 0;
  final missing = goalMg - consumedMg;
  if (missing <= 0) return 0;
  return missing;
}
