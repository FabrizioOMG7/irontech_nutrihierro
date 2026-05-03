import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';
import 'package:irontech_nutrihierro/core/widgets/responsive_content.dart';
import 'package:irontech_nutrihierro/features/profile/presentation/providers/profile_provider.dart';
import 'package:irontech_nutrihierro/core/theme/theme_provider.dart';

class ProfileSettingsPage extends ConsumerWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ResponsiveContent(
        child: ListView(
          children: [
            Text('Ajustes del perfil', style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                secondary: const Icon(Icons.dark_mode_outlined),
                title: const Text('Modo oscuro'),
                subtitle: const Text('Cambiar la apariencia de la aplicación.'),
                value: themeMode == ThemeMode.dark,
                onChanged: (bool value) {
                  ref.read(themeModeProvider.notifier).toggleTheme();
                },
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _SettingsItem(
              icon: Icons.child_care,
              title: 'Perfil del niño/a',
              subtitle: 'Actualiza nombre, fecha de nacimiento y género.',
              onTap: () => context.push('/child-profile'),
            ),
            _SettingsItem(
              icon: Icons.notifications_active_outlined,
              title: 'Alertas',
              subtitle: 'Gestiona alertas y marca recordatorios como leídos.',
              onTap: () => context.push('/alerts'),
            ),
            _SettingsItem(
              icon: Icons.people_alt_outlined,
              title: 'Perfiles infantiles',
              subtitle: 'Crear más perfiles y elegir perfil activo.',
              onTap: () => context.push('/profile-selector'),
            ),
            _SettingsItem(
              icon: Icons.home_outlined,
              title: 'Ir a pantalla principal',
              subtitle: 'Regresa al inicio sin cambiar de perfil.',
              onTap: () => context.go('/home'),
            ),
            _SettingsItem(
              icon: Icons.logout,
              title: 'Salir del perfil actual',
              subtitle: 'Vuelve al selector sin borrar datos guardados.',
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Salir del perfil'),
                    content: const Text('¿Deseas salir de este perfil y volver al selector?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Salir'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  await clearActiveChildId(ref);
                  if (context.mounted) context.go('/profile-selector');
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _SettingsItem(
              icon: Icons.delete_forever,
              title: 'Eliminar perfil',
              subtitle: 'Borra todos los datos de este niño/a de forma permanente.',
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: () async {
                final child = ref.read(activeChildProvider);
                if (child == null) return;

                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Eliminar perfil'),
                    content: Text('¿Deseas eliminar permanentemente el perfil de "${child.name}" y todos sus registros? Esta acción no se puede deshacer.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancelar'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        style: FilledButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Sí, eliminar'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true) {
                  await ref.read(childrenListProvider.notifier).deleteChild(child.id);
                  await clearActiveChildId(ref);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Perfil eliminado correctamente.'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    context.go('/profile-selector');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: TextStyle(color: textColor, fontWeight: textColor != null ? FontWeight.bold : null)),
        subtitle: Text(subtitle, style: TextStyle(color: textColor?.withAlpha(200))),
        trailing: Icon(Icons.chevron_right, color: iconColor),
        onTap: onTap,
      ),
    );
  }
}
