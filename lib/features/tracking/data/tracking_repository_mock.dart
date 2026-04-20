import 'package:irontech_nutrihierro/features/tracking/domain/daily_record.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/daily_records_query.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/monthly_records_query.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/tracking_repository.dart';

/// Implementación temporal en RAM para probar el calendario sin Firebase.
class TrackingRepositoryMock implements TrackingRepository {
  // Nuestra lista en memoria RAM (válida para la sesión actual de la app).
  final List<DailyRecord> _memoryDb = [];

  @override
  Future<void> saveRecord(DailyRecord record) async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    ); // Simulamos la carga
    _memoryDb.add(record);
  }

  @override
  Future<List<DailyRecord>> getRecordsForChildInMonth(
    MonthlyRecordsQuery query,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Filtramos para devolver solo los registros de ese niño en ese mes y año específico
    final records =
        _memoryDb
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
    await Future.delayed(const Duration(milliseconds: 300));
    final records =
        _memoryDb
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
    _memoryDb.removeWhere((r) => r.id == recordId);
  }
}
