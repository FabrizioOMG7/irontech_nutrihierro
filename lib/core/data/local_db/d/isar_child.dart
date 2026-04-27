import 'package:isar/isar.dart';

part 'isar_child.g.dart'; 

@collection
class IsarChild {
  Id isarId = Isar.autoIncrement; 

  @Index(unique: true, replace: true) 
  late String childId; // ¡CAMBIO CLAVE! Evitamos la palabra reservada 'id'

  late String name;
  late DateTime birthDate;
  late String gender;
}