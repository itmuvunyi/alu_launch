import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alu_launch/features/authentication/presentation/screens/splash_screen.dart';

void main() {
  testWidgets('Splash Screen renders branding text and details', (WidgetTester tester) async {
    // Build the SplashScreen widget inside a MaterialApp.
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(),
      ),
    );

    // Verify that the splash screen branding text is displayed.
    expect(find.text('ALU Launch'), findsOneWidget);
    expect(find.text('Connecting students to the future of work'), findsOneWidget);
  });
}
