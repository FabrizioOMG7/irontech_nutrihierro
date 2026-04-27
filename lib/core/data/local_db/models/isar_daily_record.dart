import 'package:isar/isar.dart';

part 'isar_daily_record.g.dart';

@collection
class IsarDailyRecord {
  Id id = Isar.autoIncrement;

  @Index()
  late String recordId; // Identificador único del dominio (para mapeo)

  @Index()
  late String childId; // Para filtrar registros por niño

  @Index()
  late DateTime date;

  late String sourceType; // Almacenamos el enum como String ('food', 'supplement')

  late String description;

  late bool wasAccepted;

  late double ironMg;
}
