import 'package:flutter_test/flutter_test.dart';
import 'package:programmit_app/main.dart';

void main() {
  testWidgets('ProgramIT app builds', (WidgetTester tester) async {
    await tester.pumpWidget(const ProgramITApp());
    await tester.pump();
    expect(find.byType(ProgramITApp), findsOneWidget);
  });
}
