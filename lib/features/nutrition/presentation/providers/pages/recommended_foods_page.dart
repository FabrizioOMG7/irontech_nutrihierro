import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';
import 'package:irontech_nutrihierro/core/widgets/async_value_view.dart';
import 'package:irontech_nutrihierro/core/widgets/empty_state_view.dart';
import 'package:irontech_nutrihierro/core/widgets/iron_card.dart';
import 'package:irontech_nutrihierro/core/widgets/responsive_content.dart';
import 'package:irontech_nutrihierro/features/nutrition/presentation/providers/nutrition_provider.dart';

class RecommendedFoodsPage extends ConsumerWidget {
  const RecommendedFoodsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alimentos recomendados')),
      body: ResponsiveContent(
        child: AsyncValueView(
          value: ref.watch(allRecipesProvider),
          errorPrefix: 'Error al cargar alimentos',
          loadingMessage: 'Cargando recomendaciones...',
          dataBuilder: (recipes) {
            if (recipes.isEmpty) {
              return const EmptyStateView(
                icon: Icons.restaurant_outlined,
                title: 'Sin alimentos recomendados',
                message: 'Aún no hay datos disponibles en el catálogo local.',
              );
            }
            return ListView.separated(
              itemCount: recipes.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  onTap: () => context.push('/info/recipes/${recipe.id}'),
                  child: IronCard(
                    title: recipe.title,
                    description: recipe.description,
                    trailingWidget: _IronBadge(ironContent: recipe.ironContent),
                  ),
                );
              },
            );
          },
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
        '$ironContent mg',
        style: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
