import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';
import 'package:irontech_nutrihierro/core/widgets/async_value_view.dart';
import 'package:irontech_nutrihierro/core/widgets/empty_state_view.dart';
import 'package:irontech_nutrihierro/core/widgets/responsive_content.dart';
import 'package:irontech_nutrihierro/features/profile/presentation/providers/profile_provider.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/daily_record.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/monthly_records_query.dart';
import 'package:irontech_nutrihierro/features/tracking/presentation/providers/tracking_provider.dart';
import 'package:uuid/uuid.dart';


class TrackingPage extends ConsumerWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childrenAsync = ref.watch(childrenListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Registro Diario')),
      body: AsyncValueView(
        value: childrenAsync,
        errorPrefix: 'Error al cargar perfil',
        dataBuilder: (children) {
          if (children.isEmpty) {
            return const EmptyStateView(
              icon: Icons.child_care,
              title: 'Registra un niño primero',
              message: 'Necesitamos un perfil para asociar el seguimiento diario.',
            );
          }

          final child = children.first;
          final now = DateTime.now();
          final query = MonthlyRecordsQuery(
            childId: child.id,
            month: now.month,
            year: now.year,
          );

          return ResponsiveContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Theme.of(context).colorScheme.primary.withAlpha(15),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text(
                      'Seguimiento de ${child.name}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
                Expanded(
                  child: AsyncValueView(
                    value: ref.watch(monthlyRecordsProvider(query)),
                    errorPrefix: 'Error al cargar registro',
                    dataBuilder: (records) {
                      if (records.isEmpty) {
                        return const EmptyStateView(
                          icon: Icons.calendar_month,
                          title: 'Sin registros este mes',
                          message: 'Toca el botón "Registrar hoy" para empezar el seguimiento.',
                        );
                      }
                      return ListView.builder(
                        itemCount: records.length,
                        itemBuilder: (context, index) => _RecordTile(record: records[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: childrenAsync.maybeWhen(
        data: (children) {
          if (children.isEmpty) return null;
          return FloatingActionButton.extended(
            onPressed: () {
              final newRecord = DailyRecord(
                id: const Uuid().v4(),
                childId: children.first.id,
                date: DateTime.now(),
                sourceType: IronSourceType.food,
                description: 'Papilla rica en hierro',
              );
              ref.read(trackingControllerProvider.notifier).addRecord(newRecord);
            },
            icon: const Icon(Icons.add),
            label: const Text('Registrar hoy'),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          );
        },
        orElse: () => null,
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  final DailyRecord record;

  const _RecordTile({required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          record.sourceType == IronSourceType.food ? Icons.restaurant : Icons.local_hospital,
          color: AppColors.primary,
        ),
        title: Text(record.description),
        subtitle: Text('${record.date.day}/${record.date.month}/${record.date.year}'),
        trailing: const Icon(Icons.check_circle, color: AppColors.success),
      ),
    );
  }
}
