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

    // Verificamos que la ruta inicial de registro cargue correctamente
    expect(find.text('Registrar Niño/a'), findsOneWidget);
  });
}
