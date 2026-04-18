import 'package:flutter_test/flutter_test.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/monthly_records_query.dart';

void main() {
  group('MonthlyRecordsQuery equality', () {
    test('queries with same fields are equal and share hashCode', () {
      const a = MonthlyRecordsQuery(childId: 'child-1', month: 4, year: 2026);
      const b = MonthlyRecordsQuery(childId: 'child-1', month: 4, year: 2026);

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('queries with different fields are not equal', () {
      const a = MonthlyRecordsQuery(childId: 'child-1', month: 4, year: 2026);
      const b = MonthlyRecordsQuery(childId: 'child-2', month: 4, year: 2026);

      expect(a == b, isFalse);
    });
  });
}
