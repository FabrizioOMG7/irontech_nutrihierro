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

          final child = children.first;
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
                      if (records.isEmpty) {
                        return EmptyStateView(
                          icon: Icons.calendar_month,
                          title: 'Sin registros en ${formatDateDdMmYyyy(_historyDate)}',
                          message:
                              'Usa "Registrar ingesta" para guardar registros y consultarlos por fecha.',
                        );
                      }
                      return ListView.builder(
                        itemCount: records.length,
                        itemBuilder: (context, index) =>
                            _RecordTile(record: records[index]),
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
          if (children.isEmpty) return null;
          return FloatingActionButton.extended(
            onPressed: () => _openRecordForm(
              context,
              ref,
              children.first.id,
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
          '${formatDateDdMmYyyy(record.date)} • ${_sourceLabel(record.sourceType)}',
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

  const _RecordFormData({
    required this.date,
    required this.sourceType,
    required this.description,
    required this.wasAccepted,
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
  DateTime _selectedDate = DateTime.now();
  IronSourceType _selectedSource = IronSourceType.food;
  bool _wasAccepted = true;
  String? _selectedPresetFoodOption;
  final Set<String> _selectedPresetFoods = <String>{};
  static const List<String> _presetFoods = [
    'Sangrecita',
    'Hígado de pollo',
    'Bazo',
    'Lentejas',
    'Pescado',
    'Espinaca',
    'Quinua',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    _quickNoteController.dispose();
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
    final descriptionParts = <String>[];

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
