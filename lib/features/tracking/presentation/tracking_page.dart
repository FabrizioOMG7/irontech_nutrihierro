import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';
import 'package:irontech_nutrihierro/core/utils/date_formatters.dart';
import 'package:irontech_nutrihierro/core/widgets/async_value_view.dart';
import 'package:irontech_nutrihierro/core/widgets/empty_state_view.dart';
import 'package:irontech_nutrihierro/core/widgets/responsive_content.dart';
import 'package:irontech_nutrihierro/features/profile/presentation/providers/profile_provider.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/daily_record.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/daily_records_query.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/iron_goal.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/minsa_food_portion.dart';
import 'package:irontech_nutrihierro/features/tracking/presentation/providers/tracking_provider.dart';
import 'package:uuid/uuid.dart';

class TrackingPage extends ConsumerStatefulWidget {
  const TrackingPage({super.key});

  @override
  ConsumerState<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends ConsumerState<TrackingPage> {
  DateTime _historyDate = DateTime.now();

  Future<void> _pickHistoryDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _historyDate,
      firstDate: DateTime(now.year - 1, 1, 1),
      lastDate: now,
    );

    if (picked != null) {
      setState(() => _historyDate = picked);
    }
  }

  DateTime _normalizedDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Future<void> _addPortion({
    required String childId,
    required MinsaFoodPortion food,
  }) async {
    final record = DailyRecord(
      id: const Uuid().v4(),
      childId: childId,
      date: _normalizedDate(_historyDate),
      sourceType: IronSourceType.food,
      description: food.name,
      wasAccepted: true,
      ironMg: food.ironMgPerPortion,
    );

    await ref.read(trackingControllerProvider.notifier).addRecord(record);
  }

  @override
  Widget build(BuildContext context) {
    final childrenAsync = ref.watch(childrenListProvider);
    final trackingState = ref.watch(trackingControllerProvider);

    ref.listen<AsyncValue<void>>(trackingControllerProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Porción registrada y guardada localmente.'),
            backgroundColor: AppColors.success,
          ),
        );
      } else if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo guardar la porción: ${next.error}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Seguimiento de hierro')),
      body: AsyncValueView(
        value: childrenAsync,
        errorPrefix: 'Error al cargar perfil',
        loadingMessage: 'Cargando perfiles...',
        dataBuilder: (children) {
          if (children.isEmpty) {
            return const EmptyStateView(
              icon: Icons.child_care,
              title: 'Necesitas un perfil para iniciar',
              message:
                  'Registra un niño/a y vuelve aquí para empezar el seguimiento diario.',
            );
          }

          final child = ref.watch(activeChildProvider);
          if (child == null) {
            return const EmptyStateView(
              icon: Icons.switch_account,
              title: 'Selecciona un perfil activo',
              message: 'Elige un perfil para registrar y revisar su seguimiento.',
            );
          }

          final query = DailyRecordsQuery(childId: child.id, date: _historyDate);

          return ResponsiveContent(
            child: AsyncValueView(
              value: ref.watch(dailyRecordsProvider(query)),
              errorPrefix: 'Error al cargar registro',
              loadingMessage: 'Cargando historial por fecha...',
              dataBuilder: (records) {
                final goalIronMg = estimatedDailyIronGoalMg(child.ageInMonths);
                final consumedIronMg = records.fold<double>(
                  0,
                  (sum, record) => sum + (record.wasAccepted ? record.ironMg : 0),
                );
                final portionsByFood = _buildPortionCount(records);

                return ListView(
                  children: [
                    Card(
                      color: Theme.of(context).colorScheme.primary.withAlpha(15),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Seguimiento diario de ${child.name}',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              onTap: _pickHistoryDate,
                              leading: const Icon(Icons.calendar_today_outlined),
                              title: const Text('Historial por fecha'),
                              subtitle: Text(formatDateDdMmYyyy(_historyDate)),
                              trailing: const Icon(Icons.arrow_drop_down),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _DailyIronProgressCard(
                      consumedIronMg: consumedIronMg,
                      goalIronMg: goalIronMg,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alimentos MINSA (2 cucharadas por porción)',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            for (final food in minsaFoodPortions)
                              _FoodPortionTile(
                                food: food,
                                currentPortions: portionsByFood[food.name] ?? 0,
                                isSaving: trackingState.isLoading,
                                onAddPortion: () => _addPortion(
                                  childId: child.id,
                                  food: food,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Card(
                      color: Theme.of(context).colorScheme.secondary.withAlpha(22),
                      child: const Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: Text(
                          'Información educativa basada en guías del MINSA. No reemplaza el control médico',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (records.isEmpty)
                      EmptyStateView(
                        icon: Icons.calendar_month,
                        title: 'Sin registros en ${formatDateDdMmYyyy(_historyDate)}',
                        message:
                            'Usa “Añadir porción” para empezar a registrar el consumo de hoy.',
                      )
                    else ...[
                      Text(
                        'Registros del día',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      for (final record in records) _RecordTile(record: record),
                    ],
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

Map<String, int> _buildPortionCount(List<DailyRecord> records) {
  final map = <String, int>{};
  for (final record in records) {
    if (!record.wasAccepted) continue;
    map.update(record.description, (value) => value + 1, ifAbsent: () => 1);
  }
  return map;
}

class _FoodPortionTile extends StatelessWidget {
  final MinsaFoodPortion food;
  final int currentPortions;
  final bool isSaving;
  final VoidCallback onAddPortion;

  const _FoodPortionTile({
    required this.food,
    required this.currentPortions,
    required this.isSaving,
    required this.onAddPortion,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.restaurant_menu, color: AppColors.primary),
        title: Text(food.name),
        subtitle: Text(
          '${food.ironMgPerPortion.toStringAsFixed(1)} mg por porción • Porciones hoy: $currentPortions',
        ),
        trailing: FilledButton.icon(
          onPressed: isSaving ? null : onAddPortion,
          icon: const Icon(Icons.add),
          label: const Text('Añadir porción'),
        ),
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  final DailyRecord record;

  const _RecordTile({required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        minVerticalPadding: AppSpacing.sm,
        leading: const Icon(Icons.check_circle, color: AppColors.success),
        title: Text(record.description),
        subtitle: Text(
          '${formatDateDdMmYyyy(record.date)} • ${record.ironMg.toStringAsFixed(1)} mg',
        ),
      ),
    );
  }
}

class _DailyIronProgressCard extends StatelessWidget {
  final double consumedIronMg;
  final double goalIronMg;

  const _DailyIronProgressCard({
    required this.consumedIronMg,
    required this.goalIronMg,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goalIronMg <= 0
        ? 1.0
        : (consumedIronMg / goalIronMg).clamp(0.0, 1.0).toDouble();
    final status = ironGoalStatus(consumedMg: consumedIronMg, goalMg: goalIronMg);
    final missing = ironMissingMg(consumedMg: consumedIronMg, goalMg: goalIronMg);

    final (label, color) = switch (status) {
      IronGoalStatus.low => ('Pendiente', AppColors.warning),
      IronGoalStatus.inProgress => ('En progreso', AppColors.info),
      IronGoalStatus.completed => ('Cumplido', AppColors.success),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meta diaria de hierro',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Consumido: ${consumedIronMg.toStringAsFixed(1)} mg • Meta: ${goalIronMg.toStringAsFixed(1)} mg',
            ),
            const SizedBox(height: AppSpacing.sm),
            LinearProgressIndicator(value: progress, color: color),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Estado: $label (${(progress * 100).toStringAsFixed(0)}%)',
              style: TextStyle(color: color, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              missing <= 0
                  ? '¡Objetivo diario alcanzado!'
                  : 'Faltan ${missing.toStringAsFixed(1)} mg para cumplir la meta de hoy.',
            ),
          ],
        ),
      ),
    );
  }
}
