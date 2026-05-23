import 'package:flutter_test/flutter_test.dart';
import 'package:easytrip/main.dart';

void main() {
  testWidgets('EasyTripApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EasyTripApp());

    // Verify that the explore page title or search hint is present.
    expect(find.text('Descubra lugares'), findsOneWidget);
  });
}
