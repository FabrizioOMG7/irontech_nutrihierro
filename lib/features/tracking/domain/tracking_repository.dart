import 'daily_record.dart';

// Contrato para gestionar el historial de consumo de hierro
abstract class TrackingRepository {
  
  // Guarda un nuevo registro de consumo
  Future<void> saveRecord(DailyRecord record);

  // Obtiene todos los registros de un mes específico para el calendario
  Future<List<DailyRecord>> getRecordsForChildInMonth(String childId, int month, int year);
  
  // Elimina un registro por si hay un error
  Future<void> deleteRecord(String recordId);
}