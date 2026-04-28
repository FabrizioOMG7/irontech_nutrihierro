import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';
import 'package:irontech_nutrihierro/core/widgets/async_value_view.dart';
import 'package:irontech_nutrihierro/core/widgets/empty_state_view.dart';
import 'package:irontech_nutrihierro/core/widgets/responsive_content.dart';
import 'package:irontech_nutrihierro/features/profile/presentation/providers/profile_provider.dart';
import 'package:irontech_nutrihierro/features/tracking/presentation/providers/tracking_provider.dart';

class ProfileSelectorPage extends ConsumerStatefulWidget {
  const ProfileSelectorPage({super.key});

  @override
  ConsumerState<ProfileSelectorPage> createState() => _ProfileSelectorPageState();
}

class _ProfileSelectorPageState extends ConsumerState<ProfileSelectorPage> {
  @override
  void initState() {
    super.initState();
    // Removed PostFrameCallback - let activeChildProvider handle initialization
    // This prevents redundant SharedPreferences calls during startup
  }

  Future<void> _selectProfile(String childId) async {
    await setActiveChildId(ref, childId);
    if (!mounted) return;
    context.go('/home');
  }

  Future<void> _handleBackNavigation() async {
    final activeChild = ref.read(activeChildProvider);
    if (activeChild != null && mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeChildId = ref.watch(activeChildIdProvider);
    final hasNavigatorBack = Navigator.of(context).canPop();
    final hasActiveChild = ref.watch(activeChildProvider) != null;

    return PopScope(
      canPop: hasNavigatorBack,
      onPopInvoked: (didPop) {
        if (!didPop && hasActiveChild) {
          _handleBackNavigation();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Seleccionar perfil'),
          leading: hasNavigatorBack
              ? null
              : hasActiveChild
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _handleBackNavigation,
                    )
                  : null,
        ),
        body: ResponsiveContent(
          child: AsyncValueView(
            value: ref.watch(childrenListProvider),
            errorPrefix: 'No se pudo cargar perfiles',
            loadingMessage: 'Cargando perfiles...',
            dataBuilder: (children) {
              if (children.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const EmptyStateView(
                      icon: Icons.child_care,
                      title: 'Aún no hay perfiles',
                      message: 'Registra tu primer niño/a para comenzar.',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/profile-register'),
                      icon: const Icon(Icons.add),
                      label: const Text('Registrar perfil'),
                    ),
                  ],
                );
              }
              return ListView(
                children: [
                  Text(
                    '¿Con qué perfil deseas ingresar?',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Puedes crear y cambiar entre varios perfiles sin perder su historial.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (hasActiveChild) ...[
                    const SizedBox(height: AppSpacing.md),
                    FilledButton.icon(
                      onPressed: _handleBackNavigation,
                      icon: const Icon(Icons.home_outlined),
                      label: const Text('Volver a pantalla principal'),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  for (final child in children)
                    Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            child.name.characters.first.toUpperCase(),
                          ),
                        ),
                        title: Text(child.name),
                        subtitle: Text('Edad: ${child.formattedAge}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (child.id == activeChildId)
                              const Icon(Icons.check_circle,
                                  color: AppColors.success),
                            const SizedBox(width: AppSpacing.xs),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: AppColors.error),
                              tooltip: 'Eliminar perfil',
                              onPressed: () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text(
                                        'Eliminar perfil de ${child.name}'),
                                    content: const Text(
                                      'Se eliminarán el perfil y todos sus '
                                      'registros de seguimiento. '
                                      'Esta acción no se puede deshacer.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, false),
                                        child: const Text('Cancelar'),
                                      ),
                                      FilledButton(
                                        style: FilledButton.styleFrom(
                                          backgroundColor: AppColors.error,
                                        ),
                                        onPressed: () =>
                                            Navigator.pop(ctx, true),
                                        child: const Text('Eliminar'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmed == true && context.mounted) {
                                  // Borrado en cascada: primero registros, luego perfil
                                  await ref
                                      .read(trackingControllerProvider
                                          .notifier)
                                      .deleteAllForChild(child.id);
                                  if (!context.mounted) return;
                                  await ref
                                      .read(childrenListProvider.notifier)
                                      .deleteChild(child.id);
                                  if (!context.mounted) return;
                                  // Si era el perfil activo, limpiar selección
                                  if (child.id == activeChildId) {
                                    await clearActiveChildId(ref);
                                  }
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Perfil de ${child.name} eliminado.'),
                                        backgroundColor: AppColors.success,
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                        onTap: () => _selectProfile(child.id),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xs,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.push('/profile-register'),
                icon: const Icon(Icons.add),
                label: const Text('Añadir un nuevo perfil'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
