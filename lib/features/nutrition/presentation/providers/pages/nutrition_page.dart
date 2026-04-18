import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:irontech_nutrihierro/core/widgets/iron_card.dart';
import 'package:irontech_nutrihierro/features/nutrition/domain/recipe.dart';
import 'package:irontech_nutrihierro/features/nutrition/presentation/providers/nutrition_provider.dart';
import 'package:irontech_nutrihierro/features/profile/presentation/providers/profile_provider.dart';

class NutritionPage extends ConsumerWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Obtenemos la lista de niños para saber a quién estamos alimentando
    final childrenAsync = ref.watch(childrenListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo Nutricional'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        // 👇 AQUÍ AGREGAMOS LA CAMPANITA DE NOTIFICACIONES 👇
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Módulo de Alertas ALMA en construcción 🚧')),
              );
            },
          ),
        ],
      ),
      body: childrenAsync.when(
        data: (children) {
          if (children.isEmpty) {
            return const Center(child: Text('No hay niños registrados.'));
          }

          // Por ahora tomamos al primer niño registrado
          final child = children.first;
          final category = Recipe.getCategoryForMonths(child.ageInMonths);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabecera con info del niño
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.red[50],
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.child_care, color: Colors.white),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recetas para ${child.name}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text('Etapa: ${child.nutritionCategory}'),
                      ],
                    ),
                  ],
                ),
              ),
              
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Alimentos Recomendados',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              // 2. Cargamos las recetas filtradas por la edad del niño
              Expanded(
                child: ref.watch(recipesByCategoryProvider(category)).when(
                  data: (recipes) => ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      
                      
                      return IronCard(
                        title: recipe.title,
                        description: recipe.description,
                        trailingWidget: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${recipe.ironContent}mg Hierro',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      );
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error al cargar perfil')),
      ),
    );
  }
}
