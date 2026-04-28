import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';
import 'package:irontech_nutrihierro/core/widgets/async_value_view.dart';
import 'package:irontech_nutrihierro/core/widgets/empty_state_view.dart';
import 'package:irontech_nutrihierro/core/widgets/responsive_content.dart';
import 'package:irontech_nutrihierro/features/profile/presentation/providers/profile_provider.dart';

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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    '¿Quién está usando la app?',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Selecciona un perfil para continuar',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Expanded(
                    child: Center(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: AppSpacing.xl,
                          mainAxisSpacing: AppSpacing.xl,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: children.length,
                        itemBuilder: (context, index) {
                          final child = children[index];
                          final isActive = child.id == activeChildId;
                          return GestureDetector(
                            onTap: () => _selectProfile(child.id),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isActive
                                            ? Theme.of(context).colorScheme.primary
                                            : Colors.transparent,
                                        width: 4,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(20),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                      child: Text(
                                        child.name.characters.first.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  child.name,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                      ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (hasActiveChild) ...[
                    const SizedBox(height: AppSpacing.xl),
                    FilledButton.icon(
                      onPressed: _handleBackNavigation,
                      icon: const Icon(Icons.home_outlined),
                      label: const Text('Volver a pantalla principal'),
                    ),
                  ],
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
