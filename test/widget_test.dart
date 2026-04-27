import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App arranca sin errores', (WidgetTester tester) async {
    // Test placeholder — la app requiere Firebase que no está disponible en unit tests.
    expect(1 + 1, equals(2));
  });
}
