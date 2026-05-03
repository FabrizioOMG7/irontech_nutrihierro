import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';
import 'package:irontech_nutrihierro/core/widgets/async_value_view.dart';
import 'package:irontech_nutrihierro/core/widgets/empty_state_view.dart';
import 'package:irontech_nutrihierro/core/widgets/responsive_content.dart';
import 'package:irontech_nutrihierro/features/profile/domain/child.dart';
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

  static const List<Color> _avatarColors = [
    Color(0xFFE50914), // Netflix Red
    Color(0xFF0071EB), // Blue
    Color(0xFF00B020), // Green
    Color(0xFFF4B400), // Yellow
    Color(0xFF8E24AA), // Purple
    Color(0xFFE65100), // Orange
  ];

  @override
  Widget build(BuildContext context) {
    final activeChildId = ref.watch(activeChildIdProvider);
    final hasNavigatorBack = Navigator.of(context).canPop();
    final hasActiveChild = ref.watch(activeChildProvider) != null;

    return PopScope(
      canPop: hasNavigatorBack,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && hasActiveChild) {
          _handleBackNavigation();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: ResponsiveContent(
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
                return Stack(
                  children: [
                    Column(
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
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
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
                                  final avatarColor = _avatarColors[index % _avatarColors.length];

                                  return GestureDetector(
                                    onTap: () => _selectProfile(child.id),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: avatarColor,
                                                borderRadius: BorderRadius.circular(AppRadius.lg),
                                                border: Border.all(
                                                  color: isActive
                                                      ? Theme.of(context).colorScheme.onSurface
                                                      : Colors.transparent,
                                                  width: 3,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black.withAlpha(40),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  child.gender == Gender.male ? Icons.face : Icons.face_3,
                                                  size: 60,
                                                  color: Colors.white.withAlpha(220),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: AppSpacing.md),
                                        Text(
                                          child.name,
                                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
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
                        ),
                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                    if (hasActiveChild && !hasNavigatorBack)
                      Positioned(
                        top: AppSpacing.sm,
                        left: AppSpacing.sm,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: _handleBackNavigation,
                          tooltip: 'Volver',
                        ),
                      ),
                  ],
                );
              },
            ),
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
