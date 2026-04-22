import 'package:flutter_test/flutter_test.dart';
import 'package:irontech_nutrihierro/features/profile/data/repositories/profile_repository_mock.dart';
import 'package:irontech_nutrihierro/features/profile/domain/child.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ProfileRepositoryMock', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('persiste perfiles entre instancias del repositorio', () async {
      final firstRepository = ProfileRepositoryMock();
      final child = Child(
        id: 'child-1',
        name: 'Valeria',
        birthDate: DateTime(2024, 1, 12),
        gender: Gender.female,
      );
      await firstRepository.saveChild(child);

      final secondRepository = ProfileRepositoryMock();
      final loaded = await secondRepository.getChildren();

      expect(loaded, hasLength(1));
      expect(loaded.first.id, child.id);
      expect(loaded.first.name, 'Valeria');
    });
  });
}
