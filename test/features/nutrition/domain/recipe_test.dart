import 'package:flutter_test/flutter_test.dart';
import 'package:irontech_nutrihierro/features/nutrition/domain/recipe.dart';

void main() {
  group('Recipe.getCategoryForMonths', () {
    test('returns lactanciaExclusiva for 0-5 months', () {
      expect(Recipe.getCategoryForMonths(0), AgeCategory.lactanciaExclusiva);
      expect(Recipe.getCategoryForMonths(5), AgeCategory.lactanciaExclusiva);
    });

    test('returns papillas for 6-8 months', () {
      expect(Recipe.getCategoryForMonths(6), AgeCategory.papillas);
      expect(Recipe.getCategoryForMonths(8), AgeCategory.papillas);
    });

    test('returns picados for 9-11 months', () {
      expect(Recipe.getCategoryForMonths(9), AgeCategory.picados);
      expect(Recipe.getCategoryForMonths(11), AgeCategory.picados);
    });

    test('returns ollaFamiliar for 12-23 months', () {
      expect(Recipe.getCategoryForMonths(12), AgeCategory.ollaFamiliar);
      expect(Recipe.getCategoryForMonths(23), AgeCategory.ollaFamiliar);
    });

    test('returns escolar for 24+ months', () {
      expect(Recipe.getCategoryForMonths(24), AgeCategory.escolar);
      expect(Recipe.getCategoryForMonths(36), AgeCategory.escolar);
    });
  });
}
