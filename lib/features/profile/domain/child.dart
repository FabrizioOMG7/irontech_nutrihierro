/// Géneros posibles para el perfil del niño/a
enum Gender { male, female }

Gender genderFromStorage(String? rawGender) {
  switch (rawGender) {
    case 'male':
      return Gender.male;
    case 'female':
      return Gender.female;
    default:
      return Gender.female;
  }
}

/// Entidad que representa a un Niño/a en el sistema.
/// Esta es la clase central que usaremos para filtrar recetas y alertas.
class Child {
  final String id;
  final String name;
  final DateTime birthDate;
  final Gender gender;

  Child({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'birthDate': birthDate.toIso8601String(),
      'gender': gender.name,
    };
  }

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id'] as String,
      name: json['name'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      gender: genderFromStorage(json['gender'] as String?),
    );
  }

  // ==========================================================
  // LÓGICA DE NEGOCIO (Domain Logic)
  // ==========================================================

  /// Calcula la edad total en meses.
  /// Es vital para los filtros de nutrición (ej: 6-8 meses).
  int get ageInMonths {
    final now = DateTime.now();
    int months = (now.year - birthDate.year) * 12 + now.month - birthDate.month;

    // Ajuste si el día actual es menor al día de nacimiento
    if (now.day < birthDate.day) {
      months--;
    }
    return months;
  }

  /// Calcula la edad en años para niños más grandes.
  int get ageInYears => ageInMonths ~/ 12;

  /// Devuelve una cadena amigable con la edad (ej: "8 meses" o "5 años, 2 meses")
  String get formattedAge {
    final months = ageInMonths;
    if (months < 12) {
      final monthLabel = months == 1 ? 'mes' : 'meses';
      return '$months $monthLabel';
    } else {
      final years = ageInYears;
      final remainingMonths = months % 12;
      final yearsLabel = years == 1 ? 'año' : 'años';
      final monthsLabel = remainingMonths == 1 ? 'mes' : 'meses';
      return remainingMonths == 0
          ? '$years $yearsLabel'
          : '$years $yearsLabel y $remainingMonths $monthsLabel';
    }
  }

  /// Determina la categoría de nutrición basada en la edad.
  /// Esto replica la lógica de la app ALMA del MINSA.
  String get nutritionCategory {
    final months = ageInMonths;
    if (months < 6) return 'Lactancia Exclusiva';
    if (months >= 6 && months <= 8) return '6 a 8 meses (Papillas)';
    if (months >= 9 && months <= 11) return '9 a 11 meses (Picados)';
    if (months >= 12 && months <= 23) return '12 a 23 meses (Olla familiar)';
    return 'Escolar (Alimentación completa)';
  }
}
