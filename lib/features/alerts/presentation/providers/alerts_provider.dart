import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:irontech_nutrihierro/features/alerts/domain/app_alert.dart';

final alertsProvider = StateNotifierProvider<AlertsNotifier, List<AppAlert>>(
  (ref) => AlertsNotifier(),
);

class AlertsNotifier extends StateNotifier<List<AppAlert>> {
  AlertsNotifier({DateTime Function()? nowProvider})
      : _nowProvider = nowProvider ?? DateTime.now,
        super(const []) {
    ensureDailyAlerts();
  }

  final DateTime Function() _nowProvider;

  /// Regla mínima documentada:
  /// - Se crean alertas programáticas por día.
  /// - No se duplica una alerta del mismo tipo en la misma fecha.
  /// - Cada alerta inicia en "pendiente" (isRead=false) y puede marcarse como leída.
  void ensureDailyAlerts() {
    final now = _nowProvider();
    final dayKey = _dateOnly(now);
    final candidates = <AppAlert>[
      AppAlert(
        id: _dailyAlertId(dayKey, AppAlertType.ironIntakeReminder),
        type: AppAlertType.ironIntakeReminder,
        title: 'Recordatorio diario de hierro',
        message: 'Hoy toca registrar una ingesta rica en hierro.',
        createdAt: DateTime(dayKey.year, dayKey.month, dayKey.day, 8),
      ),
      AppAlert(
        id: _dailyAlertId(dayKey, AppAlertType.nutritionTip),
        type: AppAlertType.nutritionTip,
        title: 'Tip diario de nutrición',
        message: 'Combina lentejas con cítricos para mejorar absorción.',
        createdAt: DateTime(dayKey.year, dayKey.month, dayKey.day, 9, 30),
      ),
    ];

    final existingIds = state.map((alert) => alert.id).toSet();
    final newAlerts = candidates
        .where((alert) => !existingIds.contains(alert.id))
        .toList(growable: false);

    if (newAlerts.isEmpty) return;
    final merged = [...state, ...newAlerts]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = merged;
  }

  void markAsRead(String alertId) {
    state = [
      for (final alert in state)
        if (alert.id == alertId) alert.copyWith(isRead: true) else alert,
    ];
  }

  void markAllAsRead() {
    state = [
      for (final alert in state) alert.copyWith(isRead: true),
    ];
  }

  void clearRead() {
    state = state.where((alert) => !alert.isRead).toList(growable: false);
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static String _dailyAlertId(DateTime day, AppAlertType type) {
    final month = day.month.toString().padLeft(2, '0');
    final dayPart = day.day.toString().padLeft(2, '0');
    return '${type.name}-${day.year}$month$dayPart';
  }
}
