import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';
import 'package:irontech_nutrihierro/core/widgets/responsive_content.dart';
import 'package:uuid/uuid.dart';
import '../../domain/child.dart';
import '../providers/profile_provider.dart';

class ProfileRegisterPage extends ConsumerStatefulWidget {
  const ProfileRegisterPage({super.key});

  @override
  ConsumerState<ProfileRegisterPage> createState() => _ProfileRegisterPageState();
}

class _ProfileRegisterPageState extends ConsumerState<ProfileRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _selectedDate;
  Gender _selectedGender = Gender.male;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _saveForm() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona la fecha de nacimiento')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final newChild = Child(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        birthDate: _selectedDate!,
        gender: _selectedGender,
      );

      await ref.read(childrenListProvider.notifier).addChild(newChild);
      if (mounted) context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Niño/a')),
      body: ResponsiveContent(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('¡Bienvenido a IronTech! 👋', style: theme.textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Registra los datos de tu pequeño/a para personalizar la nutrición.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del niño/a',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Ingresa un nombre' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              _BirthDateTile(
                selectedDate: _selectedDate,
                onTap: _pickDate,
              ),
              const SizedBox(height: AppSpacing.md),
              const Text('Género', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppSpacing.sm),
              _GenderSelector(
                selectedGender: _selectedGender,
                onChanged: (value) => setState(() => _selectedGender = value),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Guardar perfil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BirthDateTile extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const _BirthDateTile({
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = selectedDate == null
        ? 'Fecha de nacimiento'
        : 'Nació el: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';

    return Card(
      child: ListTile(
        leading: const Icon(Icons.calendar_today_outlined),
        title: Text(label),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: onTap,
      ),
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final Gender selectedGender;
  final ValueChanged<Gender> onChanged;

  const _GenderSelector({
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        ChoiceChip(
          label: const Text('Masculino'),
          labelPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          selected: selectedGender == Gender.male,
          onSelected: (_) => onChanged(Gender.male),
        ),
        ChoiceChip(
          label: const Text('Femenino'),
          labelPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          selected: selectedGender == Gender.female,
          onSelected: (_) => onChanged(Gender.female),
        ),
        ChoiceChip(
          label: const Text('Otro'),
          labelPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          selected: selectedGender == Gender.other,
          onSelected: (_) => onChanged(Gender.other),
        ),
      ],
    );
  }
}
