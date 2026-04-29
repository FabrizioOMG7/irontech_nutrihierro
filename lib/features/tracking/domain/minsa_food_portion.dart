enum FoodCategory { organosYSangre, carnesYAves, legumbresYGranos, verdurasYOtros }

/// Opción de medida para un alimento
/// Ej: '2 cdas (30g)' con 8.0 mg de hierro, o '100g' con 26.7 mg
class FoodPortionOption {
  final String label; // '2 cdas (30g)' o '100g' o '1 porción'
  final double ironMg; // Hierro en mg para esa medida

  const FoodPortionOption({
    required this.label,
    required this.ironMg,
  });
}

class MinsaFoodPortion {
  final String key;
  final String name;
  final List<FoodPortionOption> portions; // Múltiples opciones de medida
  final FoodCategory category;
  final String? description; // Beneficios adicionales

  /// Obtener la porción recomendada (la primera en la lista)
  FoodPortionOption get defaultPortion => portions.first;

  /// Alias de compatibilidad. Preferir [defaultPortion] en código nuevo.
  @Deprecated('Usar defaultPortion en su lugar.')
  double get ironMgPerUnit => defaultPortion.ironMg;

  /// Alias de compatibilidad.
  @Deprecated('Usar defaultPortion en su lugar.')
  String get unit => defaultPortion.label;

  const MinsaFoodPortion({
    required this.key,
    required this.name,
    required this.portions,
    this.category = FoodCategory.carnesYAves,
    this.description,
  });

  /// Constructor simplificado para alimentos con una sola opción de medida
  /// (para retrocompatibilidad)
  factory MinsaFoodPortion.single({
    required String key,
    required String name,
    required double ironMgPerUnit,
    required String unit,
    FoodCategory category = FoodCategory.carnesYAves,
    String? description,
  }) {
    return MinsaFoodPortion(
      key: key,
      name: name,
      portions: [FoodPortionOption(label: unit, ironMg: ironMgPerUnit)],
      category: category,
      description: description,
    );
  }
}

const List<MinsaFoodPortion> minsaFoodPortions = [
  // ── ÓRGANOS Y SANGRE (Altísimo contenido de hierro) ────────────────────────
  MinsaFoodPortion(
    key: 'sangrecita_pollo',
    name: 'Sangrecita de pollo',
    portions: [
      FoodPortionOption(label: '2 cdas (30 g)', ironMg: 8.0),
    ],
    category: FoodCategory.organosYSangre,
    description: 'Excelente fuente de hierro hemínico. Ideal para anemia.',
  ),
  MinsaFoodPortion(
    key: 'sangrecita_res',
    name: 'Sangrecita de res',
    portions: [
      FoodPortionOption(label: '2 cdas (30 g)', ironMg: 9.0),
    ],
    category: FoodCategory.organosYSangre,
    description: 'Mayor concentración de hierro que la de pollo.',
  ),
  MinsaFoodPortion(
    key: 'bazo_res',
    name: 'Bazo de res',
    portions: [
      FoodPortionOption(label: '2 cdas (30 g)', ironMg: 8.5),
    ],
    category: FoodCategory.organosYSangre,
    description: 'Muy rico en hierro y vitaminas.',
  ),
  MinsaFoodPortion(
    key: 'higado_res',
    name: 'Hígado de res',
    portions: [
      FoodPortionOption(label: '1 porción (30 g)', ironMg: 5.8),
    ],
    category: FoodCategory.organosYSangre,
    description: 'Rico en hierro y vitamina A.',
  ),
  MinsaFoodPortion(
    key: 'higado_pollo',
    name: 'Hígado de pollo',
    portions: [
      FoodPortionOption(label: '1 porción (30 g)', ironMg: 2.5),
    ],
    category: FoodCategory.organosYSangre,
    description: 'Buena fuente de hierro y proteína.',
  ),
  MinsaFoodPortion(
    key: 'rinon_res',
    name: 'Riñón de res',
    portions: [
      FoodPortionOption(label: '1 porción (30 g)', ironMg: 4.0),
    ],
    category: FoodCategory.organosYSangre,
    description: 'Buena fuente de hierro hemínico.',
  ),
  MinsaFoodPortion(
    key: 'corazon_res',
    name: 'Corazón de res',
    portions: [
      FoodPortionOption(label: '1 porción (30 g)', ironMg: 4.2),
    ],
    category: FoodCategory.organosYSangre,
    description: 'Proteína magra con buen contenido de hierro.',
  ),
  
  // ── CARNES Y AVES ────────────────────────────────────────────────────────
  MinsaFoodPortion(
    key: 'carne_res',
    name: 'Carne de res',
    portions: [
      FoodPortionOption(label: '1 porción (30 g)', ironMg: 0.9),
      FoodPortionOption(label: '100 g', ironMg: 3.0),
    ],
    category: FoodCategory.carnesYAves,
    description: 'Hierro hemínico de buena biodisponibilidad.',
  ),
  MinsaFoodPortion(
    key: 'pollo_muslo',
    name: 'Pollo (muslo)',
    portions: [
      FoodPortionOption(label: '1 porción (30 g)', ironMg: 0.5),
      FoodPortionOption(label: '100 g', ironMg: 1.7),
    ],
    category: FoodCategory.carnesYAves,
    description: 'Más hierro que la pechuga. Proteína de calidad.',
  ),
  MinsaFoodPortion(
    key: 'pollo_pechuga',
    name: 'Pollo (pechuga)',
    portions: [
      FoodPortionOption(label: '1 porción (30 g)', ironMg: 0.3),
      FoodPortionOption(label: '100 g', ironMg: 1.0),
    ],
    category: FoodCategory.carnesYAves,
    description: 'Proteína magra con bajo contenido de hierro.',
  ),
  MinsaFoodPortion(
    key: 'pavo',
    name: 'Pavo',
    portions: [
      FoodPortionOption(label: '1 porción (30 g)', ironMg: 1.0),
      FoodPortionOption(label: '100 g', ironMg: 3.3),
    ],
    category: FoodCategory.carnesYAves,
    description: 'Buena alternativa a pollo con más hierro.',
  ),
  MinsaFoodPortion(
    key: 'atun_lata',
    name: 'Atún en lata (al agua)',
    portions: [
      FoodPortionOption(label: '½ lata (40 g)', ironMg: 1.3),
      FoodPortionOption(label: '1 lata (80 g)', ironMg: 2.6),
      FoodPortionOption(label: '100 g', ironMg: 3.3),
    ],
    category: FoodCategory.carnesYAves,
    description: 'Pescado rico en proteína y omega-3.',
  ),
  MinsaFoodPortion(
    key: 'sardinas',
    name: 'Sardinas en lata',
    portions: [
      FoodPortionOption(label: '1 porción (50 g)', ironMg: 2.9),
      FoodPortionOption(label: '100 g', ironMg: 5.8),
    ],
    category: FoodCategory.carnesYAves,
    description: 'Muy rico en hierro, omega-3 y calcio.',
  ),
  MinsaFoodPortion(
    key: 'anchoveta',
    name: 'Anchoveta',
    portions: [
      FoodPortionOption(label: '1 porción (50 g)', ironMg: 3.2),
      FoodPortionOption(label: '100 g', ironMg: 6.4),
    ],
    category: FoodCategory.carnesYAves,
    description: 'Pescado peruano rico en hierro y omega-3.',
  ),
  MinsaFoodPortion(
    key: 'trucha',
    name: 'Trucha',
    portions: [
      FoodPortionOption(label: '1 porción (100 g)', ironMg: 1.2),
      FoodPortionOption(label: '200 g', ironMg: 2.4),
    ],
    category: FoodCategory.carnesYAves,
    description: 'Pescado de agua dulce con proteína de calidad.',
  ),
  MinsaFoodPortion(
    key: 'almejas',
    name: 'Almejas',
    portions: [
      FoodPortionOption(label: '6 unidades (80 g)', ironMg: 12.0),
      FoodPortionOption(label: '100 g', ironMg: 15.0),
    ],
    category: FoodCategory.carnesYAves,
    description: 'Marisco con altísimo contenido de hierro.',
  ),
  MinsaFoodPortion(
    key: 'mejillones',
    name: 'Mejillones',
    portions: [
      FoodPortionOption(label: '1 porción (100 g)', ironMg: 6.7),
      FoodPortionOption(label: '200 g', ironMg: 13.4),
    ],
    category: FoodCategory.carnesYAves,
    description: 'Marisco nutritivo con buen contenido de hierro.',
  ),
  MinsaFoodPortion(
    key: 'ostras',
    name: 'Ostras',
    portions: [
      FoodPortionOption(label: '6 unidades (85 g)', ironMg: 10.2),
      FoodPortionOption(label: '100 g', ironMg: 12.0),
    ],
    category: FoodCategory.carnesYAves,
    description: 'Marisco premium con hierro y minerales.',
  ),
  
  // ── LEGUMBRES, GRANOS Y SEMILLAS ────────────────────────────────────────
  MinsaFoodPortion(
    key: 'lentejas',
    name: 'Lentejas cocidas',
    portions: [
      FoodPortionOption(label: '3 cdas (50 g)', ironMg: 1.5),
      FoodPortionOption(label: '1 taza (200 g)', ironMg: 6.0),
      FoodPortionOption(label: '100 g', ironMg: 3.0),
    ],
    category: FoodCategory.legumbresYGranos,
    description: 'Rica en hierro no hemínico y fibra. Combinar con ácido ascórbico.',
  ),
  MinsaFoodPortion(
    key: 'frejol_negro',
    name: 'Frijol negro cocido',
    portions: [
      FoodPortionOption(label: '3 cdas (50 g)', ironMg: 1.8),
      FoodPortionOption(label: '1 taza (200 g)', ironMg: 7.2),
      FoodPortionOption(label: '100 g', ironMg: 3.6),
    ],
    category: FoodCategory.legumbresYGranos,
    description: 'Excelente fuente de proteína y hierro vegetal.',
  ),
  MinsaFoodPortion(
    key: 'frejol_blanco',
    name: 'Frijol blanco cocido',
    portions: [
      FoodPortionOption(label: '3 cdas (50 g)', ironMg: 1.6),
      FoodPortionOption(label: '1 taza (200 g)', ironMg: 6.4),
      FoodPortionOption(label: '100 g', ironMg: 3.2),
    ],
    category: FoodCategory.legumbresYGranos,
    description: 'Buena fuente proteica con hierro.',
  ),
  MinsaFoodPortion(
    key: 'garbanzos',
    name: 'Garbanzos cocidos',
    portions: [
      FoodPortionOption(label: '3 cdas (50 g)', ironMg: 1.8),
      FoodPortionOption(label: '1 taza (240 g)', ironMg: 8.6),
      FoodPortionOption(label: '100 g', ironMg: 3.6),
    ],
    category: FoodCategory.legumbresYGranos,
    description: 'Alta en proteína, hierro y vitamina B.',
  ),
  MinsaFoodPortion(
    key: 'soya',
    name: 'Soya cocida',
    portions: [
      FoodPortionOption(label: '½ taza (90 g)', ironMg: 6.1),
      FoodPortionOption(label: '1 taza (180 g)', ironMg: 12.2),
      FoodPortionOption(label: '100 g', ironMg: 6.8),
    ],
    category: FoodCategory.legumbresYGranos,
    description: 'Proteína vegetal completa con excelente contenido de hierro.',
  ),
  MinsaFoodPortion(
    key: 'pallar',
    name: 'Jurel',
    portions: [
      FoodPortionOption(label: '1 porción (80 g)', ironMg: 2.4),
      FoodPortionOption(label: '100 g', ironMg: 3.0),
    ],
    category: FoodCategory.legumbresYGranos,
    description: 'Pescado graso muy nutritivo.',
  ),
  MinsaFoodPortion(
    key: 'quinua',
    name: 'Quinua cocida',
    portions: [
      FoodPortionOption(label: '3 cdas (50 g)', ironMg: 1.4),
      FoodPortionOption(label: '1 taza (200 g)', ironMg: 5.6),
      FoodPortionOption(label: '100 g', ironMg: 2.8),
    ],
    category: FoodCategory.legumbresYGranos,
    description: 'Pseudocereal andino con proteína completa.',
  ),
  MinsaFoodPortion(
    key: 'kiwicha',
    name: 'Kiwicha cocida',
    portions: [
      FoodPortionOption(label: '3 cdas (50 g)', ironMg: 2.0),
      FoodPortionOption(label: '1 taza (200 g)', ironMg: 8.0),
      FoodPortionOption(label: '100 g', ironMg: 4.0),
    ],
    category: FoodCategory.legumbresYGranos,
    description: 'Grano andino alto en hierro y minerales.',
  ),
  MinsaFoodPortion(
    key: 'trigo_grano',
    name: 'Grano de trigo cocido',
    portions: [
      FoodPortionOption(label: '½ taza (100 g)', ironMg: 2.6),
      FoodPortionOption(label: '1 taza (200 g)', ironMg: 5.2),
    ],
    category: FoodCategory.legumbresYGranos,
    description: 'Grano integral con buen contenido de hierro.',
  ),
  MinsaFoodPortion(
    key: 'semilla_calabaza',
    name: 'Semillas de calabaza',
    portions: [
      FoodPortionOption(label: '2 cdas (28 g)', ironMg: 4.2),
      FoodPortionOption(label: '100 g', ironMg: 15.0),
    ],
    category: FoodCategory.legumbresYGranos,
    description: 'Muy rico en hierro, zinc y magnesio. Excelente snack.',
  ),
  MinsaFoodPortion(
    key: 'semilla_girasol',
    name: 'Semillas de girasol',
    portions: [
      FoodPortionOption(label: '2 cdas (28 g)', ironMg: 2.4),
      FoodPortionOption(label: '100 g', ironMg: 8.6),
    ],
    category: FoodCategory.legumbresYGranos,
    description: 'Buena fuente de hierro y vitamina E.',
  ),
  
  // ── VERDURAS Y OTROS ────────────────────────────────────────────────────
  MinsaFoodPortion(
    key: 'espinaca',
    name: 'Espinaca cocida',
    portions: [
      FoodPortionOption(label: '2 cdas (30 g)', ironMg: 1.7),
      FoodPortionOption(label: '½ taza (100 g)', ironMg: 5.7),
      FoodPortionOption(label: '1 taza (200 g)', ironMg: 11.4),
    ],
    category: FoodCategory.verdurasYOtros,
    description: 'Rica en hierro no hemínico. Combina con vitamina C.',
  ),
  MinsaFoodPortion(
    key: 'acelga',
    name: 'Acelga cocida',
    portions: [
      FoodPortionOption(label: '2 cdas (30 g)', ironMg: 0.9),
      FoodPortionOption(label: '½ taza (100 g)', ironMg: 3.0),
      FoodPortionOption(label: '1 taza (200 g)', ironMg: 6.0),
    ],
    category: FoodCategory.verdurasYOtros,
    description: 'Verde nutritiva con buena cantidad de hierro.',
  ),
  MinsaFoodPortion(
    key: 'berza',
    name: 'Berza cocida',
    portions: [
      FoodPortionOption(label: '2 cdas (30 g)', ironMg: 0.7),
      FoodPortionOption(label: '½ taza (100 g)', ironMg: 2.3),
      FoodPortionOption(label: '1 taza (200 g)', ironMg: 4.6),
    ],
    category: FoodCategory.verdurasYOtros,
    description: 'Col nutritiva con calcio y hierro.',
  ),
  MinsaFoodPortion(
    key: 'beterraga',
    name: 'Betarraga cocida',
    portions: [
      FoodPortionOption(label: '2 cdas (30 g)', ironMg: 0.8),
      FoodPortionOption(label: '½ taza (100 g)', ironMg: 2.7),
      FoodPortionOption(label: '1 taza (200 g)', ironMg: 5.4),
    ],
    category: FoodCategory.verdurasYOtros,
    description: 'Raíz dulce con hierro y folato.',
  ),
  MinsaFoodPortion(
    key: 'brocoli',
    name: 'Brócoli cocido',
    portions: [
      FoodPortionOption(label: '½ taza (90 g)', ironMg: 1.2),
      FoodPortionOption(label: '1 taza (180 g)', ironMg: 2.4),
      FoodPortionOption(label: '100 g', ironMg: 1.3),
    ],
    category: FoodCategory.verdurasYOtros,
    description: 'Crucífera con hierro y vitamina C que favorece absorción.',
  ),
  MinsaFoodPortion(
    key: 'champiñon',
    name: 'Champiñones cocidos',
    portions: [
      FoodPortionOption(label: '½ taza (35 g)', ironMg: 0.8),
      FoodPortionOption(label: '1 taza (70 g)', ironMg: 1.6),
      FoodPortionOption(label: '100 g', ironMg: 2.3),
    ],
    category: FoodCategory.verdurasYOtros,
    description: 'Hongo con hierro y minerales.',
  ),
];
