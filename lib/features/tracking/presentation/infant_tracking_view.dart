import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';
import 'package:irontech_nutrihierro/core/utils/date_formatters.dart';
import 'package:go_router/go_router.dart';
import 'package:irontech_nutrihierro/features/profile/domain/child.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/daily_record.dart';
import 'package:irontech_nutrihierro/features/tracking/presentation/providers/tracking_provider.dart';
import 'package:uuid/uuid.dart';

class InfantTrackingView extends ConsumerWidget {
  final Child child;
  final List<DailyRecord> records;
  final DateTime historyDate;

  const InfantTrackingView({
    super.key,
    required this.child,
    required this.records,
    required this.historyDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Buscar si ya hay un registro de gotas hoy
    final hasDropsToday = records.any((r) => r.sourceType == IronSourceType.supplement && r.description == 'Gotas de hierro');
    final guardianCard = ref.watch(supplementStreakProvider(child.id)).maybeWhen(
      data: (streak) => streak >= 7 ? _GuardianBadgeCard(streak: streak) : null,
      orElse: () => null,
    );

    if (child.ageInMonths == 0) {
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.sm),
        children: [
          _HeaderCard(childName: child.name, historyDate: historyDate),
          const SizedBox(height: AppSpacing.md),
          if (child.nextCredDate != null) ...[
            _CredReminderCard(nextCredDate: child.nextCredDate!),
            const SizedBox(height: AppSpacing.md),
          ],
          const _LactationReminderCard(),
          const SizedBox(height: AppSpacing.md),
          const _MotherDietCard(),
          const SizedBox(height: AppSpacing.md),
          _CountdownToSupplementCard(birthDate: child.birthDate),
          const SizedBox(height: AppSpacing.xl),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.sm),
      children: [
        _HeaderCard(childName: child.name, historyDate: historyDate),
        const SizedBox(height: AppSpacing.md),

        if (guardianCard != null) ...[
          guardianCard,
          const SizedBox(height: AppSpacing.md),
        ],

        // 1. Cita CRED
        if (child.nextCredDate != null) ...[
          _CredReminderCard(nextCredDate: child.nextCredDate!),
          const SizedBox(height: AppSpacing.md),
        ],

        // 2. Suplementación Preventiva
        _DropsChecklistCard(
          childId: child.id,
          hasDropsToday: hasDropsToday,
          selectedDate: historyDate,
          prescribedDose: child.prescribedDose,
          onViewCalendar: () {
            context.push('/tracking/infant-calendar');
          },
        ),
        const SizedBox(height: AppSpacing.md),

        // 3. Nutrición de la Madre
        const _MotherDietCard(),
        const SizedBox(height: AppSpacing.md),

        // 4. Signos de Alarma
        const _AlarmSignsCard(),
        const SizedBox(height: AppSpacing.md),

        // 4. Preparación para Alimentación Complementaria
        _CountdownToSolidsCard(birthDate: child.birthDate),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final String childName;
  final DateTime historyDate;

  const _HeaderCard({required this.childName, required this.historyDate});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary.withAlpha(15),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Guardián de Hierro - $childName',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 18),
                const SizedBox(width: AppSpacing.sm),
                Text(formatDateDdMmYyyy(historyDate)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CredReminderCard extends StatelessWidget {
  final DateTime nextCredDate;

  const _CredReminderCard({required this.nextCredDate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysLeft = nextCredDate.difference(DateTime.now()).inDays;

    return Card(
      color: theme.colorScheme.tertiaryContainer.withAlpha(80),
      child: ListTile(
        leading: const Icon(Icons.event_available, size: 36, color: Colors.indigo),
        title: const Text('Próxima Cita CRED'),
        subtitle: Text(
          'Programada para el ${formatDateDdMmYyyy(nextCredDate)}\n'
          '${daysLeft >= 0 ? 'Faltan $daysLeft días' : 'Cita pasada'}',
        ),
        isThreeLine: true,
      ),
    );
  }
}

class _DropsChecklistCard extends ConsumerWidget {
  final String childId;
  final bool hasDropsToday;
  final DateTime selectedDate;
  final String? prescribedDose;
  final VoidCallback onViewCalendar;

  const _DropsChecklistCard({
    required this.childId,
    required this.hasDropsToday,
    required this.selectedDate,
    this.prescribedDose,
    required this.onViewCalendar,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.water_drop, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Suplementación Preventiva',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'A partir de los 4 meses (o antes si fue prematuro), el MINSA recomienda suplementación de hierro diaria.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_month, color: AppColors.primary),
                  onPressed: onViewCalendar,
                  tooltip: 'Ver calendario de hábitos',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Colors.amber.withAlpha(20),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: Colors.amber.withAlpha(100)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 16, color: Colors.amber),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Esta dosis debe ser validada por tu pediatra. Nunca automediques a tu bebé.',
                      style: theme.textTheme.labelSmall?.copyWith(color: Colors.amber[900]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                side: BorderSide(
                  color: hasDropsToday ? AppColors.success : theme.colorScheme.outlineVariant,
                ),
              ),
              tileColor: hasDropsToday ? AppColors.success.withAlpha(20) : null,
              leading: Icon(
                hasDropsToday ? Icons.check_circle : Icons.circle_outlined,
                color: hasDropsToday ? AppColors.success : theme.colorScheme.onSurfaceVariant,
                size: 32,
              ),
              title: Text(prescribedDose?.isNotEmpty == true
                  ? 'Hoy: $prescribedDose'
                  : 'Dosis no configurada (Click en perfil)'),
              subtitle: Text(hasDropsToday ? '¡Excelente! Dosis completada.' : 'Marcar al administrar.'),
              onTap: hasDropsToday ? null : () async {
                final normalizedDate = _recordDateForSelection(selectedDate);
                final record = DailyRecord(
                  id: const Uuid().v4(),
                  childId: childId,
                  date: normalizedDate,
                  sourceType: IronSourceType.supplement,
                  description: prescribedDose?.isNotEmpty == true ? prescribedDose! : 'Gotas de hierro',
                  wasAccepted: true,
                  ironMg: 0.0, // Solo tracking de hábito, no de miligramos
                );
                await ref.read(trackingControllerProvider.notifier).addRecord(record);
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '💡 Recuerda: Dar 1 hora antes o después de la leche (para que el calcio no bloquee el hierro).',
              style: theme.textTheme.labelSmall?.copyWith(color: Colors.grey[700], fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}

class _LactationReminderCard extends StatelessWidget {
  const _LactationReminderCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primaryContainer.withAlpha(60),
      child: ListTile(
        leading: const Icon(Icons.child_friendly, size: 36),
        title: const Text('Lactancia materna'),
        subtitle: const Text(
          'Prioriza la lactancia exclusiva a libre demanda para fortalecer las defensas y reservas de hierro.',
        ),
      ),
    );
  }
}

class _MotherDietCard extends StatelessWidget {
  const _MotherDietCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.secondaryContainer.withAlpha(100),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.pregnant_woman),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Nutrición para Mamá',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Durante la lactancia exclusiva, el bebé obtiene sus nutrientes de ti. Tu alimentación es clave.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Consume alimentos ricos en hierro animal (sangrecita, hígado, bazo) al menos 3 veces por semana, acompañados siempre de vitamina C (limonada, naranjada) para mejorar su absorción. Evita tomar infusiones (té, manzanilla, anís) o lácteos junto con tus comidas principales.',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[800]),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _TipChip(label: 'Sangrecita'),
                _TipChip(label: 'Hígado'),
                _TipChip(label: 'Bazo'),
                _TipChip(label: 'Pescados oscuros'),
                _TipChip(label: 'Cítricos (Vitamina C)'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TipChip extends StatelessWidget {
  final String label;
  const _TipChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Theme.of(context).colorScheme.surface,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _GuardianBadgeCard extends StatelessWidget {
  final int streak;

  const _GuardianBadgeCard({required this.streak});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.secondaryContainer.withAlpha(90),
      child: ListTile(
        leading: const Icon(Icons.emoji_events, color: Colors.amber, size: 36),
        title: const Text('Medalla de Guardián'),
        subtitle: Text('¡$streak días seguidos registrando la dosis!'),
      ),
    );
  }
}

class _AlarmSignsCard extends StatelessWidget {
  const _AlarmSignsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.visibility, color: Colors.deepOrange),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Signos de Alarma (Anemia)',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'La anemia puede ser silenciosa. Revisa regularmente:',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(Icons.remove_red_eye_outlined), // Placeholder image
              ),
              title: const Text('Ojos (Conjuntiva)'),
              subtitle: const Text('Baja suavemente el párpado inferior. Si está pálido o blanco en lugar de rosado/rojo, acude al centro de salud.'),
            ),
            const Divider(),
            ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(Icons.back_hand_outlined), // Placeholder image
              ),
              title: const Text('Palma de las manos'),
              subtitle: const Text('Compara sus palmas con las tuyas. Una palidez excesiva puede ser un indicador.'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CountdownToSolidsCard extends StatelessWidget {
  final DateTime birthDate;

  const _CountdownToSolidsCard({required this.birthDate});

  @override
  Widget build(BuildContext context) {
    final sixMonthsDate = _addMonths(birthDate, 6);
    final daysLeft = sixMonthsDate.difference(DateTime.now()).inDays;
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.tertiaryContainer.withAlpha(100),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Preparación para los 6 meses',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              daysLeft > 0
                  ? 'Faltan $daysLeft días para el inicio de la alimentación complementaria.'
                  : '¡Es hora de empezar con las papillas!',
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'A los 6 meses, las reservas de hierro del bebé se agotan. Las primeras comidas (papillas) deben incluir alimentos ricos en hierro como el hígado o sangrecita.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CountdownToSupplementCard extends StatelessWidget {
  final DateTime birthDate;

  const _CountdownToSupplementCard({required this.birthDate});

  @override
  Widget build(BuildContext context) {
    final fourMonthsDate = _addMonths(birthDate, 4);
    final daysLeft = fourMonthsDate.difference(DateTime.now()).inDays;
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.tertiaryContainer.withAlpha(100),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Inicio de hierro preventivo',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              daysLeft > 0
                  ? 'Faltan $daysLeft días para iniciar las gotas de hierro.'
                  : '¡Es momento de iniciar las gotas de hierro según indicación médica!',
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Consulta con tu pediatra para definir la dosis exacta según el MINSA.',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

DateTime _recordDateForSelection(DateTime selectedDate) {
  final now = DateTime.now();
  final isSameDay = selectedDate.year == now.year &&
      selectedDate.month == now.month &&
      selectedDate.day == now.day;
  return isSameDay
      ? now
      : DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
}

DateTime _addMonths(DateTime date, int monthsToAdd) {
  final totalMonths = date.month - 1 + monthsToAdd;
  final newYear = date.year + totalMonths ~/ 12;
  final newMonth = totalMonths % 12 + 1;
  final lastDayOfMonth = DateTime(newYear, newMonth + 1, 0).day;
  final newDay = date.day <= lastDayOfMonth ? date.day : lastDayOfMonth;
  return DateTime(newYear, newMonth, newDay);
}
