import 'package:irontech_nutrihierro/features/tracking/domain/daily_record.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/monthly_records_query.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/tracking_repository.dart';


/// Implementación temporal en RAM para probar el calendario sin Firebase.
class TrackingRepositoryMock implements TrackingRepository {
  // Nuestra lista en memoria RAM
  final List<DailyRecord> _memoryDb = [];

  @override
  Future<void> saveRecord(DailyRecord record) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulamos la carga
    _memoryDb.add(record);
  }

  @override
  Future<List<DailyRecord>> getRecordsForChildInMonth(MonthlyRecordsQuery query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Filtramos para devolver solo los registros de ese niño en ese mes y año específico
    return List<DailyRecord>.unmodifiable(
      _memoryDb.where((r) => 
        r.childId == query.childId && 
        r.date.month == query.month && 
        r.date.year == query.year
      ),
    );
  }

  @override
  Future<void> deleteRecord(String recordId) async {
    _memoryDb.removeWhere((r) => r.id == recordId);
  }
}
