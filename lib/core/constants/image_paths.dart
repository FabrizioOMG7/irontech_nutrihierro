/// lib/core/constants/image_paths.dart
/// 
/// Constantes centralizadas para todas las rutas de imágenes del proyecto.
/// Evita hardcodear rutas en múltiples lugares.

class ImagePaths {
  // ============== RUTAS BASE ==============
  static const String _recipesBase = 'assets/images/recipes';
  static const String _infoBase = 'assets/images/info';

  // ============== CATEGORÍAS DE RECETAS (por edad) ==============
  /// Imágenes para bebés en lactancia exclusiva (0-5 meses)
  static const String recipeAgeCategoriasLactancia =
      '$_recipesBase/age_lactancia';

  /// Imágenes para inicio de papillas (6-8 meses)
  static const String recipeAgeCategoriasPapillas = '$_recipesBase/age_papillas';

  /// Imágenes para alimentos picados (9-11 meses)
  static const String recipeAgeCategoriasPicados = '$_recipesBase/age_picados';

  /// Imágenes para olla familiar (12-23 meses)
  static const String recipeAgeCategoriasOllaFamiliar =
      '$_recipesBase/age_olla_familiar';

  /// Imágenes para niños en edad escolar (24+ meses)
  static const String recipeAgeCategoriasEscolar =
      '$_recipesBase/age_escolar';

  // ============== CATEGORÍAS DE INFORMACIÓN ==============
  /// Imágenes sobre síntomas de anemia infantil
  static const String infoSymptoms = '$_infoBase/symptoms';

  /// Imágenes sobre estrategias de prevención
  static const String infoPrevention = '$_infoBase/prevention';

  /// Imágenes sobre guías nutricionales
  static const String infoNutrition = '$_infoBase/nutrition';

  /// Imágenes sobre beneficios de alimentos específicos
  static const String infoBenefits = '$_infoBase/benefits';

  // ============== MÉTODOS AUXILIARES ==============
  
  /// Obtiene la ruta de categoría de receta basada en la edad en meses
  /// 
  /// Ejemplo: getRecipeCategoryPath(7) -> 'assets/images/recipes/age_papillas'
  static String getRecipeCategoryPath(int months) {
    if (months < 6) return recipeAgeCategoriasLactancia;
    if (months >= 6 && months <= 8) return recipeAgeCategoriasPapillas;
    if (months >= 9 && months <= 11) return recipeAgeCategoriasPicados;
    if (months >= 12 && months <= 23) return recipeAgeCategoriasOllaFamiliar;
    return recipeAgeCategoriasEscolar;
  }

  /// Construye la ruta completa de una imagen de receta
  /// 
  /// Ejemplo: buildRecipePath('papillas', 'puré_manzana.png')
  /// Retorna: 'assets/images/recipes/age_papillas/puré_manzana.png'
  static String buildRecipePath(String category, String filename) {
    return '$_recipesBase/$category/$filename';
  }

  /// Construye la ruta completa de una imagen de información
  /// 
  /// Ejemplo: buildInfoPath('symptoms', 'palidez.png')
  /// Retorna: 'assets/images/info/symptoms/palidez.png'
  static String buildInfoPath(String subcategory, String filename) {
    return '$_infoBase/$subcategory/$filename';
  }

  /// Verifica si una ruta es un asset local o una URL remota
  /// 
  /// Retorna true si es un asset local (comienza con 'assets/')
  static bool isLocalAsset(String imagePath) {
    return imagePath.startsWith('assets/');
  }
}
