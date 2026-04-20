import 'package:meta/meta.dart';

@immutable
class DailyRecordsQuery {
  final String childId;
  final DateTime date;

  const DailyRecordsQuery({required this.childId, required this.date});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DailyRecordsQuery &&
        other.childId == childId &&
        other.date.year == date.year &&
        other.date.month == date.month &&
        other.date.day == date.day;
  }

  @override
  int get hashCode => Object.hash(childId, date.year, date.month, date.day);
}
