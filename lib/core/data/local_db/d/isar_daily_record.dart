import 'package:isar/isar.dart';

part 'isar_daily_record.g.dart';

@collection
class IsarDailyRecord {
  Id id = Isar.autoIncrement;

  @Index(unique: true) // Para buscar rápidamente por fecha y que no se repitan
  late DateTime date;

  late double consumedIron;
  late bool tookSupplement;
}