import 'package:flutter/foundation.dart';

@immutable
class MonthlyRecordsQuery {
  final String childId;
  final int month;
  final int year;

  const MonthlyRecordsQuery({
    required this.childId,
    required this.month,
    required this.year,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MonthlyRecordsQuery &&
        other.childId == childId &&
        other.month == month &&
        other.year == year;
  }

  @override
  int get hashCode => Object.hash(childId, month, year);
}
