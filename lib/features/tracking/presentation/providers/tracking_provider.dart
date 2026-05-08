import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:irontech_nutrihierro/features/tracking/data/repositories/local_tracking_repository_impl.dart';
import '../../domain/daily_record.dart';
import '../../domain/daily_records_query.dart';
import '../../domain/monthly_records_query.dart';
import '../../domain/tracking_repository.dart';
import '../../../../main.dart'; // Para isarProvider

// 1. Proveemos el repositorio (Con el Switch Mágico apuntando a Isar)
final trackingRepositoryProvider = Provider<TrackingRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return LocalTrackingRepositoryImpl(isar);
});

// 2. Proveedor para leer los registros de un mes específico.
// Usamos "family" porque necesitamos pasarle 3 datos: ID del niño, mes y año.
final monthlyRecordsProvider = FutureProvider.family<List<DailyRecord>, MonthlyRecordsQuery>((ref, query) async {
  final repository = ref.watch(trackingRepositoryProvider);
  return repository.getRecordsForChildInMonth(query);
});

final dailyRecordsProvider = FutureProvider.family<List<DailyRecord>, DailyRecordsQuery>((ref, query) async {
  final repository = ref.watch(trackingRepositoryProvider);
  return repository.getRecordsForChildInDate(query);
});

final supplementStreakProvider = FutureProvider.family<int, String>((ref, childId) async {
  final repository = ref.watch(trackingRepositoryProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final startDate = today.subtract(const Duration(days: 6));

  final queries = <MonthlyRecordsQuery>[
    MonthlyRecordsQuery(childId: childId, month: today.month, year: today.year),
  ];
  if (startDate.month != today.month || startDate.year != today.year) {
    queries.add(
      MonthlyRecordsQuery(childId: childId, month: startDate.month, year: startDate.year),
    );
  }

  final records = <DailyRecord>[];
  for (final query in queries) {
    records.addAll(await repository.getRecordsForChildInMonth(query));
  }

  final supplementDays = <String>{};
  for (final record in records) {
    if (record.sourceType != IronSourceType.supplement) continue;
    if (!record.wasAccepted) continue;
    final date = DateTime(record.date.year, record.date.month, record.date.day);
    supplementDays.add(_formatDateKey(date));
  }

  var streak = 0;
  for (var i = 0; i < 7; i++) {
    final date = today.subtract(Duration(days: i));
    if (supplementDays.contains(_formatDateKey(date))) {
      streak += 1;
    } else {
      break;
    }
  }

  return streak;
});

String _formatDateKey(DateTime date) => '${date.year}-${date.month}-${date.day}';

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
      ref.invalidate(dailyRecordsProvider);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteRecord(String recordId) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(trackingRepositoryProvider).deleteRecord(recordId);
      // Invalida los proveedores para refrescar la UI
      ref.invalidate(monthlyRecordsProvider);
      ref.invalidate(dailyRecordsProvider);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteRecords(List<String> recordIds) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(trackingRepositoryProvider);
      for (final id in recordIds) {
        await repository.deleteRecord(id);
      }
      ref.invalidate(monthlyRecordsProvider);
      ref.invalidate(dailyRecordsProvider);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
