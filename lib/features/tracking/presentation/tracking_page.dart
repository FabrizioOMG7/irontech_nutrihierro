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

  Future<void> _openRecordForm(
    BuildContext context,
    WidgetRef ref,
    String childId,
    bool isSaving,
  ) async {
    if (isSaving) return;

    final formData = await showModalBottomSheet<_RecordFormData>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const _RecordFormSheet(),
    );

    if (formData == null) return;

    final newRecord = DailyRecord(
      id: const Uuid().v4(),
      childId: childId,
      date: formData.date,
      sourceType: formData.sourceType,
      description: formData.description,
      wasAccepted: formData.wasAccepted,
      ironMg: formData.ironMg,
    );

    await ref.read(trackingControllerProvider.notifier).addRecord(newRecord);
  }

  @override
  Widget build(BuildContext context) {
    final childrenAsync = ref.watch(childrenListProvider);
    final trackingState = ref.watch(trackingControllerProvider);

    ref.listen<AsyncValue<void>>(trackingControllerProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro guardado correctamente.'),
            backgroundColor: AppColors.success,
          ),
        );
      } else if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo guardar el registro: ${next.error}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Registro Diario')),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Theme.of(context).colorScheme.primary.withAlpha(15),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seguimiento de ${child.name}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          onTap: _pickHistoryDate,
                          leading: const Icon(Icons.calendar_today_outlined),
                          title: const Text('Ver historial por fecha'),
                          subtitle: Text(formatDateDdMmYyyy(_historyDate)),
                          trailing: const Icon(Icons.arrow_drop_down),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: AsyncValueView(
                    value: ref.watch(dailyRecordsProvider(query)),
                    errorPrefix: 'Error al cargar registro',
                    loadingMessage: 'Cargando registros de la fecha seleccionada...',
                    dataBuilder: (records) {
                      final consumedIronMg = records
                          .where((record) => record.wasAccepted)
                          .fold<double>(0, (sum, record) => sum + record.ironMg);
                      final dailyGoalMg = estimatedDailyIronGoalMg(
                        child.ageInMonths,
                      );
                      if (records.isEmpty) {
                        return ListView(
                          children: [
                            _DailyIronProgressCard(
                              consumedIronMg: consumedIronMg,
                              goalIronMg: dailyGoalMg,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            EmptyStateView(
                              icon: Icons.calendar_month,
                              title:
                                  'Sin registros en ${formatDateDdMmYyyy(_historyDate)}',
                              message:
                                  'Usa "Registrar ingesta" para guardar registros y consultarlos por fecha.',
                            ),
                          ],
                        );
                      }
                      return ListView(
                        children: [
                          _DailyIronProgressCard(
                            consumedIronMg: consumedIronMg,
                            goalIronMg: dailyGoalMg,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          for (final record in records) _RecordTile(record: record),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: childrenAsync.maybeWhen(
        data: (children) {
          final child = ref.watch(activeChildProvider);
          if (children.isEmpty || child == null) return null;
          return FloatingActionButton.extended(
            onPressed: () => _openRecordForm(
              context,
              ref,
              child.id,
              trackingState.isLoading,
            ),
            icon: const Icon(Icons.add),
            label: Text(
              trackingState.isLoading ? 'Guardando...' : 'Registrar ingesta',
            ),
          );
        },
        orElse: () => null,
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  final DailyRecord record;

  const _RecordTile({required this.record});

  @override
  Widget build(BuildContext context) {
    final accepted = record.wasAccepted;
    final statusColor = accepted ? AppColors.success : AppColors.warning;

    return Card(
      child: ListTile(
        minVerticalPadding: AppSpacing.sm,
        leading: Icon(
          record.sourceType == IronSourceType.food
              ? Icons.restaurant
              : Icons.local_hospital,
          color: AppColors.primary,
        ),
        title: Text(record.description),
        subtitle: Text(
          '${formatDateDdMmYyyy(record.date)} • ${_sourceLabel(record.sourceType)}${record.ironMg > 0 ? ' • ${record.ironMg.toStringAsFixed(1)} mg' : ''}',
        ),
        trailing: Icon(
          accepted ? Icons.check_circle : Icons.info_outline,
          color: statusColor,
        ),
      ),
    );
  }
}

String _sourceLabel(IronSourceType sourceType) {
  switch (sourceType) {
    case IronSourceType.food:
      return 'Alimento';
    case IronSourceType.supplement:
      return 'Suplemento';
  }
}

class _RecordFormData {
  final DateTime date;
  final IronSourceType sourceType;
  final String description;
  final bool wasAccepted;
  final double ironMg;

  const _RecordFormData({
    required this.date,
    required this.sourceType,
    required this.description,
    required this.wasAccepted,
    required this.ironMg,
  });
}

class _RecordFormSheet extends StatefulWidget {
  const _RecordFormSheet();

  @override
  State<_RecordFormSheet> createState() => _RecordFormSheetState();
}

class _RecordFormSheetState extends State<_RecordFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _quickNoteController = TextEditingController();
  final _customIronMgController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  IronSourceType _selectedSource = IronSourceType.food;
  bool _wasAccepted = true;
  String? _selectedPresetFoodOption;
  final Set<String> _selectedPresetFoods = <String>{};
  static const Map<String, double> _presetFoods = {
    'Sangrecita': 7.2,
    'Hígado de pollo': 5.8,
    'Bazo': 6.1,
    'Lentejas': 3.3,
    'Pescado': 1.4,
    'Espinaca': 2.7,
    'Quinua': 2.8,
  };

  @override
  void dispose() {
    _descriptionController.dispose();
    _quickNoteController.dispose();
    _customIronMgController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: monthStart,
      lastDate: now,
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _addPresetFoodSelection() {
    final selected = _selectedPresetFoodOption;
    if (selected == null) return;
    setState(() {
      _selectedPresetFoods.add(selected);
      _selectedPresetFoodOption = null;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final manualDescription = _descriptionController.text.trim();
    final quickNote = _quickNoteController.text.trim();
    final customIronMg = double.tryParse(
          _customIronMgController.text.trim().replaceAll(',', '.'),
        ) ??
        0;
    final descriptionParts = <String>[];
    final ironFromPresetFoods = _selectedPresetFoods.fold<double>(
      0,
      (sum, food) => sum + (_presetFoods[food] ?? 0),
    );
    final totalEstimatedIronMg = ironFromPresetFoods + customIronMg;

    if (_selectedSource == IronSourceType.food && _selectedPresetFoods.isNotEmpty) {
      descriptionParts.add('Alimentos seleccionados: ${_selectedPresetFoods.join(', ')}');
    }
    if (manualDescription.isNotEmpty) {
      descriptionParts.add(manualDescription);
    }
    if (quickNote.isNotEmpty) {
      descriptionParts.add('Nota/cantidad: $quickNote');
    }

    Navigator.of(context).pop(
        _RecordFormData(
          date: _selectedDate,
          sourceType: _selectedSource,
          description: descriptionParts.join(' • '),
          wasAccepted: _wasAccepted,
          ironMg: totalEstimatedIronMg,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        bottomInset + AppSpacing.md,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nueva ingesta',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              Card(
                child: ListTile(
                  onTap: _pickDate,
                  leading: const Icon(Icons.calendar_today_outlined),
                  title: const Text('Fecha de registro'),
                  subtitle: Text(formatDateDdMmYyyy(_selectedDate)),
                  trailing: const Icon(Icons.arrow_drop_down),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Tipo de ingesta',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.sm),
              SegmentedButton<IronSourceType>(
                segments: const [
                  ButtonSegment<IronSourceType>(
                    value: IronSourceType.food,
                    icon: Icon(Icons.restaurant),
                    label: Text('Alimento'),
                  ),
                  ButtonSegment<IronSourceType>(
                    value: IronSourceType.supplement,
                    icon: Icon(Icons.local_hospital),
                    label: Text('Suplemento'),
                  ),
                ],
                selected: {_selectedSource},
                onSelectionChanged: (selected) {
                  if (selected.isNotEmpty) {
                    setState(() {
                      _selectedSource = selected.first;
                      if (_selectedSource == IronSourceType.supplement) {
                        _selectedPresetFoods.clear();
                        _selectedPresetFoodOption = null;
                        _quickNoteController.clear();
                      }
                    });
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),
              if (_selectedSource == IronSourceType.food) ...[
                const Text(
                  'Alimentos predeterminados',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedPresetFoodOption,
                        hint: const Text('Selecciona un alimento'),
                        items: _presetFoods
                            .keys
                            .map(
                              (food) => DropdownMenuItem<String>(
                                value: food,
                                child: Text(food),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: (value) =>
                            setState(() => _selectedPresetFoodOption = value),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    IconButton.filled(
                      onPressed: _selectedPresetFoodOption == null
                          ? null
                          : _addPresetFoodSelection,
                      icon: const Icon(Icons.add),
                      tooltip: 'Agregar alimento',
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (_selectedPresetFoods.isNotEmpty)
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: _selectedPresetFoods
                        .map(
                          (food) => InputChip(
                            label: Text(food),
                            onDeleted: () =>
                                setState(() => _selectedPresetFoods.remove(food)),
                          ),
                        )
                        .toList(growable: false),
                  ),
                const SizedBox(height: AppSpacing.md),
              ],
              TextFormField(
                controller: _customIronMgController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Hierro estimado adicional (mg)',
                  hintText: 'Ejemplo: 2.5',
                ),
                validator: (value) {
                  final raw = value?.trim() ?? '';
                  if (raw.isEmpty) return null;
                  final parsed = double.tryParse(raw.replaceAll(',', '.'));
                  if (parsed == null || parsed < 0) {
                    return 'Ingresa un número válido de mg';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _descriptionController,
                minLines: 2,
                maxLines: 3,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: _selectedSource == IronSourceType.food
                      ? 'Descripción manual (opcional)'
                      : 'Descripción',
                  hintText: _selectedSource == IronSourceType.food
                      ? 'Ejemplo: agregar arroz y zanahoria'
                      : 'Ejemplo: Sulfato ferroso, 10 gotas',
                ),
                validator: (value) {
                  final trimmed = value?.trim() ?? '';
                  if (_selectedSource == IronSourceType.food &&
                      _selectedPresetFoods.isNotEmpty &&
                      trimmed.isEmpty) {
                    return null;
                  }
                  if (trimmed.isEmpty) return 'Ingresa una descripción';
                  if (trimmed.length < 6) {
                    return 'Describe con un poco más de detalle';
                  }
                  return null;
                },
              ),
              if (_selectedSource == IronSourceType.food) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Puedes combinar seleccionados + texto manual para alimentos no listados.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _quickNoteController,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Cantidad/nota (opcional)',
                    hintText: 'Ejemplo: 2 cucharadas',
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: _wasAccepted,
                onChanged: (value) => setState(() => _wasAccepted = value),
                title: const Text('¿El niño/a aceptó la ingesta?'),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Guardar registro'),
                ),
              ),
            ],
          ),
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

    final (label, color, feedback) = switch (status) {
      IronGoalStatus.low => (
          'Bajo',
          AppColors.warning,
          'Aún falta reforzar una comida rica en hierro hoy.'
        ),
      IronGoalStatus.inProgress => (
          'En progreso',
          AppColors.info,
          'Buen avance. Puedes sumar una opción rica en hierro con vitamina C.'
        ),
      IronGoalStatus.completed => (
          'Cumplido',
          AppColors.success,
          '¡Meta diaria cubierta! Mantén constancia durante la semana.'
        ),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Control diario de hierro',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Objetivo estimado: ${goalIronMg.toStringAsFixed(1)} mg • Consumido: ${consumedIronMg.toStringAsFixed(1)} mg',
            ),
            const SizedBox(height: AppSpacing.sm),
            LinearProgressIndicator(value: progress, color: color),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(Icons.flag_circle, color: color, size: 18),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Estado: $label (${(progress * 100).toStringAsFixed(0)}%)',
                  style: TextStyle(color: color, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(feedback),
          ],
        ),
      ),
    );
  }
}
