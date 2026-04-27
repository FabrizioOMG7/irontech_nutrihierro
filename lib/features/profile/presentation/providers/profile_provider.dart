import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/child.dart';
import '../../domain/repositories/profile_repository.dart';

//  1. Importamos tu nueva base de datos Isar
import '../../data/repositories/local_profile_repository_impl.dart';
import '../../../../main.dart'; // Para isarProvider

//  2. Desconectamos el Mock y conectamos Isar
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return LocalProfileRepositoryImpl(isar); // <-- ¡El Switch Mágico!
});

// =====================================================================
// De aquí hacia abajo TODO se mantiene exactamente igual. 
// Riverpod no sabe (ni le importa) que acabamos de cambiar la base de datos.
// =====================================================================

final childrenListProvider = AsyncNotifierProvider<ChildrenListNotifier, List<Child>>(() {
  return ChildrenListNotifier();
});

const String _activeChildStorageKey = 'active_child_id_v1';

final activeChildIdProvider = StateProvider<String?>((ref) => null);

final activeChildProvider = Provider<Child?>((ref) {
  final children = ref.watch(childrenListProvider).valueOrNull ?? const <Child>[];
  if (children.isEmpty) return null;
  final activeId = ref.watch(activeChildIdProvider);
  if (activeId == null || activeId.isEmpty) return children.first;
  for (final child in children) {
    if (child.id == activeId) return child;
  }
  return children.first;
});

Future<void> restoreActiveChildId(WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  ref.read(activeChildIdProvider.notifier).state = prefs.getString(_activeChildStorageKey);
}

Future<void> setActiveChildId(WidgetRef ref, String childId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_activeChildStorageKey, childId);
  ref.read(activeChildIdProvider.notifier).state = childId;
}

Future<void> clearActiveChildId(WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_activeChildStorageKey);
  ref.read(activeChildIdProvider.notifier).state = null;
}

class ChildrenListNotifier extends AsyncNotifier<List<Child>> {
  @override
  Future<List<Child>> build() async {
    return ref.read(profileRepositoryProvider).getChildren();
  }

  Future<void> addChild(Child child) async {
    await _saveChild(child);
  }

  Future<void> updateChild(Child child) async {
    await _saveChild(child);
  }

  Future<void> _saveChild(Child child) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(profileRepositoryProvider).saveChild(child);
      state = AsyncValue.data(await ref.read(profileRepositoryProvider).getChildren());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
