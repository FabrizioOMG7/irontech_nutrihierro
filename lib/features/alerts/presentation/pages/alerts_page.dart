import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';
import 'package:irontech_nutrihierro/core/widgets/empty_state_view.dart';
import 'package:irontech_nutrihierro/core/widgets/responsive_content.dart';
import 'package:irontech_nutrihierro/features/alerts/domain/app_alert.dart';
import 'package:irontech_nutrihierro/features/alerts/presentation/providers/alerts_provider.dart';

class AlertsPage extends ConsumerWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(alertsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertas'),
        actions: [
          PopupMenuButton<_AlertsAction>(
            onSelected: (action) {
              final notifier = ref.read(alertsProvider.notifier);
              switch (action) {
                case _AlertsAction.markAllAsRead:
                  notifier.markAllAsRead();
                  break;
                case _AlertsAction.clearRead:
                  notifier.clearRead();
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _AlertsAction.markAllAsRead,
                child: Text('Marcar todo como leído'),
              ),
              PopupMenuItem(
                value: _AlertsAction.clearRead,
                child: Text('Limpiar leídas'),
              ),
            ],
          ),
        ],
      ),
      body: ResponsiveContent(
        child: alerts.isEmpty
            ? const EmptyStateView(
                icon: Icons.notifications_off_outlined,
                title: 'Sin alertas pendientes',
                message: 'Cuando tengas nuevas alertas aparecerán aquí.',
              )
            : ListView.separated(
                itemCount: alerts.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final alert = alerts[index];
                  return _AlertTile(
                    alert: alert,
                    onMarkAsRead: () =>
                        ref.read(alertsProvider.notifier).markAsRead(alert.id),
                  );
                },
              ),
      ),
    );
  }
}

enum _AlertsAction { markAllAsRead, clearRead }

class _AlertTile extends StatelessWidget {
  final AppAlert alert;
  final VoidCallback onMarkAsRead;

  const _AlertTile({required this.alert, required this.onMarkAsRead});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        leading: Icon(
          alert.isRead ? Icons.notifications_none : Icons.notifications_active,
          color: alert.isRead ? colorScheme.outline : colorScheme.primary,
        ),
        title: Text(
          alert.title,
          style: TextStyle(
            fontWeight: alert.isRead ? FontWeight.w500 : FontWeight.w700,
          ),
        ),
        subtitle: Text(alert.message),
        trailing: alert.isRead
            ? const Icon(Icons.check_circle_outline)
            : TextButton(
                onPressed: onMarkAsRead,
                child: const Text('Marcar leído'),
              ),
        onTap: alert.isRead ? null : onMarkAsRead,
      ),
    );
  }
}
