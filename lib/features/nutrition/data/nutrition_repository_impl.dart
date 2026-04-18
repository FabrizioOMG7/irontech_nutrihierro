import 'package:irontech_nutrihierro/features/nutrition/domain/nutrition_repository.dart';
import 'package:irontech_nutrihierro/features/nutrition/domain/recipe.dart';



/// Implementación temporal (Mock) para avanzar con la UI sin necesitar Firebase aún.
class NutritionRepositoryImpl implements NutritionRepository {
  
  // Nuestra "Base de datos" falsa (quemada en código)
  final List<Recipe> _mockDatabase = [
    Recipe(
      id: '1',
      title: 'Papilla de Sangrecita',
      description: 'Rica en hierro, ideal para empezar la alimentación complementaria. Combínala con un chorrito de limón.',
      imageUrl: 'assets/images/papilla.png', 
      ironContent: 15,
      targetAge: AgeCategory.papillas, // 6 a 8 meses
    ),
    Recipe(
      id: '2',
      title: 'Puré de Hígado con Zanahoria',
      description: 'Suave y dulce, perfecto para la digestión del bebé en sus primeros meses comiendo sólidos.',
      imageUrl: 'assets/images/higado.png',
      ironContent: 12,
      targetAge: AgeCategory.papillas, // 6 a 8 meses
    ),
    Recipe(
      id: '3',
      title: 'Picadito de Bazo con Lentejas',
      description: 'Textura ideal para aprender a masticar. Alto impacto contra la anemia.',
      imageUrl: 'assets/images/bazo.png',
      ironContent: 18,
      targetAge: AgeCategory.picados, // 9 a 11 meses
    ),
    Recipe(
      id: '4',
      title: 'Guiso familiar con Pescado Oscuro',
      description: 'El niño ya puede comer de la olla familiar. El bonito o jurel son excelentes opciones.',
      imageUrl: 'assets/images/pescado.png',
      ironContent: 10,
      targetAge: AgeCategory.ollaFamiliar, // 12 a 23 meses
    ),
  ];

  @override
  Future<List<Recipe>> getRecipesByCategory(AgeCategory category) async {
    // Simulamos un retraso de internet de 1 segundo para probar las animaciones de carga
    await Future.delayed(const Duration(seconds: 1));
    // Filtramos la lista para devolver solo las que coinciden con la edad
    return _mockDatabase.where((recipe) => recipe.targetAge == category).toList();
  }

  @override
  Future<List<Recipe>> getAllRecipes() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockDatabase;
  }
}