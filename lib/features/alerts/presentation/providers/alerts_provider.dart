import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:irontech_nutrihierro/features/alerts/domain/app_alert.dart';
import 'package:irontech_nutrihierro/features/profile/domain/child.dart';
import 'package:irontech_nutrihierro/features/profile/presentation/providers/profile_provider.dart';

final alertsProvider = StateNotifierProvider<AlertsNotifier, List<AppAlert>>(
  (ref) => AlertsNotifier(child: ref.watch(activeChildProvider)),
);

class AlertsNotifier extends StateNotifier<List<AppAlert>> {
  // Horarios base diarios pensados para mañana temprana.
  static const int _intakeReminderHour = 8;
  static const int _tipHour = 9;
  static const int _tipMinute = 30;

  AlertsNotifier({required Child? child, DateTime Function()? nowProvider})
      : _child = child,
        _nowProvider = nowProvider ?? DateTime.now,
        super(const []) {
    ensureDailyAlerts();
  }

  final Child? _child;
  final DateTime Function() _nowProvider;

  /// Regla mínima documentada:
  /// - Se crean alertas programáticas por día.
  /// - No se duplica una alerta del mismo tipo en la misma fecha.
  /// - Cada alerta inicia en "pendiente" (isRead=false) y puede marcarse como leída.
  void ensureDailyAlerts() {
    final child = _child;
    if (child == null) {
      state = const [];
      return;
    }

    final now = _nowProvider();
    final dayKey = _dateOnly(now);
    final reminderCopy = _reminderForAge(child.ageInMonths);
    final tipCopy = _tipForAge(child.ageInMonths);
    final candidates = <AppAlert>[
      AppAlert(
        id: _dailyAlertId(dayKey, AppAlertType.ironIntakeReminder),
        type: AppAlertType.ironIntakeReminder,
        title: reminderCopy.title,
        message: reminderCopy.message,
        createdAt: DateTime(
          dayKey.year,
          dayKey.month,
          dayKey.day,
          _intakeReminderHour,
        ),
      ),
      AppAlert(
        id: _dailyAlertId(dayKey, AppAlertType.nutritionTip),
        type: AppAlertType.nutritionTip,
        title: tipCopy.title,
        message: tipCopy.message,
        createdAt: DateTime(
          dayKey.year,
          dayKey.month,
          dayKey.day,
          _tipHour,
          _tipMinute,
        ),
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

class _AlertCopy {
  final String title;
  final String message;

  const _AlertCopy({required this.title, required this.message});
}

_AlertCopy _reminderForAge(int ageInMonths) {
  if (ageInMonths == 0) {
    return const _AlertCopy(
      title: 'Clampaje umbilical',
      message:
          'Si tu bebé es recién nacido, solicita el clampaje tardío del cordón para fortalecer sus reservas de hierro.',
    );
  }
  if (ageInMonths <= 3) {
    return const _AlertCopy(
      title: 'Lactancia exclusiva',
      message:
          'La leche materna es la base del hierro en esta etapa. Mantén lactancia a libre demanda.',
    );
  }
  if (ageInMonths < 6) {
    return const _AlertCopy(
      title: 'Suplementación preventiva',
      message:
          'Desde los 4 meses, el MINSA recomienda iniciar gotas de hierro diarias según indicación médica.',
    );
  }
  if (ageInMonths < 9) {
    return const _AlertCopy(
      title: 'Reservas agotadas',
      message:
          'A los 6 meses las reservas de hierro se agotan. Inicia comidas ricas en hierro con texturas suaves.',
    );
  }
  if (ageInMonths < 12) {
    return const _AlertCopy(
      title: 'Texturas picadas',
      message:
          'Ofrece alimentos picados finamente y legumbres bien cocidas para reforzar hierro.',
    );
  }
  return const _AlertCopy(
    title: 'Olla familiar',
    message:
        'Ya puede comer de la olla familiar con porciones blandas y ricas en hierro.',
  );
}

_AlertCopy _tipForAge(int ageInMonths) {
  if (ageInMonths <= 3) {
    return const _AlertCopy(
      title: 'Hierro para mamá',
      message:
          'Consume sangrecita, hígado o bazo 3 veces por semana para enriquecer tu leche.',
    );
  }
  if (ageInMonths < 6) {
    return const _AlertCopy(
      title: 'Preparación para hierro',
      message:
          'Continúa lactancia exclusiva y consulta con tu pediatra el inicio de gotas de hierro.',
    );
  }
  if (ageInMonths < 9) {
    return const _AlertCopy(
      title: 'Primeras papillas',
      message:
          'Incluye sangrecita o hígado bien cocidos en papillas y acompaña con vitamina C.',
    );
  }
  if (ageInMonths < 12) {
    return const _AlertCopy(
      title: 'Hierro y vitamina C',
      message:
          'Combina carnes o menestras bien cocidas con cítricos para mejorar la absorción.',
    );
  }
  return const _AlertCopy(
    title: 'Varía el menú',
    message:
        'Mantén menestras, carnes y verduras ricas en hierro dentro de la olla familiar.',
  );
}
