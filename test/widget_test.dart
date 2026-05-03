import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:irontech_nutrihierro/main.dart';

void main() {
  testWidgets('Verificación de arranque con GoRouter', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MainApp(),
      ),
    );

    // Esperamos a que los providers asíncronos carguen el contenido mock (que inicializa vacío)
    await tester.pumpAndSettle();

    // Verificamos que la ruta inicial de selector cargue correctamente mostrando el estado de vacío
    expect(find.text('Aún no hay perfiles'), findsOneWidget);
  });
}
