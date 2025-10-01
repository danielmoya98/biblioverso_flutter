import 'package:biblioverso_flutter/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('La app carga y muestra el texto Bienvenido',
          (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());

        // Ajusta el texto esperado según tu pantalla inicial
        expect(find.text('Bienvenido'), findsOneWidget);
      });
}
