import 'package:flutter_test/flutter_test.dart';
import 'package:irontech_nutrihierro/features/tracking/data/tracking_repository_mock.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/daily_record.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/daily_records_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('TrackingRepositoryMock', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('persiste registros y mantiene separación por childId', () async {
      final firstRepository = TrackingRepositoryMock();
      final today = DateTime(2026, 4, 22);
      await firstRepository.saveRecord(
        DailyRecord(
          id: 'r1',
          childId: 'child-1',
          date: today,
          sourceType: IronSourceType.food,
          description: 'Sangrecita',
        ),
      );
      await firstRepository.saveRecord(
        DailyRecord(
          id: 'r2',
          childId: 'child-2',
          date: today,
          sourceType: IronSourceType.food,
          description: 'Lentejas',
        ),
      );

      final secondRepository = TrackingRepositoryMock();
      final child1Records = await secondRepository.getRecordsForChildInDate(
        DailyRecordsQuery(childId: 'child-1', date: today),
      );
      final child2Records = await secondRepository.getRecordsForChildInDate(
        DailyRecordsQuery(childId: 'child-2', date: today),
      );

      expect(child1Records, hasLength(1));
      expect(child2Records, hasLength(1));
      expect(child1Records.first.id, 'r1');
      expect(child2Records.first.id, 'r2');
    });
  });
}
