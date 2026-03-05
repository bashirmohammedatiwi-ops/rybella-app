import 'package:flutter_test/flutter_test.dart';
import 'package:cosmatic_app/main.dart';

void main() {
  testWidgets('CosmaticApp loads without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const CosmaticApp(cartProvider: null));
    await tester.pump();
  });
}
