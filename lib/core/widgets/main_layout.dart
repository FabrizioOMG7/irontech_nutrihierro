import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:irontech_nutrihierro/core/theme/app_tokens.dart';

class MainLayout extends StatelessWidget {
  // Esta variable es la que controla qué rama (pestaña) está activa
  final StatefulNavigationShell navigationShell;

  const MainLayout({super.key, required this.navigationShell});

  // Función para cambiar de pestaña al tocar la barra
  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // Si tocamos la pestaña en la que ya estamos, nos regresa a la pantalla inicial de esa pestaña
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // El 'body' es dinámico, GoRouter inyectará aquí la NutritionPage o la ProfilePage
      body: navigationShell,
      
      // Nuestra barra de navegación inferior
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        indicatorColor: AppColors.primary.withAlpha(26),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            label: 'Nutrición',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month),
            label: 'Registro',
          ),
        ],
      ),
    );
  }
}
