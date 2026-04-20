import 'package:flutter_test/flutter_test.dart';
import 'package:irontech_nutrihierro/features/recipes/data/datasources/local_recipes_datasource.dart';
import 'package:irontech_nutrihierro/features/recipes/data/repositories/local_recipes_repository.dart';

void main() {
  group('LocalRecipesRepository', () {
    final repository = LocalRecipesRepository(
      datasource: LocalRecipesDataSource(),
    );

    test('retorna catálogo de alimentos mock', () async {
      final foods = await repository.getFoodsCatalog();
      expect(foods, isNotEmpty);
    });

    test('filtra recetas por etapa cuando se envía targetStage', () async {
      final recipes = await repository.getRecipesCatalog(targetStage: 'papillas');
      expect(recipes, isNotEmpty);
      expect(recipes.every((item) => item.targetStage == 'papillas'), isTrue);
    });
  });
}
