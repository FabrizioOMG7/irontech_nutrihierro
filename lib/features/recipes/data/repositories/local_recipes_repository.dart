import 'package:irontech_nutrihierro/core/models/food.dart';
import 'package:irontech_nutrihierro/core/models/recipe.dart';
import 'package:irontech_nutrihierro/features/recipes/data/datasources/local_recipes_datasource.dart';
import 'package:irontech_nutrihierro/features/recipes/domain/recipes_repository.dart';

class LocalRecipesRepository implements RecipesRepository {
  final LocalRecipesDataSource datasource;

  LocalRecipesRepository({required this.datasource});

  @override
  Future<List<Food>> getFoodsCatalog() {
    return datasource.getFoodsCatalog();
  }

  @override
  Future<List<Recipe>> getRecipesCatalog({String? targetStage}) async {
    final recipes = await datasource.getRecipesCatalog();
    if (targetStage == null || targetStage.isEmpty) {
      return recipes;
    }
    return recipes.where((recipe) => recipe.targetStage == targetStage).toList();
  }
}
