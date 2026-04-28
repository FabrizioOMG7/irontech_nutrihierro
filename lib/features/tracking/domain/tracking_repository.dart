import 'daily_record.dart';
import 'daily_records_query.dart';
import 'monthly_records_query.dart';

// Contrato para gestionar el historial de consumo de hierro
abstract class TrackingRepository {
  
  // Guarda un nuevo registro de consumo
  Future<void> saveRecord(DailyRecord record);

  // Obtiene todos los registros de un mes específico para el calendario
  Future<List<DailyRecord>> getRecordsForChildInMonth(MonthlyRecordsQuery query);

  // Obtiene los registros de un día específico para mostrar historial por fecha
  Future<List<DailyRecord>> getRecordsForChildInDate(DailyRecordsQuery query);
  
  // Elimina un registro por si hay un error
  Future<void> deleteRecord(String recordId);

  // Elimina múltiples registros a la vez (borrado masivo)
  Future<void> deleteManyRecords(List<String> recordIds);

  // Elimina todos los registros asociados a un niño (para borrado en cascada)
  Future<void> deleteAllRecordsForChild(String childId);
}
