import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart'; // NUEVO: Para obtener la ruta del celular
import 'package:isar/isar.dart'; // NUEVO: Importación de Isar

import 'package:irontech_nutrihierro/core/router/app_router.dart';
import 'package:irontech_nutrihierro/theme/app_theme.dart';

// NUEVO: Importa tus modelos de Isar generados (Ajusta las rutas según donde los creaste)
import 'package:irontech_nutrihierro/core/data/local_db/models/isar_child.dart';
import 'package:irontech_nutrihierro/core/data/local_db/models/isar_daily_record.dart';

// NUEVO: Creamos un Provider global para inyectar Isar
final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('Isar no inicializado');
});

void main() async {
  // 1. Asegura que Flutter esté listo antes de usar directorios nativos
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Busca la carpeta de documentos del dispositivo
  final dir = await getApplicationDocumentsDirectory();
  
  // 3. Abre la base de datos de Isar con tus esquemas (Schemas)
  final isar = await Isar.open(
    [IsarChildSchema, IsarDailyRecordSchema], // Si tienes más modelos, añádelos aquí
    directory: dir.path,
  );

  runApp(
    ProviderScope(
      // 4. Inyectamos la base de datos abierta al provider
      overrides: [
        isarProvider.overrideWithValue(isar),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget { 
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterByAgeProvider);

    return MaterialApp.router(
      title: 'IronTech NutriHierro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: const Locale('es', 'PE'),
      supportedLocales: const [
        Locale('es', 'PE'),
        Locale('es'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}