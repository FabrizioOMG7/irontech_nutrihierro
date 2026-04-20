import 'package:flutter_test/flutter_test.dart';
import 'package:irontech_nutrihierro/features/profile/domain/child.dart';

DateTime _birthDateMonthsAgo(int monthsAgo) {
  final now = DateTime.now();
  var year = now.year;
  var month = now.month - monthsAgo;
  while (month <= 0) {
    month += 12;
    year -= 1;
  }
  return DateTime(year, month, 1);
}

void main() {
  group('Child domain logic', () {
    test('ageInMonths calculates expected age in months', () {
      final child = Child(
        id: '1',
        name: 'Ana',
        birthDate: _birthDateMonthsAgo(8),
        gender: Gender.female,
      );

      expect(child.ageInMonths, 8);
    });

    test('formattedAge returns months for children under one year', () {
      final child = Child(
        id: '1',
        name: 'Leo',
        birthDate: _birthDateMonthsAgo(5),
        gender: Gender.male,
      );

      expect(child.formattedAge, '5 meses');
    });

    test('formattedAge returns years and months for older children', () {
      final child = Child(
        id: '1',
        name: 'Mia',
        birthDate: _birthDateMonthsAgo(14),
        gender: Gender.female,
      );

      expect(child.formattedAge, '1 año y 2 meses');
    });

    test('nutritionCategory follows expected age boundaries', () {
      final child = Child(
        id: '1',
        name: 'Kai',
        birthDate: _birthDateMonthsAgo(10),
        gender: Gender.female,
      );

      expect(child.nutritionCategory, '9 a 11 meses (Picados)');
    });
  });
}
