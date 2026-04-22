import 'package:flutter_test/flutter_test.dart';
import 'package:irontech_nutrihierro/features/nutrition/data/nutrition_repository_impl.dart';
import 'package:irontech_nutrihierro/features/nutrition/domain/recipe.dart';

void main() {
  group('NutritionRepositoryImpl', () {
    test('devuelve recetas para niños en categoría escolar', () async {
      final repository = NutritionRepositoryImpl();

      final recipes = await repository.getRecipesByCategory(AgeCategory.escolar);

      expect(recipes, isNotEmpty);
      expect(recipes.every((recipe) => recipe.targetAge == AgeCategory.escolar), isTrue);
    });
  });
}
