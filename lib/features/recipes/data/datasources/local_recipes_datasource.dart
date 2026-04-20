import 'package:irontech_nutrihierro/core/models/food.dart';
import 'package:irontech_nutrihierro/core/models/recipe.dart';

class LocalRecipesDataSource {
  Future<List<Food>> getFoodsCatalog() async {
    return const [
      Food(
        id: 'food_1',
        name: 'Sangrecita',
        description: 'Fuente alta de hierro hemo.',
        ironMgPer100g: 29,
        imageAsset: 'assets/images/sangrecita.png',
      ),
      Food(
        id: 'food_2',
        name: 'Hígado de pollo',
        description: 'Muy recomendado para prevenir anemia infantil.',
        ironMgPer100g: 9,
        imageAsset: 'assets/images/higado_pollo.png',
      ),
      Food(
        id: 'food_3',
        name: 'Lentejas',
        description: 'Hierro no hemo y fibra.',
        ironMgPer100g: 3.3,
        imageAsset: 'assets/images/lentejas.png',
      ),
    ];
  }

  Future<List<Recipe>> getRecipesCatalog() async {
    return const [
      Recipe(
        id: 'recipe_1',
        title: 'Papilla de sangrecita',
        description: 'Receta para etapa papillas.',
        foodIds: ['food_1'],
        preparationSteps: [
          'Cocinar la sangrecita completamente.',
          'Licuar con una porción de verduras.',
          'Servir tibio.',
        ],
        imageAsset: 'assets/images/papilla.png',
        targetStage: 'papillas',
      ),
      Recipe(
        id: 'recipe_2',
        title: 'Picado de hígado con lentejas',
        description: 'Receta para etapa picados.',
        foodIds: ['food_2', 'food_3'],
        preparationSteps: [
          'Cocinar hígado y lentejas por separado.',
          'Picar en trozos pequeños.',
          'Mezclar y servir.',
        ],
        imageAsset: 'assets/images/picado_higado_lentejas.png',
        targetStage: 'picados',
      ),
    ];
  }
}
