import 'package:flutter_test/flutter_test.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/minsa_food_portion.dart';

void main() {
  test('catálogo MINSA tiene alimentos con múltiples opciones de medida', () {
    expect(minsaFoodPortions.length, greaterThan(20)); // Más de 20 alimentos

    // Verificar que la sangrecita de pollo existe y tiene múltiples opciones
    final sangrecita = minsaFoodPortions.firstWhere(
      (f) => f.key == 'sangrecita_pollo',
    );
    expect(sangrecita.name, 'Sangrecita de pollo');
    expect(sangrecita.portions.length, greaterThan(1));
    expect(sangrecita.defaultPortion.ironMg, 8.0);
    expect(sangrecita.description, isNotEmpty);
  });

  test('cada alimento tiene al menos una opción de medida', () {
    for (final food in minsaFoodPortions) {
      expect(food.portions, isNotEmpty);
      expect(food.defaultPortion.label, isNotEmpty);
      expect(food.defaultPortion.ironMg, greaterThan(0));
    }
  });
}
