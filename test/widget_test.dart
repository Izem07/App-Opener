import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fed_progress_connect/main.dart';

void main() {
  testWidgets('App renders Connect title in AppBar',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ConnectApp());

    // The AppBar should show the first destination title
    expect(find.text('Connect'), findsWidgets);
  });

  testWidgets('App has a refresh button', (WidgetTester tester) async {
    await tester.pumpWidget(const ConnectApp());

    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });

  testWidgets('App destinations list is not empty',
      (WidgetTester tester) async {
    expect(appDestinations, isNotEmpty);
    expect(appDestinations.first.title, 'Connect');
  });
}
