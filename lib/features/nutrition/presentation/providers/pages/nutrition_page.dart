import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
            onPressed: () => context.push('/alerts'),
          ),
        ],
      ),
      body: AsyncValueView(
        value: ref.watch(childrenListProvider),
        errorPrefix: 'Error al cargar perfil',
        loadingMessage: 'Cargando perfiles...',
        dataBuilder: (children) {
          if (children.isEmpty) {
            return const EmptyStateView(
              icon: Icons.child_care,
              title: 'Primero registra un perfil',
              message: 'Ve al registro de niño/a para activar recomendaciones personalizadas.',
            );
          }
          final child = ref.watch(activeChildProvider);
          if (child == null) {
            return EmptyStateView(
              icon: Icons.switch_account,
              title: 'Selecciona un perfil activo',
              message: 'Ingresa con un perfil para ver recomendaciones personalizadas.',
            );
          }
          final category = Recipe.getCategoryForMonths(child.ageInMonths);
          return ResponsiveContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ChildHeader(
                  name: child.name,
                  ageLabel: child.formattedAge,
                  nutritionCategory: child.nutritionCategory,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Alimentos recomendados',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => context.push('/recommended-foods'),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Ver todos'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Expanded(
                  child: AsyncValueView(
                    value: ref.watch(recipesByCategoryProvider(category)),
                    errorPrefix: 'Error al cargar recetas',
                    loadingMessage: 'Buscando recetas recomendadas...',
                    dataBuilder: (recipes) {
                      if (recipes.isEmpty) {
                        return const EmptyStateView(
                          icon: Icons.restaurant,
                          title: 'Sin recetas disponibles',
                          message: 'Intenta más tarde o ajusta el perfil para obtener nuevas sugerencias.',
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
  final String ageLabel;
  final String nutritionCategory;

  const _ChildHeader({
    required this.name,
    required this.ageLabel,
    required this.nutritionCategory,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.primary.withAlpha(15),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: colorScheme.primary,
              child: Icon(Icons.child_care, color: colorScheme.onPrimary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recetas para $name', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Edad: $ageLabel', style: Theme.of(context).textTheme.bodyMedium),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Text(
        '$ironContent mg de hierro',
        style: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
