import 'package:flutter_test/flutter_test.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/iron_goal.dart';

void main() {
  group('estimatedDailyIronGoalMg', () {
    test('retorna metas mock según edad', () {
      expect(estimatedDailyIronGoalMg(4), 0);
      expect(estimatedDailyIronGoalMg(8), 11);
      expect(estimatedDailyIronGoalMg(20), 7);
      expect(estimatedDailyIronGoalMg(48), 10);
    });
  });

  group('ironGoalStatus', () {
    test('clasifica bajo / en progreso / cumplido', () {
      expect(
        ironGoalStatus(consumedMg: 1, goalMg: 10),
        IronGoalStatus.low,
      );
      expect(
        ironGoalStatus(consumedMg: 6, goalMg: 10),
        IronGoalStatus.inProgress,
      );
      expect(
        ironGoalStatus(consumedMg: 10, goalMg: 10),
        IronGoalStatus.completed,
      );
    });
  });
}
