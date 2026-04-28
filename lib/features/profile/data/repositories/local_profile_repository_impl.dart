import 'package:irontech_nutrihierro/core/data/local_db/models/isar_child.dart';
import 'package:irontech_nutrihierro/core/data/local_db/models/isar_daily_record.dart';
import 'package:isar/isar.dart';

import '../../domain/child.dart';
import '../../domain/repositories/profile_repository.dart';

class LocalProfileRepositoryImpl implements ProfileRepository {
  final Isar isar;

  LocalProfileRepositoryImpl(this.isar);

  @override
  Future<void> saveChild(Child child) async {
    final isarChild = IsarChild()
      ..childId = child.id
      ..name = child.name
      ..birthDate = child.birthDate
      ..gender = child.gender.name; // Convertimos Gender a String

    await isar.writeTxn(() async {
      // Alternativa a putByIndex: eliminar si existe y luego agregar
      await isar.isarChilds.filter().childIdEqualTo(child.id).deleteAll();
      await isar.isarChilds.put(isarChild);
    });
  }

  @override
  Future<List<Child>> getChildren() async {
    final isarChildren = await isar.isarChilds.where().findAll();

    return isarChildren.map((isarChild) => Child(
      id: isarChild.childId,
      name: isarChild.name,
      birthDate: isarChild.birthDate,
      gender: genderFromStorage(isarChild.gender), // Convertimos String a Gender
    )).toList();
  }

  @override
  Future<void> deleteChild(String id) async {
    await isar.writeTxn(() async {
      // Alternativa a deleteByIndex: filtrar y eliminar
      await isar.isarChilds.filter().childIdEqualTo(id).deleteAll();

      // Eliminar registros diarios asociados al niño
      await isar.isarDailyRecords.filter().childIdEqualTo(id).deleteAll();
    });
  }
}