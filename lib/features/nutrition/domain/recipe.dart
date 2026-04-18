// lib/features/nutrition/domain/recipe.dart

/// Categorías de edad basadas en las recomendaciones del MINSA
enum AgeCategory {
  lactanciaExclusiva, // 0 - 5 meses
  papillas,           // 6 - 8 meses
  picados,            // 9 - 11 meses
  ollaFamiliar,       // 12 - 23 meses
  escolar             // 24+ meses
}

/// Entidad que representa un alimento o receta rica en hierro
class Recipe {
  final String id;
  final String title;
  final String description;
  final String imageUrl; // URL de la imagen en Firebase Storage o un asset local
  final int ironContent; // Miligramos de hierro aproximados (opcional, para UI)
  final AgeCategory targetAge; // A qué edad va dirigida esta receta

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ironContent,
    required this.targetAge,
  });

  // Lógica de negocio sencilla: ¿Esta receta es apta para un niño de X meses?
  // Usamos la misma lógica de clasificación que programaste en la clase Child.
  static AgeCategory getCategoryForMonths(int months) {
    if (months < 6) return AgeCategory.lactanciaExclusiva;
    if (months >= 6 && months <= 8) return AgeCategory.papillas;
    if (months >= 9 && months <= 11) return AgeCategory.picados;
    if (months >= 12 && months <= 23) return AgeCategory.ollaFamiliar;
    return AgeCategory.escolar;
  }
}