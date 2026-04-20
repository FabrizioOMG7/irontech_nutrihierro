import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/daily_record.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/daily_records_query.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/monthly_records_query.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/tracking_repository.dart';
import 'package:irontech_nutrihierro/features/tracking/presentation/providers/tracking_provider.dart';

class _TrackingRepositoryFake implements TrackingRepository {
  final List<DailyRecord> _records = [];

  @override
  Future<void> deleteRecord(String recordId) async {
    _records.removeWhere((r) => r.id == recordId);
  }

  @override
  Future<List<DailyRecord>> getRecordsForChildInMonth(MonthlyRecordsQuery query) async {
    return _records
        .where((r) =>
            r.childId == query.childId &&
            r.date.month == query.month &&
            r.date.year == query.year)
        .toList(growable: false);
  }

  @override
  Future<List<DailyRecord>> getRecordsForChildInDate(DailyRecordsQuery query) async {
    return _records
        .where((r) =>
            r.childId == query.childId &&
            r.date.year == query.date.year &&
            r.date.month == query.date.month &&
            r.date.day == query.date.day)
        .toList(growable: false);
  }

  @override
  Future<void> saveRecord(DailyRecord record) async {
    _records.add(record);
  }
}

void main() {
  group('tracking providers', () {
    test('monthlyRecordsProvider receives typed query and returns expected records', () async {
      final repository = _TrackingRepositoryFake();
      final now = DateTime.now();
      final targetRecord = DailyRecord(
        id: 'r1',
        childId: 'c1',
        date: now,
        sourceType: IronSourceType.food,
        description: 'Papilla',
      );
      await repository.saveRecord(targetRecord);
      await repository.saveRecord(
        DailyRecord(
          id: 'r2',
          childId: 'c2',
          date: now,
          sourceType: IronSourceType.supplement,
          description: 'Gotas',
        ),
      );

      final container = ProviderContainer(
        overrides: [
          trackingRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final query = MonthlyRecordsQuery(
        childId: 'c1',
        month: now.month,
        year: now.year,
      );
      final records = await container.read(monthlyRecordsProvider(query).future);

      expect(records, hasLength(1));
      expect(records.first.id, 'r1');
    });

    test('trackingControllerProvider.addRecord saves and invalidates monthly query', () async {
      final repository = _TrackingRepositoryFake();
      final container = ProviderContainer(
        overrides: [
          trackingRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final now = DateTime.now();
      final query = MonthlyRecordsQuery(
        childId: 'child-1',
        month: now.month,
        year: now.year,
      );

      final initial = await container.read(monthlyRecordsProvider(query).future);
      expect(initial, isEmpty);

      await container.read(trackingControllerProvider.notifier).addRecord(
            DailyRecord(
              id: 'new-record',
              childId: 'child-1',
              date: now,
              sourceType: IronSourceType.food,
              description: 'Hígado picado',
            ),
          );

      final updated = await container.read(monthlyRecordsProvider(query).future);
      expect(updated, hasLength(1));
      expect(updated.first.id, 'new-record');
    });

    test('dailyRecordsProvider returns records filtered by selected date', () async {
      final repository = _TrackingRepositoryFake();
      final now = DateTime.now();
      await repository.saveRecord(
        DailyRecord(
          id: 'today',
          childId: 'c1',
          date: now,
          sourceType: IronSourceType.food,
          description: 'Sangrecita',
        ),
      );
      await repository.saveRecord(
        DailyRecord(
          id: 'yesterday',
          childId: 'c1',
          date: now.subtract(const Duration(days: 1)),
          sourceType: IronSourceType.food,
          description: 'Lentejas',
        ),
      );

      final container = ProviderContainer(
        overrides: [
          trackingRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final records = await container.read(
        dailyRecordsProvider(DailyRecordsQuery(childId: 'c1', date: now)).future,
      );

      expect(records, hasLength(1));
      expect(records.first.id, 'today');
    });
  });
}
