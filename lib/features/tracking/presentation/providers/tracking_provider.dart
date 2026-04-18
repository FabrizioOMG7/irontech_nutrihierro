import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:irontech_nutrihierro/features/tracking/data/tracking_repository_mock.dart';
import '../../domain/daily_record.dart';
import '../../domain/tracking_repository.dart';

// 1. Proveemos el repositorio (Con el Switch Mágico preparado para Firebase)
final trackingRepositoryProvider = Provider<TrackingRepository>((ref) {
  return TrackingRepositoryMock(); 
});

// 2. Proveedor para leer los registros de un mes específico.
// Usamos "family" porque necesitamos pasarle 3 datos: ID del niño, mes y año.
final monthlyRecordsProvider = FutureProvider.family<List<DailyRecord>, Map<String, dynamic>>((ref, params) async {
  final repository = ref.watch(trackingRepositoryProvider);
  return repository.getRecordsForChildInMonth(
    params['childId'] as String,
    params['month'] as int,
    params['year'] as int,
  );
});

// 3. Notifier para guardar nuevos registros y refrescar el calendario
final trackingControllerProvider = AsyncNotifierProvider<TrackingController, void>(() {
  return TrackingController();
});

class TrackingController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addRecord(DailyRecord record) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(trackingRepositoryProvider).saveRecord(record);
      // Invalida el proveedor de lectura para que el calendario se vuelva a dibujar automáticamente
      ref.invalidate(monthlyRecordsProvider);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
