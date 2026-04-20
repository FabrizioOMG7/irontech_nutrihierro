import 'package:flutter_test/flutter_test.dart';
import 'package:irontech_nutrihierro/core/models/user_combination.dart';
import 'package:irontech_nutrihierro/features/camera/data/datasources/local_user_combinations_datasource.dart';
import 'package:irontech_nutrihierro/features/camera/data/repositories/local_user_combinations_repository.dart';

void main() {
  group('LocalUserCombinationsRepository', () {
    final repository = LocalUserCombinationsRepository(
      datasource: LocalUserCombinationsDataSource(),
    );

    test('guarda y lista combinaciones por usuario', () async {
      const userId = 'user_1';
      final combination = UserCombination(
        id: 'combination_1',
        userId: userId,
        foodIds: ['food_1', 'food_2'],
        createdAt: DateTime(2026, 1, 1),
        note: 'Combinación de prueba',
      );

      await repository.save(combination);
      final records = await repository.getByUser(userId);

      expect(records, hasLength(1));
      expect(records.first.id, 'combination_1');
    });
  });
}
