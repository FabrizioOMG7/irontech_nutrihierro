import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/child.dart';
import '../../domain/repositories/profile_repository.dart';

/// Implementación temporal (Mock) para probar el flujo sin Firebase.
class ProfileRepositoryMock implements ProfileRepository {
  static const String _childrenStorageKey = 'profile_children_v1';

  Future<List<Child>> _readChildren() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_childrenStorageKey);
    if (raw == null || raw.isEmpty) return <Child>[];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((item) => Child.fromJson(item as Map<String, dynamic>))
        .toList(growable: true);
  }

  Future<void> _writeChildren(List<Child> children) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = children.map((item) => item.toJson()).toList(growable: false);
    await prefs.setString(_childrenStorageKey, jsonEncode(payload));
  }

  @override
  Future<void> saveChild(Child child) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final memoryDb = await _readChildren();
    // Si el niño ya existe lo actualizamos, si no, lo agregamos
    final index = memoryDb.indexWhere((c) => c.id == child.id);
    if (index >= 0) {
      memoryDb[index] = child;
    } else {
      memoryDb.add(child);
    }
    await _writeChildren(memoryDb);
  }

  @override
  Future<List<Child>> getChildren() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final memoryDb = await _readChildren();
    return List<Child>.unmodifiable(memoryDb);
  }

  @override
  Future<void> deleteChild(String id) async {
    final memoryDb = await _readChildren();
    memoryDb.removeWhere((c) => c.id == id);
    await _writeChildren(memoryDb);
  }
}
