import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';
import 'package:irontech_nutrihierro/core/utils/date_formatters.dart';
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

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.sm),
      children: [
        _HeaderCard(childName: child.name, historyDate: historyDate),
        const SizedBox(height: AppSpacing.md),

        // 1. Suplementación Preventiva
        _DropsChecklistCard(
          childId: child.id,
          hasDropsToday: hasDropsToday,
          selectedDate: historyDate,
        ),
        const SizedBox(height: AppSpacing.md),

        // 2. Nutrición de la Madre
        const _MotherDietCard(),
        const SizedBox(height: AppSpacing.md),

        // 3. Signos de Alarma
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

class _DropsChecklistCard extends ConsumerWidget {
  final String childId;
  final bool hasDropsToday;
  final DateTime selectedDate;

  const _DropsChecklistCard({
    required this.childId,
    required this.hasDropsToday,
    required this.selectedDate,
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
            Text(
              'A partir de los 4 meses (o antes si fue prematuro), el MINSA recomienda gotas de hierro diarias.',
              style: theme.textTheme.bodyMedium,
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
              title: const Text('Gotas de hierro'),
              subtitle: Text(hasDropsToday ? '¡Excelente! Dosis de hoy completada.' : 'Marcar al administrar la dosis de hoy.'),
              onTap: hasDropsToday ? null : () async {
                final normalizedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
                final record = DailyRecord(
                  id: const Uuid().v4(),
                  childId: childId,
                  date: normalizedDate,
                  sourceType: IronSourceType.supplement,
                  description: 'Gotas de hierro',
                  wasAccepted: true,
                  ironMg: 0.0, // Solo tracking de hábito, no de miligramos
                );
                await ref.read(trackingControllerProvider.notifier).addRecord(record);
              },
            ),
          ],
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
              'Durante la lactancia exclusiva, el bebé obtiene sus nutrientes de ti. ¡Asegúrate de consumir hierro!',
              style: theme.textTheme.bodyMedium,
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
                _TipChip(label: 'Limonada (Vitamina C)'),
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
    final sixMonthsDate = DateTime(birthDate.year, birthDate.month + 6, birthDate.day);
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
