// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bilibili/main.dart';

void main() {
  testWidgets('检查应用是否能正常启动', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BilibiliApp());

    // Verify that the AppBar title is present.
    expect(find.text('哔哩哔哩 - 热门视频'), findsOneWidget);

    // Verify that a loading indicator is initially displayed.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // We can't actually wait for the network request to finish in a simple widget test,
    // but we can check if the ListView appears eventually.
    //
    // For more advanced testing, we would use mocking to simulate the network response.
    // However, for this basic test, we'll just check for the list after pumping.
    //
    // This is a simplified check for the purpose of getting rid of the error.
    await tester.pumpAndSettle(); // 等待所有动画和帧完成

    // Verify that the ListView is present after loading.
    expect(find.byType(ListView), findsOneWidget);
  });
}