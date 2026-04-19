import 'package:flutter_test/flutter_test.dart';
import 'package:programmit_app/app.dart';

void main() {
  testWidgets('ProgramITApp mounts without throwing', (tester) async {
    await tester.pumpWidget(const ProgramITApp());
    await tester.pump();
    expect(find.byType(ProgramITApp), findsOneWidget);
  });
}
