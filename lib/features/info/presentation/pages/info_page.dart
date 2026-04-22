import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';
import 'package:irontech_nutrihierro/core/widgets/async_value_view.dart';
import 'package:irontech_nutrihierro/core/widgets/empty_state_view.dart';
import 'package:irontech_nutrihierro/core/widgets/iron_card.dart';
import 'package:irontech_nutrihierro/core/widgets/responsive_content.dart';
import 'package:irontech_nutrihierro/features/info/domain/anemia_info_article.dart';
import 'package:irontech_nutrihierro/features/info/presentation/providers/info_provider.dart';
import 'package:irontech_nutrihierro/features/nutrition/domain/recipe.dart';
import 'package:irontech_nutrihierro/features/nutrition/presentation/providers/nutrition_provider.dart';

class InfoPage extends ConsumerWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Información')),
      body: ResponsiveContent(
        child: AsyncValueView(
          value: ref.watch(anemiaInfoArticlesProvider),
          errorPrefix: 'No se pudo cargar información',
          loadingMessage: 'Cargando secciones...',
          dataBuilder: (articles) {
            if (articles.isEmpty) {
              return const EmptyStateView(
                icon: Icons.menu_book_outlined,
                title: 'Sin contenido disponible',
                message: 'Pronto agregaremos más guías informativas.',
              );
            }
            return ListView.separated(
              itemCount: articles.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.restaurant_menu),
                      title: const Text('Recetas saludables'),
                      subtitle: const Text('Explora y visualiza recetas locales de hierro.'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/info/recipes'),
                    ),
                  );
                }
                final article = articles[index - 1];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.article_outlined),
                    title: Text(article.title),
                    subtitle: const Text('Contenido para padres y cuidadores'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/info/${article.id}'),
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

class InfoRecipesListPage extends ConsumerWidget {
  const InfoRecipesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recetas')),
      body: ResponsiveContent(
        child: AsyncValueView(
          value: ref.watch(allRecipesProvider),
          errorPrefix: 'No se pudo cargar recetas',
          loadingMessage: 'Cargando recetas...',
          dataBuilder: (recipes) {
            if (recipes.isEmpty) {
              return const EmptyStateView(
                icon: Icons.restaurant_outlined,
                title: 'Sin recetas',
                message: 'No hay recetas disponibles en el catálogo local.',
              );
            }
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  onTap: () => context.push('/info/recipes/${recipe.id}'),
                  child: IronCard(
                    title: recipe.title,
                    description: recipe.description,
                    trailingWidget: _RecipeIronBadge(ironContent: recipe.ironContent),
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

class InfoRecipeDetailPage extends ConsumerWidget {
  final String recipeId;

  const InfoRecipeDetailPage({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de receta')),
      body: ResponsiveContent(
        child: AsyncValueView(
          value: ref.watch(allRecipesProvider),
          errorPrefix: 'No se pudo cargar receta',
          loadingMessage: 'Cargando detalle...',
          dataBuilder: (recipes) {
            final recipe = _findRecipeById(recipes, recipeId);
            if (recipe == null) {
              return const EmptyStateView(
                icon: Icons.receipt_long_outlined,
                title: 'Receta no encontrada',
                message: 'La receta no está disponible en este momento.',
              );
            }
            return ListView(
              children: [
                Text(recipe.title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.md),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(recipe.description),
                        const SizedBox(height: AppSpacing.md),
                        Text('Hierro aproximado: ${recipe.ironContent} mg'),
                        const SizedBox(height: AppSpacing.sm),
                        Text('Etapa sugerida: ${_ageCategoryLabel(recipe.targetAge)}'),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Recipe? _findRecipeById(List<Recipe> recipes, String id) {
  for (final recipe in recipes) {
    if (recipe.id == id) return recipe;
  }
  return null;
}

class _RecipeIronBadge extends StatelessWidget {
  final int ironContent;

  const _RecipeIronBadge({required this.ironContent});

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

String _ageCategoryLabel(AgeCategory category) {
  switch (category) {
    case AgeCategory.lactanciaExclusiva:
      return 'Lactancia exclusiva (0-5 meses)';
    case AgeCategory.papillas:
      return 'Papillas (6-8 meses)';
    case AgeCategory.picados:
      return 'Picados (9-11 meses)';
    case AgeCategory.ollaFamiliar:
      return 'Olla familiar (12-23 meses)';
    case AgeCategory.escolar:
      return 'Escolar (24+ meses)';
  }
}

class InfoDetailPage extends ConsumerWidget {
  final String articleId;

  const InfoDetailPage({super.key, required this.articleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle informativo')),
      body: ResponsiveContent(
        child: AsyncValueView(
          value: ref.watch(anemiaInfoArticlesProvider),
          errorPrefix: 'No se pudo cargar el contenido',
          loadingMessage: 'Cargando contenido...',
          dataBuilder: (articles) {
            final article = _findArticleById(articles, articleId);
            if (article == null) {
              return const EmptyStateView(
                icon: Icons.info_outline,
                title: 'Contenido no encontrado',
                message: 'Vuelve a la sección informativa e intenta de nuevo.',
              );
            }
            return ListView(
              children: [
                Text(
                  article.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.md),
                ..._buildSectionCards(context, article.content),
              ],
            );
          },
        ),
      ),
    );
  }
}

List<Widget> _buildSectionCards(BuildContext context, String content) {
  final sections = content
      .split('\n\n')
      .where((section) => section.trim().isNotEmpty)
      .toList(growable: false);

  return [
    for (final section in sections) ...[
      Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(section, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ),
      const SizedBox(height: AppSpacing.sm),
    ],
  ];
}

AnemiaInfoArticle? _findArticleById(List<AnemiaInfoArticle> articles, String id) {
  for (final article in articles) {
    if (article.id == id) return article;
  }
  return null;
}
