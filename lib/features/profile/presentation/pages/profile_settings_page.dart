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
    final activeChild = ref.watch(activeChildProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ResponsiveContent(
        child: ListView(
          children: [
            // ── Tarjeta: Perfil activo ─────────────────────────────────────
            if (activeChild != null) ...[
              _ActiveProfileCard(
                name: activeChild.name,
                age: activeChild.formattedAge,
                onManageProfiles: () => context.push('/profile-selector'),
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            Text('Ajustes del perfil', style: theme.textTheme.titleMedium),
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
              subtitle: 'Crear o eliminar perfiles y elegir perfil activo.',
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

// ──────────────────────────────────────────────────────────────────────────────
// Tarjeta mejorada de perfil activo
// ──────────────────────────────────────────────────────────────────────────────
class _ActiveProfileCard extends StatelessWidget {
  final String name;
  final String age;
  final VoidCallback onManageProfiles;

  const _ActiveProfileCard({
    required this.name,
    required this.age,
    required this.onManageProfiles,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = name.trim().isNotEmpty
        ? name.trim().characters.first.toUpperCase()
        : '?';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(
          color: AppColors.primary.withAlpha(80),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // Avatar con iniciales
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Nombre y edad
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.verified_user_outlined,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Perfil activo',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    age,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // Botón cambiar
            OutlinedButton(
              onPressed: onManageProfiles,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
              ),
              child: const Text('Cambiar'),
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
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(15),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
