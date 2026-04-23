import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';
import 'package:irontech_nutrihierro/core/widgets/responsive_content.dart';
import 'package:irontech_nutrihierro/features/profile/presentation/providers/profile_provider.dart';

class ProfileSettingsPage extends ConsumerWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ResponsiveContent(
        child: ListView(
          children: [
            Text('Ajustes del perfil', style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.md),
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
                await clearActiveChildId(ref);
                if (context.mounted) context.go('/profile-selector');
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
  final VoidCallback? onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
