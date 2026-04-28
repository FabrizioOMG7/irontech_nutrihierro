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
import 'package:irontech_nutrihierro/features/profile/domain/child.dart';
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
  static const String _popupKeyPrefix = 'nutrition_popup_shown_';

  bool _bannerVisible = false;

  String _popupKey(String profileId) {
    final today = DateTime.now();
    return '$_popupKeyPrefix${profileId}_${today.year}_${today.month}_${today.day}';
  }

  Future<bool> _popupAlreadyShownToday(String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_popupKey(profileId)) ?? false;
  }

  Future<void> _markPopupShownToday(String profileId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_popupKey(profileId), true);
  }

  Future<void> _checkIntakeAndAlert(Child child) async {
    final today = DateTime.now();
    final query = DailyRecordsQuery(childId: child.id, date: today);
    final records = await ref.read(dailyRecordsProvider(query).future);

    if (!mounted) return;

    final hasIntakeToday = records.any((r) => r.wasAccepted);
    if (!hasIntakeToday) {
      setState(() => _bannerVisible = true);
      final alreadyShown = await _popupAlreadyShownToday(child.id);
      if (!alreadyShown && mounted) {
        await _markPopupShownToday(child.id);
        if (mounted) _showNoIntakeDialog(child.name);
      }
    } else {
      setState(() => _bannerVisible = false);
    }
  }

  void _showNoIntakeDialog(String childName) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.notifications_active_outlined, size: 36, color: AppColors.warning),
        title: const Text('Recordatorio de ingesta'),
        content: Text(
          'Hoy no has registrado ninguna ingesta de hierro para $childName.\n\n'
          '¡Recuerda incluir alimentos ricos en hierro en su dieta diaria!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Más tarde'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/tracking');
            },
            icon: const Icon(Icons.add),
            label: const Text('Registrar ahora'),
          ),
        ],
      ),
    );
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

          // Verificar ingesta solo cuando el perfil activo cambia o la página se construye
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _checkIntakeAndAlert(child);
          });

          final category = Recipe.getCategoryForMonths(child.ageInMonths);
          return Column(
            children: [
              // Banner permanente si no hay ingesta hoy
              if (_bannerVisible)
                _NoIntakeBanner(
                  childName: child.name,
                  onRegister: () => context.go('/tracking'),
                  onDismiss: () => setState(() => _bannerVisible = false),
                ),
              Expanded(
                child: ResponsiveContent(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ChildHeader(
                        name: child.name,
                        ageLabel: child.formattedAge,
                        nutritionCategory: child.nutritionCategory,
                        profileType: child.ageInMonths >= 24 ? 'Niño/a' : 'Infante',
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
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Banner permanente de alerta de ingesta
class _NoIntakeBanner extends StatelessWidget {
  final String childName;
  final VoidCallback onRegister;
  final VoidCallback onDismiss;

  const _NoIntakeBanner({
    required this.childName,
    required this.onRegister,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.warning,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'Sin ingesta registrada hoy para $childName',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: onRegister,
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              child: const Text('Registrar'),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 18),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
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
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withAlpha(200),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withAlpha(50),
            child: Text(
              name.characters.first.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '$ageLabel • $profileType',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                  child: Text(
                    nutritionCategory,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
