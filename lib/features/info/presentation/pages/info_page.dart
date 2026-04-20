import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';
import 'package:irontech_nutrihierro/core/widgets/async_value_view.dart';
import 'package:irontech_nutrihierro/core/widgets/empty_state_view.dart';
import 'package:irontech_nutrihierro/core/widgets/responsive_content.dart';
import 'package:irontech_nutrihierro/features/info/domain/anemia_info_article.dart';
import 'package:irontech_nutrihierro/features/info/presentation/providers/info_provider.dart';

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
              itemCount: articles.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final article = articles[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.article_outlined),
                    title: Text(article.title),
                    subtitle: const Text('Toca para leer más'),
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
                Text(article.content, style: Theme.of(context).textTheme.bodyLarge),
              ],
            );
          },
        ),
      ),
    );
  }
}

AnemiaInfoArticle? _findArticleById(List<AnemiaInfoArticle> articles, String id) {
  for (final article in articles) {
    if (article.id == id) return article;
  }
  return null;
}
