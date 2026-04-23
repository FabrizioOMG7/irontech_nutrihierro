import 'package:flutter_test/flutter_test.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/minsa_food_portion.dart';

void main() {
  test('catálogo MINSA tiene alimentos y valores exactos por porción', () {
    expect(minsaFoodPortions, hasLength(4));

    final byName = {for (final food in minsaFoodPortions) food.name: food.ironMgPerPortion};
    expect(byName['Sangrecita de pollo'], 8.0);
    expect(byName['Bazo de res'], 8.5);
    expect(byName['Hígado de pollo'], 2.5);
    expect(byName['Carnes rojas'], 0.6);
  });
}
