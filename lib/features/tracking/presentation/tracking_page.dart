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

const int _maxPortionQuantity = 10;
const double _stepperButtonSize = 36;

// ──────────────────────────────────────────────────────────────────────────────
// Helpers de categoría
// ──────────────────────────────────────────────────────────────────────────────
String _categoryLabel(FoodCategory cat) {
  switch (cat) {
    case FoodCategory.organosYSangre:
      return 'Órganos y sangre';
    case FoodCategory.carnesYAves:
      return 'Carnes y aves';
    case FoodCategory.legumbresYGranos:
      return 'Legumbres y granos';
    case FoodCategory.verdurasYOtros:
      return 'Verduras y otros';
  }
}

IconData _categoryIcon(FoodCategory cat) {
  switch (cat) {
    case FoodCategory.organosYSangre:
      return Icons.bloodtype_outlined;
    case FoodCategory.carnesYAves:
      return Icons.set_meal_outlined;
    case FoodCategory.legumbresYGranos:
      return Icons.grass_outlined;
    case FoodCategory.verdurasYOtros:
      return Icons.eco_outlined;
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Página principal
// ──────────────────────────────────────────────────────────────────────────────
class TrackingPage extends ConsumerStatefulWidget {
  const TrackingPage({super.key});

  @override
  ConsumerState<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends ConsumerState<TrackingPage> {
  DateTime _historyDate = DateTime.now();
  FoodCategory? _selectedCategory;

  /// Cantidad seleccionada por alimento (key = MinsaFoodPortion.key)
  final Map<String, int> _selectedQuantity = {};

  int _quantityFor(String key) => _selectedQuantity[key] ?? 1;

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

  DateTime _normalizedDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  Future<void> _addPortion({
    required String childId,
    required MinsaFoodPortion food,
    required DateTime selectedDate,
    required int quantity,
  }) async {
    final record = DailyRecord(
      id: const Uuid().v4(),
      childId: childId,
      date: _normalizedDate(selectedDate),
      sourceType: IronSourceType.food,
      description: food.name,
      wasAccepted: true,
      ironMg: food.defaultPortion.ironMg * quantity,
    );
    await ref.read(trackingControllerProvider.notifier).addRecord(record);
  }

  Map<String, int> _buildPortionCount(List<DailyRecord> records) {
    final map = <String, int>{};
    for (final record in records) {
      if (!record.wasAccepted) continue;
      map.update(record.description, (v) => v + 1, ifAbsent: () => 1);
    }
    return map;
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
              message:
                  'Elige un perfil para registrar y revisar su seguimiento.',
            );
          }

          final query =
              DailyRecordsQuery(childId: child.id, date: _historyDate);

          return ResponsiveContent(
            child: AsyncValueView(
              value: ref.watch(dailyRecordsProvider(query)),
              errorPrefix: 'Error al cargar registro',
              loadingMessage: 'Cargando historial por fecha...',
              dataBuilder: (records) {
                final goalIronMg =
                    estimatedDailyIronGoalMg(child.ageInMonths);
                final consumedIronMg = records.fold<double>(
                  0,
                  (sum, r) => sum + (r.wasAccepted ? r.ironMg : 0),
                );
                final portionsByFood = _buildPortionCount(records);

                // Agrupar alimentos por categoría
                final grouped =
                    <FoodCategory, List<MinsaFoodPortion>>{};
                for (final food in minsaFoodPortions) {
                  grouped
                      .putIfAbsent(food.category, () => [])
                      .add(food);
                }

                return ListView(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  children: [
                    // ── Cabecera ──────────────────────────────────
                    _HeaderCard(
                      childName: child.name,
                      historyDate: _historyDate,
                      onPickDate: _pickHistoryDate,
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // ── Progreso diario ───────────────────────────
                    _DailyIronProgressCard(
                      consumedIronMg: consumedIronMg,
                      goalIronMg: goalIronMg,
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // ── Catálogo por categoría ────────────────────
                    Text(
                      'Alimentos ricos en hierro',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),

                    // ── Selector de categoría (dropdown) ─────────
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .outlineVariant,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: DropdownButton<FoodCategory?>(
                        value: _selectedCategory,
                        isExpanded: true,
                        underline: const SizedBox(),
                        hint: const Text('Filtrar por categoría...'),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('Todas las categorías'),
                          ),
                          ...grouped.keys.map((category) =>
                              DropdownMenuItem(
                                value: category,
                                child: Row(
                                  children: [
                                    Icon(_categoryIcon(category), size: 18),
                                    const SizedBox(width: AppSpacing.sm),
                                    Text(_categoryLabel(category)),
                                  ],
                                ),
                              )),
                        ],
                        onChanged: (category) =>
                            setState(() => _selectedCategory = category),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // ── Alimentos filtrados por categoría ──────────
                    ...grouped.entries.expand((entry) sync* {
                      // Filtrar por categoría seleccionada
                      if (_selectedCategory != null &&
                          entry.key != _selectedCategory) {
                        return;
                      }

                      yield _CategoryHeader(category: entry.key);
                      for (final food in entry.value) {
                        final qty = _quantityFor(food.key);
                        yield _FoodPortionCard(
                          food: food,
                          quantity: qty,
                          portionsTodayCount:
                              portionsByFood[food.name] ?? 0,
                          isSaving: trackingState.isLoading,
                          onQuantityChanged: (newQty) => setState(
                              () => _selectedQuantity[food.key] = newQty),
                          onAddPortion: () => _addPortion(
                            childId: child.id,
                            food: food,
                            selectedDate: _historyDate,
                            quantity: qty,
                          ),
                        );
                      }
                      yield const SizedBox(height: AppSpacing.xs);
                    }),

                    // ── Aviso legal ───────────────────────────────
                    Card(
                      color: Theme.of(context)
                          .colorScheme
                          .secondaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_outline, size: 20),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                'Información educativa basada en guías del '
                                'MINSA. No reemplaza el control médico.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // ── Historial del día ─────────────────────────
                    if (records.isEmpty)
                      EmptyStateView(
                        icon: Icons.calendar_month,
                        title:
                            'Sin registros en ${formatDateDdMmYyyy(_historyDate)}',
                        message:
                            'Usa "Añadir" para registrar el consumo de hoy.',
                      )
                    else ...[
                      Text(
                        'Registros del día',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      for (final record in records)
                        _RecordTile(
                          record: record,
                          onDelete: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title:
                                    const Text('Eliminar registro'),
                                content: Text(
                                    '¿Deseas eliminar "${record.description}"?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(ctx, false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(ctx, true),
                                    child: const Text('Eliminar'),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed == true) {
                              await ref
                                  .read(trackingControllerProvider
                                      .notifier)
                                  .deleteRecord(record.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Registro eliminado correctamente.'),
                                    backgroundColor:
                                        AppColors.success,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                    ],
                    const SizedBox(height: AppSpacing.lg),
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

// ──────────────────────────────────────────────────────────────────────────────
// Cabecera: nombre del niño + selector de fecha
// ──────────────────────────────────────────────────────────────────────────────
class _HeaderCard extends StatelessWidget {
  final String childName;
  final DateTime historyDate;
  final VoidCallback onPickDate;

  const _HeaderCard({
    required this.childName,
    required this.historyDate,
    required this.onPickDate,
  });

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
              'Seguimiento de $childName',
              style: Theme.of(context).textTheme.titleLarge,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            InkWell(
              onTap: onPickDate,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 18),
                    const SizedBox(width: AppSpacing.sm),
                    Text(formatDateDdMmYyyy(historyDate)),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(Icons.arrow_drop_down, size: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Separador de categoría
// ──────────────────────────────────────────────────────────────────────────────
class _CategoryHeader extends StatelessWidget {
  final FoodCategory category;

  const _CategoryHeader({required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xs),
      child: Row(
        children: [
          Icon(
            _categoryIcon(category),
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            _categoryLabel(category),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Card de alimento — layout responsive mejorado con múltiples unidades
// ──────────────────────────────────────────────────────────────────────────────
class _FoodPortionCard extends StatefulWidget {
  final MinsaFoodPortion food;
  final int quantity;
  final int portionsTodayCount;
  final bool isSaving;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onAddPortion;

  const _FoodPortionCard({
    required this.food,
    required this.quantity,
    required this.portionsTodayCount,
    required this.isSaving,
    required this.onQuantityChanged,
    required this.onAddPortion,
  });

  @override
  State<_FoodPortionCard> createState() => _FoodPortionCardState();
}

class _FoodPortionCardState extends State<_FoodPortionCard> {
  late FoodPortionOption _selectedPortion;

  @override
  void initState() {
    super.initState();
    _selectedPortion = widget.food.defaultPortion;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ironTotal = _selectedPortion.ironMg * widget.quantity;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Nombre del alimento con descripción
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(15),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(
                    Icons.restaurant_menu,
                    size: 24,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.food.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.food.description != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          widget.food.description!,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Selector de unidad de medida (si hay múltiples opciones)
            if (widget.food.portions.length > 1) ...[
              Text(
                'Unidad de medida:',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.food.portions
                      .map((portion) => Padding(
                            padding: const EdgeInsets.only(right: AppSpacing.xs),
                            child: FilterChip(
                              selected: _selectedPortion == portion,
                              onSelected: (_) {
                                setState(() {
                                  _selectedPortion = portion;
                                  // Reset quantity cuando cambia la unidad
                                  widget.onQuantityChanged(1);
                                });
                              },
                              label: Text(portion.label),
                              backgroundColor:
                                  Theme.of(context).colorScheme.surface,
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ] else ...[
              Text(
                '${_selectedPortion.ironMg.toStringAsFixed(1)} mg / ${_selectedPortion.label}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // Cantidad + Hierro total
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cantidad:',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      _QuantityStepper(
                        quantity: widget.quantity,
                        onChanged: widget.onQuantityChanged,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Hierro aprox.',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(20),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: AppColors.primary.withAlpha(50),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${ironTotal.toStringAsFixed(1)} mg',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Botón añadir + badge porciones de hoy
            Row(
              children: [
                if (widget.portionsTodayCount > 0)
                  Chip(
                    avatar: const Icon(Icons.check_circle, size: 16),
                    label: Text('Hoy: ${widget.portionsTodayCount}'),
                    backgroundColor: Colors.green.withAlpha(25),
                    labelStyle: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: widget.isSaving ? null : widget.onAddPortion,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Registrar'),
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    backgroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Stepper +/-
// ──────────────────────────────────────────────────────────────────────────────
class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;

  const _QuantityStepper({required this.quantity, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: Icons.remove,
            onPressed:
                quantity > 1 ? () => onChanged(quantity - 1) : null,
          ),
          SizedBox(
            width: 40,
            child: Center(
              child: Text(
                '$quantity',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add,
            onPressed:
                quantity < _maxPortionQuantity ? () => onChanged(quantity + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _StepperButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _stepperButtonSize,
      height: _stepperButtonSize,
      child: IconButton.outlined(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
            minWidth: _stepperButtonSize, minHeight: _stepperButtonSize),
        iconSize: 18,
        icon: Icon(icon),
        onPressed: onPressed,
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Tile de registro histórico
// ──────────────────────────────────────────────────────────────────────────────
class _RecordTile extends StatelessWidget {
  final DailyRecord record;
  final VoidCallback onDelete;

  const _RecordTile({required this.record, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: ListTile(
        minVerticalPadding: AppSpacing.sm,
        leading: const Icon(Icons.check_circle, color: AppColors.success),
        title: Text(
          record.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${formatDateDdMmYyyy(record.date)} • '
          '${record.ironMg.toStringAsFixed(1)} mg',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: onDelete,
          tooltip: 'Eliminar registro',
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Card de progreso diario
// ──────────────────────────────────────────────────────────────────────────────
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
    final status =
        ironGoalStatus(consumedMg: consumedIronMg, goalMg: goalIronMg);
    final missing =
        ironMissingMg(consumedMg: consumedIronMg, goalMg: goalIronMg);

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
              'Consumido: ${consumedIronMg.toStringAsFixed(1)} mg  •  '
              'Meta: ${goalIronMg.toStringAsFixed(1)} mg',
            ),
            const SizedBox(height: AppSpacing.sm),
            LinearProgressIndicator(
                value: progress, color: color, minHeight: 8),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Estado: $label (${(progress * 100).toStringAsFixed(0)}%)',
              style:
                  TextStyle(color: color, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              missing <= 0
                  ? '¡Objetivo diario alcanzado! 🎉'
                  : 'Faltan ${missing.toStringAsFixed(1)} mg para cumplir la meta de hoy.',
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withAlpha(100),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withAlpha(75),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Meta según recomendaciones MINSA basada en la edad. Consulta con el pediatra si tienes dudas.',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
