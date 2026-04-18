import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';
import 'package:irontech_nutrihierro/core/widgets/async_value_view.dart';
import 'package:irontech_nutrihierro/core/widgets/empty_state_view.dart';
import 'package:irontech_nutrihierro/core/widgets/iron_card.dart';
import 'package:irontech_nutrihierro/core/widgets/responsive_content.dart';
import 'package:irontech_nutrihierro/features/nutrition/domain/recipe.dart';
import 'package:irontech_nutrihierro/features/nutrition/presentation/providers/nutrition_provider.dart';
import 'package:irontech_nutrihierro/features/profile/presentation/providers/profile_provider.dart';

class NutritionPage extends ConsumerWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo Nutricional'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Módulo de alertas en construcción 🚧')),
              );
            },
          ),
        ],
      ),
      body: AsyncValueView(
        value: ref.watch(childrenListProvider),
        errorPrefix: 'Error al cargar perfil',
        dataBuilder: (children) {
          if (children.isEmpty) {
            return const EmptyStateView(
              icon: Icons.child_care,
              title: 'No hay niños registrados',
              message: 'Registra primero un perfil para ver recomendaciones personalizadas.',
            );
          }
          final child = children.first;
          final category = Recipe.getCategoryForMonths(child.ageInMonths);
          return ResponsiveContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ChildHeader(
                  name: child.name,
                  nutritionCategory: child.nutritionCategory,
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Alimentos recomendados', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.sm),
                Expanded(
                  child: AsyncValueView(
                    value: ref.watch(recipesByCategoryProvider(category)),
                    errorPrefix: 'Error al cargar recetas',
                    dataBuilder: (recipes) {
                      if (recipes.isEmpty) {
                        return const EmptyStateView(
                          icon: Icons.restaurant,
                          title: 'Sin recetas disponibles',
                          message: 'No hay recetas para esta etapa en este momento.',
                        );
                      }
                      return ListView.builder(
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          final recipe = recipes[index];
                          return IronCard(
                            title: recipe.title,
                            description: recipe.description,
                            trailingWidget: _IronBadge(ironContent: recipe.ironContent),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ChildHeader extends StatelessWidget {
  final String name;
  final String nutritionCategory;

  const _ChildHeader({required this.name, required this.nutritionCategory});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary.withAlpha(15),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Icon(Icons.child_care, color: Colors.white),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recetas para $name', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Etapa: $nutritionCategory', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IronBadge extends StatelessWidget {
  final int ironContent;

  const _IronBadge({required this.ironContent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Text(
        '$ironContent mg hierro',
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
