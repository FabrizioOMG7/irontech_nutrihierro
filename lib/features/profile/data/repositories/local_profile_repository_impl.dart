import 'package:isar/isar.dart';
import '../../domain/child.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../../../core/data/local_db/models/isar_child.dart';

class LocalProfileRepositoryImpl implements ProfileRepository {
  final Isar isar;

  LocalProfileRepositoryImpl(this.isar);

  @override
  Future<void> saveChild(Child child) async {
    final isarChild = IsarChild()
      ..childId = child.id
      ..name = child.name
      ..birthDate = child.birthDate
      ..gender = child.gender.name;

    await isar.writeTxn(() async {
      await isar.isarChilds.putByChildId(isarChild);
    });
  }

  @override
  Future<List<Child>> getChildren() async {
    final isarChildren = await isar.isarChilds.where().findAll();

    return isarChildren.map((isarChild) {
      return Child(
        id: isarChild.childId,
        name: isarChild.name,
        birthDate: isarChild.birthDate,
        gender: genderFromStorage(isarChild.gender),
      );
    }).toList();
  }

  @override
  Future<void> deleteChild(String id) async {
    await isar.writeTxn(() async {
      await isar.isarChilds.deleteByChildId(id);
    });
  }
}
