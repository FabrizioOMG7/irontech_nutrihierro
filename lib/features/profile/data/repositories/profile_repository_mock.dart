import '../../domain/child.dart';
import '../../domain/repositories/profile_repository.dart';

/// Implementación temporal (Mock) para probar el flujo sin Firebase.
class ProfileRepositoryMock implements ProfileRepository {
  // Nuestra "Base de datos" en memoria RAM
  final List<Child> _memoryDb = [];

  @override
  Future<void> saveChild(Child child) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulamos carga
    // Si el niño ya existe lo actualizamos, si no, lo agregamos
    final index = _memoryDb.indexWhere((c) => c.id == child.id);
    if (index >= 0) {
      _memoryDb[index] = child;
    } else {
      _memoryDb.add(child);
    }
  }

  @override
  Future<List<Child>> getChildren() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _memoryDb;
  }

  @override
  Future<void> deleteChild(String id) async {
    _memoryDb.removeWhere((c) => c.id == id);
  }
}