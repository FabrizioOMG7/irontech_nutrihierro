// Tipos de ingesta de hierro que podemos registrar
enum IronSourceType {
  food, // Comida rica en hierro (Ej. Sangrecita)
  supplement, // Gotas, jarabe o chispitas (MINSA)
}

// Entidad que representa un registro diario
class DailyRecord {
  final String id;
  final String childId;
  final DateTime date;
  final IronSourceType sourceType;
  final String description;
  final bool wasAccepted;

  DailyRecord({
    required this.id,
    required this.childId,
    required this.date,
    required this.sourceType,
    required this.description,
    this.wasAccepted = true,
  });

  // Método para saber si este registro pertenece a una fecha específica
  bool isFromDate(DateTime targetDate) {
    return date.year == targetDate.year &&
        date.month == targetDate.month &&
        date.day == targetDate.day;
  }
}
