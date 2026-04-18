import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart'; // Para generar IDs únicos
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

  // Función para mostrar el calendario
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      // 1. Creamos el objeto Child (Entidad de Dominio)
      final newChild = Child(
        id: const Uuid().v4(), // Generamos un ID único
        name: _nameController.text.trim(),
        birthDate: _selectedDate!,
        gender: _selectedGender,
      );

      // 2. Usamos el Provider para guardarlo (Inversión de Dependencia)
      // La pantalla no sabe que esto va a Firebase, solo confía en el Provider.
      await ref.read(childrenListProvider.notifier).addChild(newChild);

      // 3. Navegamos al Home una vez guardado
      if (mounted) context.go('/home');
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona la fecha de nacimiento')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Niño/a')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                '¡Bienvenido a IronTech! 👋',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text('Empecemos registrando los datos de tu pequeño/a para personalizar su nutrición.'),
              const SizedBox(height: 30),

              // Campo de Nombre
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del niño/a',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Ingresa un nombre' : null,
              ),
              const SizedBox(height: 20),

              // Selector de Fecha
              ListTile(
                tileColor: Colors.grey[100],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                leading: const Icon(Icons.calendar_today),
                title: Text(_selectedDate == null 
                    ? 'Fecha de nacimiento' 
                    : 'Nació el: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                trailing: const Icon(Icons.arrow_drop_down),
                onTap: _pickDate,
              ),
              const SizedBox(height: 20),

              // Selector de Género
              const Text('Género:', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<Gender>(
                      title: const Text('M'),
                      value: Gender.male,
                      groupValue: _selectedGender,
                      onChanged: (val) => setState(() => _selectedGender = val!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<Gender>(
                      title: const Text('F'),
                      value: Gender.female,
                      groupValue: _selectedGender,
                      onChanged: (val) => setState(() => _selectedGender = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Botón de Guardar
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Guardar Perfil', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
