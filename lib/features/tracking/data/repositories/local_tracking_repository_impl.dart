import 'package:isar/isar.dart';
import '../../domain/daily_record.dart';
import '../../domain/daily_records_query.dart';
import '../../domain/monthly_records_query.dart';
import '../../domain/tracking_repository.dart';
import '../../../../core/data/local_db/models/isar_daily_record.dart';

class LocalTrackingRepositoryImpl implements TrackingRepository {
  final Isar isar;

  LocalTrackingRepositoryImpl(this.isar);

  @override
  Future<void> saveRecord(DailyRecord record) async {
    final isarRecord = IsarDailyRecord()
      ..recordId = record.id
      ..childId = record.childId
      ..date = record.date
      ..sourceType = record.sourceType.name
      ..description = record.description
      ..wasAccepted = record.wasAccepted
      ..ironMg = record.ironMg;

    await isar.writeTxn(() async {
      // Put by recordId (unique string from domain) requires an index.
      // We didn't set unique on recordId, let's look it up or just use a query to replace.
      final existing = await isar.isarDailyRecords
          .filter()
          .recordIdEqualTo(record.id)
          .findFirst();

      if (existing != null) {
        isarRecord.id = existing.id; // Keep Isar's internal ID
      }

      await isar.isarDailyRecords.put(isarRecord);
    });
  }

  @override
  Future<List<DailyRecord>> getRecordsForChildInMonth(MonthlyRecordsQuery query) async {
    // Determine start and end dates of the month
    final startDate = DateTime(query.year, query.month, 1);
    final nextMonth = query.month == 12 ? 1 : query.month + 1;
    final nextYear = query.month == 12 ? query.year + 1 : query.year;
    final endDate = DateTime(nextYear, nextMonth, 1);

    final isarRecords = await isar.isarDailyRecords
        .filter()
        .childIdEqualTo(query.childId)
        .and()
        .dateGreaterThan(startDate, include: true)
        .and()
        .dateLessThan(endDate, include: false)
        .findAll();

    return isarRecords.map(_mapToDomain).toList();
  }

  @override
  Future<List<DailyRecord>> getRecordsForChildInDate(DailyRecordsQuery query) async {
    // Determine exact bounds for the given day
    final startDate = DateTime(query.date.year, query.date.month, query.date.day);
    final endDate = startDate.add(const Duration(days: 1));

    final isarRecords = await isar.isarDailyRecords
        .filter()
        .childIdEqualTo(query.childId)
        .and()
        .dateGreaterThan(startDate, include: true)
        .and()
        .dateLessThan(endDate, include: false)
        .findAll();

    return isarRecords.map(_mapToDomain).toList();
  }

  @override
  Future<void> deleteRecord(String recordId) async {
    await isar.writeTxn(() async {
      await isar.isarDailyRecords.filter().recordIdEqualTo(recordId).deleteAll();
    });
  }

  @override
  Future<void> deleteAllRecordsForDate(String childId, DateTime date) async {
    final startDate = DateTime(date.year, date.month, date.day);
    final endDate = startDate.add(const Duration(days: 1));
    await isar.writeTxn(() async {
      await isar.isarDailyRecords
          .filter()
          .childIdEqualTo(childId)
          .and()
          .dateGreaterThan(startDate, include: true)
          .and()
          .dateLessThan(endDate, include: false)
          .deleteAll();
    });
  }

  @override
  Future<void> deleteAllRecordsForChild(String childId) async {
    await isar.writeTxn(() async {
      await isar.isarDailyRecords.filter().childIdEqualTo(childId).deleteAll();
    });
  }

  DailyRecord _mapToDomain(IsarDailyRecord isarRecord) {
    return DailyRecord(
      id: isarRecord.recordId,
      childId: isarRecord.childId,
      date: isarRecord.date,
      sourceType: _sourceTypeFromStorage(isarRecord.sourceType),
      description: isarRecord.description,
      wasAccepted: isarRecord.wasAccepted,
      ironMg: isarRecord.ironMg,
    );
  }

  IronSourceType _sourceTypeFromStorage(String? value) {
    switch (value) {
      case 'supplement':
        return IronSourceType.supplement;
      case 'food':
      default:
        return IronSourceType.food;
    }
  }
}
