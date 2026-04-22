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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await restoreActiveChildId(ref);
      } catch (error, stackTrace) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'profile_selector_page',
            context: ErrorDescription('while restoring active profile id'),
          ),
        );
      }
    });
  }

  Future<void> _selectProfile(String childId) async {
    await setActiveChildId(ref, childId);
    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final activeChildId = ref.watch(activeChildIdProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Seleccionar perfil')),
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: ListView.builder(
                    itemCount: children.length,
                    itemBuilder: (context, index) {
                      final child = children[index];
                      final isActive = child.id == activeChildId;
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              child.name.characters.first.toUpperCase(),
                            ),
                          ),
                          title: Text(child.name),
                          subtitle: Text('Edad: ${child.formattedAge}'),
                          trailing: isActive
                              ? const Icon(Icons.check_circle, color: AppColors.success)
                              : const Icon(Icons.chevron_right),
                          onTap: () => _selectProfile(child.id),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => context.push('/profile-register'),
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar otro perfil'),
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
