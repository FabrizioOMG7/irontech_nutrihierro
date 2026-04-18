import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:irontech_nutrihierro/features/profile/presentation/providers/profile_provider.dart';
import 'package:irontech_nutrihierro/features/tracking/domain/daily_record.dart';
import 'package:irontech_nutrihierro/features/tracking/presentation/providers/tracking_provider.dart';
import 'package:uuid/uuid.dart';


class TrackingPage extends ConsumerWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Leemos al niño registrado
    final childrenAsync = ref.watch(childrenListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Diario'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: childrenAsync.when(
        data: (children) {
          if (children.isEmpty) {
            return const Center(child: Text('Registra un niño primero.'));
          }

          final child = children.first;
          final now = DateTime.now();

          // Leemos el historial de este mes
          final recordsAsync = ref.watch(monthlyRecordsProvider({
            'childId': child.id,
            'month': now.month,
            'year': now.year,
          }));

          return Column(
            children: [
              // Cabecera
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                color: Colors.red[50],
                child: Text(
                  'Seguimiento de ${child.name}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),

              // Lista de registros
              Expanded(
                child: recordsAsync.when(
                  data: (records) {
                    if (records.isEmpty) {
                      return const Center(
                        child: Text('Aún no has registrado nada este mes.\n¡Toca el botón + para empezar!'),
                      );
                    }
                    return ListView.builder(
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        final record = records[index];
                        return ListTile(
                          leading: Icon(
                            record.sourceType == IronSourceType.food 
                                ? Icons.restaurant 
                                : Icons.local_hospital,
                            color: Colors.red,
                          ),
                          title: Text(record.description),
                          subtitle: Text('${record.date.day}/${record.date.month}/${record.date.year}'),
                          trailing: const Icon(Icons.check_circle, color: Colors.green),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const Center(child: Text('Error al cargar perfil')),
      ),
      // Botón flotante para registrar una nueva ingesta
      floatingActionButton: childrenAsync.maybeWhen(
        data: (children) {
          if (children.isEmpty) return null;
          return FloatingActionButton.extended(
            onPressed: () {
              // Simulamos el guardado rápido de una papilla hoy
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
            label: const Text('Registrar Hoy'),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          );
        },
        orElse: () => null,
      ),
    );
  }
}