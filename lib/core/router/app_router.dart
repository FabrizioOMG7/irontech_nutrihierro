import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:irontech_nutrihierro/features/nutrition/presentation/providers/pages/nutrition_page.dart';
import 'package:irontech_nutrihierro/features/profile/presentation/pages/profile_settings_page.dart';
import 'package:irontech_nutrihierro/features/tracking/presentation/tracking_page.dart';

// Importamos tus pantallas y el layout
import '../../features/profile/presentation/pages/profile_register_page.dart';
import '../widgets/main_layout.dart'; // <-- El cascarón que acabamos de crear

final appRouterByAgeProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/profile-register',
    routes: [
      // 1. RUTA FUERA DEL CASCARÓN (Pantalla completa, sin menú inferior)
      GoRoute(
        path: '/profile-register',
        builder: (context, state) => const ProfileRegisterPage(),
      ),

      // 2. RUTAS DENTRO DEL CASCARÓN (Con barra de navegación)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // Aquí inyectamos el MainLayout
          return MainLayout(navigationShell: navigationShell);
        },
        branches: [
          // PESTAÑA 0: Nutrición
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const NutritionPage(),
              ),
            ],
          ),
          
          // PESTAÑA 1: Ajustes / Perfil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile-settings',
                builder: (context, state) => const ProfileSettingsPage(),
              ),
            ],
          ),
          // PESTAÑA 2: Seguimiento Diario
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tracking',
                builder: (context, state) => const TrackingPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
