import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/child.dart';
import '../../domain/repositories/profile_repository.dart';

//  1. Importamos tu nueva base de datos en RAM (Mock)
import '../../data/repositories/profile_repository_mock.dart'; 

//  2. Desconectamos Firebase y conectamos el Mock
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryMock(); // <-- ¡El Switch Mágico!
});

// =====================================================================
// De aquí hacia abajo TODO se mantiene exactamente igual. 
// Riverpod no sabe (ni le importa) que acabamos de cambiar la base de datos.
// =====================================================================

final childrenListProvider = AsyncNotifierProvider<ChildrenListNotifier, List<Child>>(() {
  return ChildrenListNotifier();
});

class ChildrenListNotifier extends AsyncNotifier<List<Child>> {
  @override
  Future<List<Child>> build() async {
    return ref.read(profileRepositoryProvider).getChildren();
  }

  Future<void> addChild(Child child) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(profileRepositoryProvider).saveChild(child);
      state = AsyncValue.data(await ref.read(profileRepositoryProvider).getChildren());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}