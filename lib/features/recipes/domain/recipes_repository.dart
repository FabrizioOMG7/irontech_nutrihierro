import 'package:irontech_nutrihierro/core/models/food.dart';
import 'package:irontech_nutrihierro/core/models/recipe.dart';

abstract class RecipesRepository {
  Future<List<Food>> getFoodsCatalog();
  Future<List<Recipe>> getRecipesCatalog({String? targetStage});
}
