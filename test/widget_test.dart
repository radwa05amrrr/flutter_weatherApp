import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/pages/home_page.dart';

void main() {
  testWidgets('HomePage loads correctly', (WidgetTester tester) async {
    // شغل التطبيق
    await tester.pumpWidget(const WeatherApp());

    // تأكد إن الصفحة الرئيسية ظهرت
    expect(find.byType(HomePage), findsOneWidget);

    // تأكد إن فيه TextField للبحث
    expect(find.byType(TextField), findsOneWidget);

    // تأكد إن زر search موجود
    expect(find.text('Search'), findsOneWidget);

    // تأكد إن AppBar شغال
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });
}
