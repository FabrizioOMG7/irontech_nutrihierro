import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';
import 'package:irontech_nutrihierro/core/theme/theme_provider.dart';
import 'package:irontech_nutrihierro/core/widgets/async_value_view.dart';
import 'package:irontech_nutrihierro/core/widgets/empty_state_view.dart';
import 'package:irontech_nutrihierro/core/widgets/responsive_content.dart';
import 'package:irontech_nutrihierro/features/profile/domain/child.dart';
import 'package:irontech_nutrihierro/features/profile/presentation/providers/profile_provider.dart';
import 'package:irontech_nutrihierro/theme/app_colors.dart';

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
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return PopScope(
      canPop: hasNavigatorBack,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && hasActiveChild) {
          _handleBackNavigation();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const SizedBox.shrink(),
          elevation: 0,
          backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: isDark ? const Color(0xFF121212) : Colors.white,
            statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          ),
          actions: [
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: isDark ? Colors.amber[600] : Colors.indigo[700],
              ),
              onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
              tooltip: isDark ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro',
            ),
          ],
        ),
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
                        // Logo de la app
                        Image.asset(
                          'assets/images/logo/logo_anemia.png',
                          height: 140,
                          width: 140,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: AppSpacing.lg),
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
