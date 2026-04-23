class MinsaFoodPortion {
  final String key;
  final String name;
  final double ironMgPerPortion;

  const MinsaFoodPortion({
    required this.key,
    required this.name,
    required this.ironMgPerPortion,
  });
}

const List<MinsaFoodPortion> minsaFoodPortions = [
  MinsaFoodPortion(
    key: 'sangrecita_pollo',
    name: 'Sangrecita de pollo',
    ironMgPerPortion: 8.0,
  ),
  MinsaFoodPortion(
    key: 'bazo_res',
    name: 'Bazo de res',
    ironMgPerPortion: 8.5,
  ),
  MinsaFoodPortion(
    key: 'higado_pollo',
    name: 'Hígado de pollo',
    ironMgPerPortion: 2.5,
  ),
  MinsaFoodPortion(
    key: 'carnes_rojas',
    name: 'Carnes rojas',
    ironMgPerPortion: 0.6,
  ),
];
