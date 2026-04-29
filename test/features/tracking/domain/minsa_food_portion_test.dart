import 'package:flutter_test/flutter_test.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/minsa_food_portion.dart';

void main() {
  test('catálogo MINSA tiene alimentos con múltiples opciones de medida o correctas', () {
    expect(minsaFoodPortions.length, greaterThan(20)); // Más de 20 alimentos

    // Verificar que la sangrecita de pollo existe y tiene una opcion
    final sangrecita = minsaFoodPortions.firstWhere(
      (f) => f.key == 'sangrecita_pollo',
    );
    expect(sangrecita.name, 'Sangrecita de pollo');
    expect(sangrecita.portions.length, 1);
    expect(sangrecita.defaultPortion.ironMg, 8.0);
    expect(sangrecita.description, isNotEmpty);

    // Verificar que la quinoa existe y tiene múltiples opciones
    final quinoa = minsaFoodPortions.firstWhere(
      (f) => f.key == 'quinua',
    );
    expect(quinoa.portions.length, greaterThan(1));
  });

  test('cada alimento tiene al menos una opción de medida', () {
    for (final food in minsaFoodPortions) {
      expect(food.portions, isNotEmpty);
      expect(food.defaultPortion.label, isNotEmpty);
      expect(food.defaultPortion.ironMg, greaterThan(0));
    }
  });
}
