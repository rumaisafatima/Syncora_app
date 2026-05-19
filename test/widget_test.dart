// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/main.dart';
import 'package:app/controllers/auth_controller.dart';

void main() {
  testWidgets('App loads splash screen test', (WidgetTester tester) async {
    // Mock SharedPreferences to prevent hanging in tests
    SharedPreferences.setMockInitialValues({});

    // Initialize AuthController
    final authController = AuthController();
    await authController.init();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: authController,
        child: const MyApp(),
      ),
    );

    // Verify that the MaterialApp is found
    expect(find.byType(MaterialApp), findsOneWidget);

    // Advance the virtual clock to trigger splash screen navigation timer and clear it
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });
}
