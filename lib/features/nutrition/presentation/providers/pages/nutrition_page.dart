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
import 'package:irontech_nutrihierro/features/tracking/domain/daily_records_query.dart';
import 'package:irontech_nutrihierro/features/tracking/presentation/providers/tracking_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NutritionPage extends ConsumerStatefulWidget {
  const NutritionPage({super.key});

  @override
  ConsumerState<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends ConsumerState<NutritionPage> {
  String? _lastCheckedChildId;

  Future<void> _checkDailyAlert(String childId, bool hasRecordsToday) async {
    if (_lastCheckedChildId == childId) return;
    _lastCheckedChildId = childId;

    if (hasRecordsToday) return;

    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month}-${today.day}';
    final key = 'daily_alert_${childId}_$todayString';

    final hasShownToday = prefs.getBool(key) ?? false;

    if (!hasShownToday) {
      await prefs.setBool(key, true);
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('¡No olvides el hierro!'),
          content: const Text('Parece que hoy no has registrado ninguna ingesta de hierro para el perfil activo. ¡Recuerda hacerlo para llevar un buen control!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Entendido'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.push('/tracking');
              },
              child: const Text('Registrar ahora'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          final todayQuery = DailyRecordsQuery(childId: child.id, date: DateTime.now());
          final todayRecordsAsync = ref.watch(dailyRecordsProvider(todayQuery));

          return todayRecordsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (records) {
              final hasRecordsToday = records.isNotEmpty;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _checkDailyAlert(child.id, hasRecordsToday);
              });

              return ResponsiveContent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ChildHeader(
                      name: child.name,
                      ageLabel: child.formattedAge,
                      nutritionCategory: child.nutritionCategory,
                      profileType: child.ageInMonths >= 24 ? 'Niño/a' : 'Infante',
                    ),
                    if (!hasRecordsToday) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Card(
                        color: Theme.of(context).colorScheme.errorContainer,
                        child: ListTile(
                          leading: Icon(Icons.warning_amber_rounded, color: Theme.of(context).colorScheme.error),
                          title: Text('No has registrado la ingesta de hoy', style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer, fontWeight: FontWeight.bold)),
                          subtitle: Text('Es importante llevar el control diario.', style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer)),
                          trailing: FilledButton(
                            onPressed: () => context.push('/tracking'),
                            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error, foregroundColor: Theme.of(context).colorScheme.onError),
                            child: const Text('Registrar'),
                          ),
                        ),
                      ),
                    ],
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
                          return InkWell(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            onTap: () => context.push('/info/recipes/${recipe.id}'),
                            child: IronCard(
                              title: recipe.title,
                              description: recipe.description,
                              imageUrl: recipe.imageUrl,
                              trailingWidget: _IronBadge(ironContent: recipe.ironContent),
                            ),
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
  final String profileType;

  const _ChildHeader({
    required this.name,
    required this.ageLabel,
    required this.nutritionCategory,
    required this.profileType,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withAlpha(200),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: colorScheme.onPrimary,
              child: Icon(Icons.child_care, color: colorScheme.primary, size: 30),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Perfil activo: $name',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Edad: $ageLabel',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary.withAlpha(220),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Etapa: $nutritionCategory',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary.withAlpha(220),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Tipo: $profileType',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimary.withAlpha(220),
                    ),
                  ),
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
