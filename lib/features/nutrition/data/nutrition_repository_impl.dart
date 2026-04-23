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
      ingredients: [
        '2 cucharadas de sangrecita cocida',
        '3 cucharadas de papa sancochada',
        '1 cucharadita de aceite vegetal',
      ],
      preparationSteps: [
        'Tritura la papa hasta lograr una base suave.',
        'Integra la sangrecita bien cocida y mezcla de forma homogénea.',
        'Añade el aceite y sirve tibio.',
      ],
      ironContribution: 'Aporte alto de hierro hemínico para prevenir anemia.',
    ),
    Recipe(
      id: '2',
      title: 'Puré de Hígado con Zanahoria',
      description: 'Suave y dulce, perfecto para la digestión del bebé en sus primeros meses comiendo sólidos.',
      imageUrl: 'assets/images/higado.png',
      ironContent: 12,
      targetAge: AgeCategory.papillas, // 6 a 8 meses
      ingredients: [
        '2 cucharadas de hígado de pollo cocido',
        '2 cucharadas de zanahoria sancochada',
        '2 cucharadas de zapallo sancochado',
      ],
      preparationSteps: [
        'Licua o aplasta los ingredientes cocidos hasta obtener un puré espeso.',
        'Rectifica la textura con agua hervida tibia si es necesario.',
        'Servir de inmediato.',
      ],
      ironContribution: 'Buena opción para introducir hierro y vitamina A.',
    ),
    Recipe(
      id: '3',
      title: 'Picadito de Bazo con Lentejas',
      description: 'Textura ideal para aprender a masticar. Alto impacto contra la anemia.',
      imageUrl: 'assets/images/bazo.png',
      ironContent: 18,
      targetAge: AgeCategory.picados, // 9 a 11 meses
      ingredients: [
        '2 cucharadas de bazo cocido y picado',
        '3 cucharadas de lentejas cocidas',
        '1 cucharada de cebolla cocida picada',
      ],
      preparationSteps: [
        'Saltea la cebolla cocida con una gota de aceite.',
        'Agrega el bazo y las lentejas, mezcla 2 minutos.',
        'Sirve en trozos pequeños según tolerancia.',
      ],
      ironContribution: 'Combinación densa en hierro para reforzar reservas.',
    ),
    Recipe(
      id: '4',
      title: 'Guiso familiar con Pescado Oscuro',
      description: 'El niño ya puede comer de la olla familiar. El bonito o jurel son excelentes opciones.',
      imageUrl: 'assets/images/pescado.png',
      ironContent: 10,
      targetAge: AgeCategory.ollaFamiliar, // 12 a 23 meses
      ingredients: [
        '1 filete pequeño de bonito o jurel',
        '2 cucharadas de verduras cocidas picadas',
        '3 cucharadas de arroz o papa sancochada',
      ],
      preparationSteps: [
        'Cocina el pescado completamente y retira espinas.',
        'Mezcla con verduras y arroz/papa de la olla familiar.',
        'Ofrece en trozos pequeños y blandos.',
      ],
      ironContribution: 'Aporta hierro y proteína de alta calidad.',
    ),
    Recipe(
      id: '5',
      title: 'Arroz tapado con hígado y lentejas',
      description: 'Receta para niños con buena aceptación. Acompaña con ensalada de tomate para sumar vitamina C.',
      imageUrl: 'assets/images/arroz_tapado.png',
      ironContent: 14,
      targetAge: AgeCategory.escolar, // 24+ meses
      ingredients: [
        '2 cucharadas de hígado de pollo picado',
        '2 cucharadas de lentejas cocidas',
        '4 cucharadas de arroz cocido',
      ],
      preparationSteps: [
        'Sofríe el hígado picado hasta cocción completa.',
        'Integra lentejas y condimentos suaves.',
        'Arma capas con arroz y relleno antes de servir.',
      ],
      ironContribution: 'Receta práctica para niños con mejor masticación.',
    ),
    Recipe(
      id: '6',
      title: 'Tortilla de sangrecita con quinua',
      description: 'Opción práctica para lonchera o cena, con hierro de alta biodisponibilidad.',
      imageUrl: 'assets/images/tortilla_sangrecita.png',
      ironContent: 16,
      targetAge: AgeCategory.escolar, // 24+ meses
      ingredients: [
        '2 cucharadas de sangrecita cocida picada',
        '1 huevo',
        '2 cucharadas de quinua cocida',
      ],
      preparationSteps: [
        'Bate el huevo e incorpora sangrecita y quinua.',
        'Cocina en sartén antiadherente a fuego bajo por ambos lados.',
        'Sirve en porciones pequeñas.',
      ],
      ironContribution: 'Excelente aporte de hierro hemínico + energía.',
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
