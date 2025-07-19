import 'package:flutter_test/flutter_test.dart';
import 'package:goodbuy/app/app_widget.dart';

void main() {
  testWidgets('Mock test', (WidgetTester tester) async {
    await tester.pumpWidget(const GoodBuyApp());
  });
}
