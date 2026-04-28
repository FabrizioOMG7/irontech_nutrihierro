import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:irontech_nutrihierro/features/tracking/domain/daily_record.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/daily_records_query.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/monthly_records_query.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/tracking_repository.dart';

/// Implementación temporal en RAM para probar el calendario sin Firebase.
class TrackingRepositoryMock implements TrackingRepository {
  static const String _recordsStorageKey = 'tracking_records_v1';

  Future<List<DailyRecord>> _readRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_recordsStorageKey);
    if (raw == null || raw.isEmpty) return <DailyRecord>[];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => DailyRecord.fromJson(item as Map<String, dynamic>))
        .toList(growable: true);
  }

  Future<void> _writeRecords(List<DailyRecord> records) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = records.map((item) => item.toJson()).toList(growable: false);
    await prefs.setString(_recordsStorageKey, jsonEncode(payload));
  }

  @override
  Future<void> saveRecord(DailyRecord record) async {
    final memoryDb = await _readRecords();
    memoryDb.add(record);
    await _writeRecords(memoryDb);
  }

  @override
  Future<List<DailyRecord>> getRecordsForChildInMonth(
    MonthlyRecordsQuery query,
  ) async {
    final memoryDb = await _readRecords();
    // Filtramos para devolver solo los registros de ese niño en ese mes y año específico
    final records =
        memoryDb
            .where(
              (r) =>
                  r.childId == query.childId &&
                  r.date.month == query.month &&
                  r.date.year == query.year,
            )
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
    return List<DailyRecord>.unmodifiable(records);
  }

  @override
  Future<List<DailyRecord>> getRecordsForChildInDate(
    DailyRecordsQuery query,
  ) async {
    final memoryDb = await _readRecords();
    final records =
        memoryDb
            .where(
              (r) =>
                  r.childId == query.childId &&
                  r.isFromDate(query.date),
            )
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
    return List<DailyRecord>.unmodifiable(records);
  }

  @override
  Future<void> deleteRecord(String recordId) async {
    final memoryDb = await _readRecords();
    memoryDb.removeWhere((r) => r.id == recordId);
    await _writeRecords(memoryDb);
  }

  @override
  Future<void> deleteManyRecords(List<String> recordIds) async {
    if (recordIds.isEmpty) return;
    final memoryDb = await _readRecords();
    memoryDb.removeWhere((r) => recordIds.contains(r.id));
    await _writeRecords(memoryDb);
  }

  @override
  Future<void> deleteAllRecordsForChild(String childId) async {
    final memoryDb = await _readRecords();
    memoryDb.removeWhere((r) => r.childId == childId);
    await _writeRecords(memoryDb);
  }
}
