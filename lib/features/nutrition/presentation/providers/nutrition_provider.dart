import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/recipe.dart';
import '../../domain/nutrition_repository.dart';
import '../../data/nutrition_repository_impl.dart';

// 1. Proveemos el Repositorio
// ¡OJO AQUÍ! Cuando tengamos Firebase, la ÚNICA línea que cambiaremos en toda la app será esta:
final nutritionRepositoryProvider = Provider<NutritionRepository>((ref) {
  return NutritionRepositoryImpl(); // Cambiaremos esto a NutritionFirebaseImpl() después
});

// 2. Proveemos las recetas filtradas por categoría usando "FutureProvider.family"
// "family" nos permite pasarle un parámetro (la categoría de edad) al provider.
final recipesByCategoryProvider = FutureProvider.family<List<Recipe>, AgeCategory>((ref, category) async {
  final repository = ref.watch(nutritionRepositoryProvider);
  return repository.getRecipesByCategory(category);
});