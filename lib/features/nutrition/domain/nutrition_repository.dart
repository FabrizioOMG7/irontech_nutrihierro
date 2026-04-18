import 'recipe.dart';

/// Contrato que define cómo la aplicación obtendrá los alimentos recomendados.
/// Nuevamente, aquí no nos importa si vienen de Firebase, de una API o de una lista local.
abstract class NutritionRepository {
  
  /// Obtiene la lista de recetas específicas para la etapa de desarrollo del niño.
  Future<List<Recipe>> getRecipesByCategory(AgeCategory category);

  /// Obtiene una lista de todos los alimentos disponibles (útil para un buscador futuro).
  Future<List<Recipe>> getAllRecipes();
}