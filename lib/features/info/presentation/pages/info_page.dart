import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';
import 'package:irontech_nutrihierro/core/widgets/app_image_widget.dart';
import 'package:irontech_nutrihierro/core/widgets/async_value_view.dart';
import 'package:irontech_nutrihierro/core/widgets/empty_state_view.dart';
import 'package:irontech_nutrihierro/core/widgets/iron_card.dart';
import 'package:irontech_nutrihierro/core/widgets/responsive_content.dart';
import 'package:irontech_nutrihierro/features/info/domain/anemia_info_article.dart';
import 'package:irontech_nutrihierro/features/info/presentation/providers/info_provider.dart';
import 'package:irontech_nutrihierro/features/nutrition/domain/recipe.dart';
import 'package:irontech_nutrihierro/features/nutrition/presentation/providers/nutrition_provider.dart';

class InfoPage extends ConsumerStatefulWidget {
  const InfoPage({super.key});

  @override
  ConsumerState<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends ConsumerState<InfoPage> {
  String _selectedCategory = 'Todos';

  @override
  Widget build(BuildContext context) {
    final recipeHighlightsAsync = ref.watch(allRecipesProvider);
    final articlesAsync = ref.watch(anemiaInfoArticlesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Información')),
      body: ResponsiveContent(
        child: AsyncValueView(
          value: articlesAsync,
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

            final availableCategories = <String>{
              'Todos',
              ...articles.map(_inferArticleCategory),
            }.toList(growable: false);
            final filteredArticles = _selectedCategory == 'Todos'
                ? articles
                : articles
                    .where(
                      (article) =>
                          _inferArticleCategory(article) == _selectedCategory,
                    )
                    .toList(growable: false);

            return ListView(
              children: [
                Text(
                  'Aprende y actúa en casa',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final category in availableCategories)
                        Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.sm),
                          child: ChoiceChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected: (_) =>
                                setState(() => _selectedCategory = category),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.xl),
                            ),
                            selectedColor: Theme.of(context).colorScheme.primary.withAlpha(50),
                            labelStyle: TextStyle(
                              color: _selectedCategory == category
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                              fontWeight: _selectedCategory == category
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            elevation: _selectedCategory == category ? 2 : 0,
                            side: BorderSide(
                              color: _selectedCategory == category
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.outlineVariant,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.restaurant_menu),
                    title: const Text('Recetas saludables'),
                    subtitle: const Text(
                      'Explora y visualiza recetas locales de hierro.',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/info/recipes'),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                _InteractiveChecklistCard(
                  onOpenRecipes: () => context.push('/info/recipes'),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...filteredArticles.map(
                  (article) => Card(
                    child: ExpansionTile(
                      leading: const Icon(Icons.article_outlined),
                      title: Text(article.title),
                      subtitle: Text(
                        '${_inferArticleCategory(article)} • Pulsa para ver resumen',
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        0,
                        AppSpacing.md,
                        AppSpacing.md,
                      ),
                      children: [
                        Text(
                          _summaryPreview(article.content),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () => context.push('/info/article/${article.id}'),
                            icon: const Icon(Icons.menu_book),
                            label: const Text('Leer contenido completo'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AsyncValueView(
                  value: recipeHighlightsAsync,
                  errorPrefix: 'No se pudo cargar destacados',
                  loadingMessage: 'Cargando recetas destacadas...',
                  dataBuilder: (recipes) {
                    if (recipes.isEmpty) return const SizedBox.shrink();
                    final topRecipes = recipes.take(3).toList(growable: false);
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Destacados de hoy',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            for (final recipe in topRecipes)
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.verified),
                                title: Text(recipe.title),
                                subtitle: Text(
                                  '${_ageCategoryLabel(recipe.targetAge)} • ${recipe.ironContent} mg',
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () =>
                                    context.push('/info/recipes/${recipe.id}'),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _InteractiveChecklistCard extends StatefulWidget {
  final VoidCallback onOpenRecipes;

  const _InteractiveChecklistCard({required this.onOpenRecipes});

  @override
  State<_InteractiveChecklistCard> createState() => _InteractiveChecklistCardState();
}

class _InteractiveChecklistCardState extends State<_InteractiveChecklistCard> {
  bool _mealWithIron = false;
  bool _vitaminCCompanion = false;
  bool _dailyRecordUpdated = false;

  @override
  Widget build(BuildContext context) {
    final checks = [_mealWithIron, _vitaminCCompanion, _dailyRecordUpdated];
    final completed = checks.where((check) => check).length;
    final progress = completed / checks.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mini checklist del día', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: AppSpacing.sm),
            CheckboxListTile(
              value: _mealWithIron,
              contentPadding: EdgeInsets.zero,
              onChanged: (value) => setState(() => _mealWithIron = value ?? false),
              title: const Text('Incluí una comida rica en hierro'),
            ),
            CheckboxListTile(
              value: _vitaminCCompanion,
              contentPadding: EdgeInsets.zero,
              onChanged: (value) =>
                  setState(() => _vitaminCCompanion = value ?? false),
              title: const Text('La combiné con vitamina C'),
            ),
            CheckboxListTile(
              value: _dailyRecordUpdated,
              contentPadding: EdgeInsets.zero,
              onChanged: (value) =>
                  setState(() => _dailyRecordUpdated = value ?? false),
              title: const Text('Actualicé el registro diario'),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text('Avance: $completed/3 acciones'),
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: widget.onOpenRecipes,
                icon: const Icon(Icons.local_dining),
                label: const Text('Ir a recetas relacionadas'),
              ),
            ),
          ],
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
                    imageUrl: recipe.imageUrl,
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
                if (recipe.imageUrl.isNotEmpty)
                  Card(
                    child: AppImageWidget(
                      imageUrl: recipe.imageUrl,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                  )
                else
                  Card(
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.restaurant_menu, size: 42),
                          SizedBox(height: AppSpacing.sm),
                          Text(
                            'Imagen referencial de la receta',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.sm),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resumen',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(recipe.description),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Ingredientes',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        if (recipe.ingredients.isEmpty)
                          const Text('Ingredientes disponibles próximamente.')
                        else
                          for (final ingredient in recipe.ingredients)
                            Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                              child: Text('• $ingredient'),
                            ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Preparación',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        if (recipe.preparationSteps.isEmpty)
                          const Text('Preparación disponible próximamente.')
                        else
                          for (var i = 0; i < recipe.preparationSteps.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                              child: Text('${i + 1}. ${recipe.preparationSteps[i]}'),
                            ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Aporte de hierro',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Hierro aproximado: ${recipe.ironContent} mg.',
                        ),
                        if (recipe.ironContribution.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(recipe.ironContribution),
                        ],
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

String _inferArticleCategory(AnemiaInfoArticle article) {
  final title = article.title.toLowerCase();
  if (title.contains('síntoma') || title.contains('consecuencia')) {
    return 'Síntomas';
  }
  if (title.contains('prevención') || title.contains('recomendaciones')) {
    return 'Prevención';
  }
  return 'Básicos';
}

String _summaryPreview(String content) {
  final clean = content.replaceAll('\n', ' ').trim();
  const maxLength = 180;
  if (clean.length <= maxLength) return clean;
  return '${clean.substring(0, maxLength)}...';
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
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                _ArticleHeader(article: article),
                const SizedBox(height: AppSpacing.lg),
                ..._buildRichSections(context, article.content),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ArticleHeader extends StatelessWidget {
  final AnemiaInfoArticle article;

  const _ArticleHeader({required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    IconData iconData = Icons.article_rounded;
    Color iconColor = colorScheme.primary;
    Color bgColor = colorScheme.primaryContainer;

    final lowerTitle = article.title.toLowerCase();
    if (lowerTitle.contains('infantil') || lowerTitle.contains('niño')) {
      iconData = Icons.child_care;
      iconColor = colorScheme.tertiary;
      bgColor = colorScheme.tertiaryContainer;
    } else if (lowerTitle.contains('prevención') || lowerTitle.contains('recomendación')) {
      iconData = Icons.shield_outlined;
      iconColor = Colors.green.shade700;
      bgColor = Colors.green.shade100;
    } else if (lowerTitle.contains('síntoma') || lowerTitle.contains('consecuencia')) {
      iconData = Icons.warning_amber_rounded;
      iconColor = colorScheme.error;
      bgColor = colorScheme.errorContainer;
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: colorScheme.surface.withAlpha(150),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, size: 40, color: iconColor),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              article.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> _buildRichSections(BuildContext context, String content) {
  final sections = content
      .split('\n\n')
      .where((section) => section.trim().isNotEmpty)
      .toList(growable: false);

  final widgets = <Widget>[];

  for (final section in sections) {
    final lowerSection = section.toLowerCase();
    final isHighlight = lowerSection.startsWith('tip práctico:') ||
                        lowerSection.startsWith('qué hacer en casa:') ||
                        lowerSection.startsWith('recomendación clave:');

    if (isHighlight) {
      widgets.add(_HighlightCard(text: section));
    } else {
      widgets.add(_RichSectionCard(text: section));
    }
    widgets.add(const SizedBox(height: AppSpacing.md));
  }

  return widgets;
}

class _HighlightCard extends StatelessWidget {
  final String text;

  const _HighlightCard({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final parts = text.split('\n');
    final title = parts.isNotEmpty ? parts.first : '';
    final body = parts.length > 1 ? parts.sublist(1).join('\n') : '';

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colorScheme.tertiary.withAlpha(50)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: colorScheme.tertiary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onTertiaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            if (body.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              ..._parseListOrText(context, body, colorScheme.onTertiaryContainer),
            ]
          ],
        ),
      ),
    );
  }
}

class _RichSectionCard extends StatelessWidget {
  final String text;

  const _RichSectionCard({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final parts = text.split('\n');
    final title = parts.isNotEmpty && !parts.first.trim().startsWith('•') ? parts.first : '';
    final bodyLines = parts.isNotEmpty && !parts.first.trim().startsWith('•') ? parts.sublist(1) : parts;
    final body = bodyLines.join('\n');

    return Card(
      elevation: 2,
      shadowColor: colorScheme.shadow.withAlpha(50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty) ...[
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            if (body.isNotEmpty) ..._parseListOrText(context, body, colorScheme.onSurface),
          ],
        ),
      ),
    );
  }
}

List<Widget> _parseListOrText(BuildContext context, String text, Color textColor) {
  final lines = text.split('\n');
  final widgets = <Widget>[];

  for (final line in lines) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) continue;

    if (trimmed.startsWith('•')) {
      final listText = trimmed.substring(1).trim();
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs, left: AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  listText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Text(
            trimmed,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor),
          ),
        ),
      );
    }
  }
  return widgets;
}

AnemiaInfoArticle? _findArticleById(List<AnemiaInfoArticle> articles, String id) {
  for (final article in articles) {
    if (article.id == id) return article;
  }
  return null;
}
