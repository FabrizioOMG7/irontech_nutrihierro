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
  final double ironMg;

  DailyRecord({
    required this.id,
    required this.childId,
    required this.date,
    required this.sourceType,
    required this.description,
    this.wasAccepted = true,
    this.ironMg = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'childId': childId,
      'date': date.toIso8601String(),
      'sourceType': sourceType.name,
      'description': description,
      'wasAccepted': wasAccepted,
      'ironMg': ironMg,
    };
  }

  factory DailyRecord.fromJson(Map<String, dynamic> json) {
    return DailyRecord(
      id: json['id'] as String,
      childId: json['childId'] as String,
      date: DateTime.parse(json['date'] as String),
      sourceType: _sourceTypeFromStorage(json['sourceType'] as String?),
      description: json['description'] as String,
      wasAccepted: json['wasAccepted'] as bool? ?? true,
      ironMg: (json['ironMg'] as num?)?.toDouble() ?? 0,
    );
  }

  // Método para saber si este registro pertenece a una fecha específica
  bool isFromDate(DateTime targetDate) {
    return date.year == targetDate.year &&
        date.month == targetDate.month &&
        date.day == targetDate.day;
  }
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
