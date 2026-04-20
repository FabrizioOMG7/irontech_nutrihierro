import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:irontech_nutrihierro/features/alerts/domain/app_alert.dart';

final alertsProvider = StateNotifierProvider<AlertsNotifier, List<AppAlert>>(
  (ref) => AlertsNotifier(),
);

class AlertsNotifier extends StateNotifier<List<AppAlert>> {
  AlertsNotifier() : super(_initialAlerts);

  static final List<AppAlert> _initialAlerts = [
    AppAlert(
      id: 'alert_1',
      title: 'Recordatorio de hierro',
      message: 'Hoy toca registrar una ingesta rica en hierro.',
      createdAt: DateTime(2026, 4, 20, 8, 0),
    ),
    AppAlert(
      id: 'alert_2',
      title: 'Tip nutricional',
      message: 'Combina lentejas con cítricos para mejorar absorción.',
      createdAt: DateTime(2026, 4, 19, 9, 30),
    ),
    AppAlert(
      id: 'alert_3',
      title: 'Seguimiento semanal',
      message: 'Revisa el registro diario para completar la semana.',
      createdAt: DateTime(2026, 4, 18, 19, 0),
    ),
  ];

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
}
