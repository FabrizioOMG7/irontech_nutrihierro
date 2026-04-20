import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';
import 'package:irontech_nutrihierro/core/widgets/async_value_view.dart';
import 'package:irontech_nutrihierro/core/widgets/empty_state_view.dart';
import 'package:irontech_nutrihierro/core/widgets/responsive_content.dart';
import 'package:irontech_nutrihierro/features/profile/domain/child.dart';
import 'package:irontech_nutrihierro/features/profile/presentation/providers/profile_provider.dart';

class ChildProfilePage extends ConsumerWidget {
  const ChildProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil del niño/a')),
      body: AsyncValueView(
        value: ref.watch(childrenListProvider),
        errorPrefix: 'No se pudo cargar el perfil',
        loadingMessage: 'Cargando perfil...',
        dataBuilder: (children) {
          if (children.isEmpty) {
            return const ResponsiveContent(
              child: EmptyStateView(
                icon: Icons.child_care,
                title: 'No hay perfil registrado',
                message: 'Primero registra al niño/a para poder editar sus datos.',
              ),
            );
          }
          return ResponsiveContent(child: _ChildProfileForm(child: children.first));
        },
      ),
    );
  }
}

class _ChildProfileForm extends ConsumerStatefulWidget {
  final Child child;

  const _ChildProfileForm({required this.child});

  @override
  ConsumerState<_ChildProfileForm> createState() => _ChildProfileFormState();
}

class _ChildProfileFormState extends ConsumerState<_ChildProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late DateTime _selectedDate;
  late Gender _selectedGender;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.child.name);
    _selectedDate = widget.child.birthDate;
    _selectedGender = widget.child.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 12, 1, 1),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _save() async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final updatedChild = Child(
      id: widget.child.id,
      name: _nameController.text.trim(),
      birthDate: _selectedDate,
      gender: _selectedGender,
    );

    try {
      await ref.read(childrenListProvider.notifier).updateChild(updatedChild);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado correctamente.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo actualizar el perfil.')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre del niño/a',
              prefixIcon: Icon(Icons.person_outline),
            ),
            validator: (value) {
              final trimmed = value?.trim() ?? '';
              if (trimmed.isEmpty) return 'Ingresa un nombre';
              if (trimmed.length < 2) return 'Ingresa al menos 2 letras';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: ListTile(
              onTap: _pickDate,
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text('Fecha de nacimiento'),
              subtitle: Text(_formatDate(_selectedDate)),
              trailing: const Icon(Icons.arrow_drop_down),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text('Género', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              ChoiceChip(
                label: const Text('Masculino'),
                selected: _selectedGender == Gender.male,
                onSelected: (_) => setState(() => _selectedGender = Gender.male),
              ),
              ChoiceChip(
                label: const Text('Femenino'),
                selected: _selectedGender == Gender.female,
                onSelected: (_) => setState(() => _selectedGender = Gender.female),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton.icon(
            onPressed: _isSaving ? null : _save,
            icon: const Icon(Icons.save_outlined),
            label: Text(_isSaving ? 'Guardando...' : 'Guardar cambios'),
          ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
