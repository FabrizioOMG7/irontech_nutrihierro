import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:irontech_nutrihierro/features/alerts/presentation/providers/alerts_provider.dart';

void main() {
  group('alertsProvider', () {
    test('markAsRead updates unread alert state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initialAlerts = container.read(alertsProvider);
      expect(initialAlerts.first.isRead, isFalse);

      container.read(alertsProvider.notifier).markAsRead(initialAlerts.first.id);

      final updatedAlerts = container.read(alertsProvider);
      expect(updatedAlerts.first.isRead, isTrue);
    });

    test('clearRead removes only read alerts', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final firstId = container.read(alertsProvider).first.id;
      container.read(alertsProvider.notifier).markAsRead(firstId);
      container.read(alertsProvider.notifier).clearRead();

      final remainingAlerts = container.read(alertsProvider);
      expect(remainingAlerts.any((alert) => alert.id == firstId), isFalse);
      expect(remainingAlerts, isNotEmpty);
    });
  });
}
