import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:irontech_nutrihierro/features/profile/domain/child.dart';
import 'package:irontech_nutrihierro/features/profile/domain/repositories/profile_repository.dart';
import 'package:irontech_nutrihierro/features/profile/presentation/providers/profile_provider.dart';

class _ProfileRepositoryFake implements ProfileRepository {
  final List<Child> _children = [];

  @override
  Future<void> deleteChild(String id) async {
    _children.removeWhere((child) => child.id == id);
  }

  @override
  Future<List<Child>> getChildren() async {
    return List<Child>.unmodifiable(_children);
  }

  @override
  Future<void> saveChild(Child child) async {
    final index = _children.indexWhere((item) => item.id == child.id);
    if (index >= 0) {
      _children[index] = child;
      return;
    }
    _children.add(child);
  }
}

void main() {
  group('childrenListProvider', () {
    test('updateChild updates existing child profile data', () async {
      final repository = _ProfileRepositoryFake();
      final container = ProviderContainer(
        overrides: [
          profileRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final child = Child(
        id: 'child-1',
        name: 'Luna',
        birthDate: DateTime(2024, 1, 10),
        gender: Gender.female,
      );
      await container.read(childrenListProvider.notifier).addChild(child);

      final updated = Child(
        id: child.id,
        name: 'Luna María',
        birthDate: child.birthDate,
        gender: child.gender,
      );
      await container.read(childrenListProvider.notifier).updateChild(updated);

      final children = await container.read(childrenListProvider.future);
      expect(children, hasLength(1));
      expect(children.first.name, 'Luna María');
    });
  });
}
