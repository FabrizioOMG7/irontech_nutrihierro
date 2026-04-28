import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';
import 'package:irontech_nutrihierro/core/widgets/async_value_view.dart';
import 'package:irontech_nutrihierro/core/widgets/empty_state_view.dart';
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

  Future<bool> _confirmExit() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Salir al selector?'),
        content: const Text(
          'Estás a punto de volver al selector de perfiles. ¿Deseas continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
    return result ?? false;
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
        backgroundColor: const Color(0xFF141414),
        appBar: AppBar(
          backgroundColor: const Color(0xFF141414),
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Seleccionar perfil',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          leading: hasNavigatorBack
              ? null
              : hasActiveChild
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () async {
                        final shouldExit = await _confirmExit();
                        if (shouldExit && mounted) _handleBackNavigation();
                      },
                    )
                  : null,
        ),
        body: AsyncValueView(
          value: ref.watch(childrenListProvider),
          errorPrefix: 'No se pudo cargar perfiles',
          loadingMessage: 'Cargando perfiles...',
          dataBuilder: (children) {
            if (children.isEmpty) {
              return Center(
                child: Column(
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
                ),
              );
            }
            return Column(
              children: [
                const SizedBox(height: AppSpacing.md),
                Text(
                  '¿Quién está usando la app?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Selecciona tu perfil para continuar',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                if (hasActiveChild) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: FilledButton.icon(
                      onPressed: _handleBackNavigation,
                      icon: const Icon(Icons.home_outlined),
                      label: const Text('Volver a pantalla principal'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 160,
                      mainAxisExtent: 160,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                    ),
                    itemCount: children.length,
                    itemBuilder: (context, index) {
                      final child = children[index];
                      final isActive = child.id == activeChildId;
                      return _ProfileCard(
                        name: child.name,
                        ageLabel: child.formattedAge,
                        isActive: isActive,
                        onTap: () => _selectProfile(child.id),
                      );
                    },
                  ),
                ),
              ],
            );
          },
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
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Añadir un nuevo perfil',
                  style: TextStyle(color: Colors.white),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white38),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String name;
  final String ageLabel;
  final bool isActive;
  final VoidCallback onTap;

  const _ProfileCard({
    required this.name,
    required this.ageLabel,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isNotEmpty
        ? name.trim().characters.first.toUpperCase()
        : '?';

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isActive
                        ? [AppColors.primary, AppColors.secondary]
                        : [Colors.grey.shade700, Colors.grey.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: isActive
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: isActive
                          ? AppColors.primary.withAlpha(100)
                          : Colors.black38,
                      blurRadius: isActive ? 12 : 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              if (isActive)
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF141414), width: 2),
                  ),
                  child: const Icon(Icons.check, size: 12, color: Colors.white),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            ageLabel,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
