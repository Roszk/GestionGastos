import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gastos/main.dart'; // Asegúrate de que el import del archivo principal es correcto

void main() {
  testWidgets('Prueba básica de la aplicación', (WidgetTester tester) async {
    // Construir la aplicación principal y desencadenar un frame
    await tester.pumpWidget(MyApp());

    // Verifica que la pantalla inicial muestra "Iniciar sesión"
    expect(find.text('Iniciar sesión'), findsOneWidget);

    // Intenta encontrar algo que no debería estar en la pantalla
    expect(find.text('No existe'), findsNothing);
  });
}
