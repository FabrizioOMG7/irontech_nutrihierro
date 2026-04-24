enum FoodCategory { organosYSangre, carnesYAves, legumbresYGranos, verdurasYOtros }

class MinsaFoodPortion {
  final String key;
  final String name;
  final double ironMgPerUnit;
  final String unit;
  final FoodCategory category;

  /// Alias de compatibilidad. Preferir [ironMgPerUnit] en código nuevo.
  @Deprecated('Usar ironMgPerUnit en su lugar.')
  double get ironMgPerPortion => ironMgPerUnit;

  /// Alias de compatibilidad. Preferir [unit] en código nuevo.
  @Deprecated('Usar unit en su lugar.')
  String get portionReference => unit;

  const MinsaFoodPortion({
    required this.key,
    required this.name,
    required this.ironMgPerUnit,
    required this.unit,
    this.category = FoodCategory.carnesYAves,
  });
}

const List<MinsaFoodPortion> minsaFoodPortions = [
  // ── Órganos y sangre ────────────────────────────────────────────────────
  MinsaFoodPortion(
    key: 'sangrecita_pollo',
    name: 'Sangrecita de pollo',
    ironMgPerUnit: 8.0,
    unit: '2 cdas (30 g)',
    category: FoodCategory.organosYSangre,
  ),
  MinsaFoodPortion(
    key: 'bazo_res',
    name: 'Bazo de res',
    ironMgPerUnit: 8.5,
    unit: '2 cdas (30 g)',
    category: FoodCategory.organosYSangre,
  ),
  MinsaFoodPortion(
    key: 'higado_pollo',
    name: 'Hígado de pollo',
    ironMgPerUnit: 2.5,
    unit: '1 porción (30 g)',
    category: FoodCategory.organosYSangre,
  ),
  MinsaFoodPortion(
    key: 'higado_res',
    name: 'Hígado de res',
    ironMgPerUnit: 5.8,
    unit: '1 porción (30 g)',
    category: FoodCategory.organosYSangre,
  ),
  MinsaFoodPortion(
    key: 'rinon_res',
    name: 'Riñón de res',
    ironMgPerUnit: 4.0,
    unit: '1 porción (30 g)',
    category: FoodCategory.organosYSangre,
  ),
  // ── Carnes y aves ────────────────────────────────────────────────────────
  MinsaFoodPortion(
    key: 'carne_res',
    name: 'Carne de res',
    ironMgPerUnit: 0.9,
    unit: '1 porción (30 g)',
    category: FoodCategory.carnesYAves,
  ),
  MinsaFoodPortion(
    key: 'pollo',
    name: 'Pollo (muslo/pechuga)',
    ironMgPerUnit: 0.4,
    unit: '1 porción (30 g)',
    category: FoodCategory.carnesYAves,
  ),
  MinsaFoodPortion(
    key: 'atun_lata',
    name: 'Atún en lata',
    ironMgPerUnit: 1.3,
    unit: '½ lata (40 g)',
    category: FoodCategory.carnesYAves,
  ),
  MinsaFoodPortion(
    key: 'sardinas',
    name: 'Sardinas',
    ironMgPerUnit: 2.9,
    unit: '1 porción (50 g)',
    category: FoodCategory.carnesYAves,
  ),
  // ── Legumbres y granos ───────────────────────────────────────────────────
  MinsaFoodPortion(
    key: 'lentejas',
    name: 'Lentejas cocidas',
    ironMgPerUnit: 1.5,
    unit: '3 cdas (50 g)',
    category: FoodCategory.legumbresYGranos,
  ),
  MinsaFoodPortion(
    key: 'frejol_negro',
    name: 'Frijol negro cocido',
    ironMgPerUnit: 1.8,
    unit: '3 cdas (50 g)',
    category: FoodCategory.legumbresYGranos,
  ),
  MinsaFoodPortion(
    key: 'quinua',
    name: 'Quinua cocida',
    ironMgPerUnit: 1.4,
    unit: '3 cdas (50 g)',
    category: FoodCategory.legumbresYGranos,
  ),
  MinsaFoodPortion(
    key: 'kiwicha',
    name: 'Kiwicha cocida',
    ironMgPerUnit: 2.0,
    unit: '3 cdas (50 g)',
    category: FoodCategory.legumbresYGranos,
  ),
  // ── Verduras y otros ────────────────────────────────────────────────────
  MinsaFoodPortion(
    key: 'espinaca',
    name: 'Espinaca cocida',
    ironMgPerUnit: 1.7,
    unit: '2 cdas (30 g)',
    category: FoodCategory.verdurasYOtros,
  ),
  MinsaFoodPortion(
    key: 'beterraga',
    name: 'Betarraga cocida',
    ironMgPerUnit: 0.8,
    unit: '2 cdas (30 g)',
    category: FoodCategory.verdurasYOtros,
  ),
];
